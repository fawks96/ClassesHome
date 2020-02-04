//
//  Server.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "Server.h"
#import <objc/runtime.h>
#import "CourseServerFolder.h"
#import "CourseDownloadFolder.h"
#import "User.h"

#define kServerSaveKey @"kServerSaveKey"

#define SERVER_FILE_PATH_FOR_COURSE(__courseName) [SERVER_FILE_PATH stringByAppendingPathComponent:__courseName]
#define DOWNLOAD_FILE_PATH_FOR_COURSE(__courseName) [DOWNLOAD_FILE_PATH stringByAppendingPathComponent:__courseName]

@interface Server()<NSURLSessionDownloadDelegate>{
    
}

@property (nonatomic,strong)NSMutableArray *userArr;
@property (nonatomic,strong)NSMutableDictionary *serverFileDic;
@property (nonatomic,strong)NSMutableDictionary *downloadFileDic;
@property (nonatomic,strong)NSMutableArray *questionArr;

@end





@implementation Server


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyArr = @[@"userArr", @"questionArr"];
    
    for (NSString *keyName in propertyArr) {
        NSString *value = [self valueForKeyPath:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSArray *propertyArr = @[@"userArr", @"questionArr"];
    if (self = [super init]) {
        for (NSString *keyName in propertyArr) {
            if ([aDecoder containsValueForKey:keyName]) {
                id value = [aDecoder decodeObjectForKey:keyName];
                [self setValue:value forKeyPath:keyName];
            }
        }
    }
    return self;
}


+ (instancetype)defaultServer
{
    static Server *server = nil;
    
    if (!server) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kServerSaveKey];
        if (data) {
            server = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            server = [[Server alloc]init];
            server.userArr = [NSMutableArray array];
            server.serverFileDic = [NSMutableDictionary dictionary];
            server.downloadFileDic = [NSMutableDictionary dictionary];
            [server save];
        }
        if (!server.questionArr) {
            server.questionArr = [NSMutableArray array];
        }
    }
    
    return server;
}

- (NSMutableDictionary *)infoDicInPath:(NSString *)aPath
{
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:[aPath stringByAppendingPathComponent:@"info.plist"]];
    return infoDic;
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kServerSaveKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)registWithUserName:(NSString *)aUserName password:(NSString *)aPassword result:(HandleResultBlock)resultBlock
{
    for (User *user in _userArr) {
        if ([user.userName isEqualToString:aUserName]) {
            if (resultBlock) {
                resultBlock(NO, user, @"用户名已存在");
            }
            return;
        }
    }
    
    User *user = [[User alloc]init];
    
    user.userName = aUserName;
    user.password = aPassword;
    
    [_userArr addObject:user];
    [self save];
    
    [User setCurrentUser:user];
    
    if (resultBlock) {
        resultBlock(YES, user, @"注册成功");
    }
}


- (void)loginWithUserName:(NSString *)aUserName password:(NSString *)aPassword result:(HandleResultBlock)resultBlock
{
    for (User *user in _userArr) {
        if ([user.userName isEqualToString:aUserName]) {
            if (resultBlock) {
                [User setCurrentUser:user];
                resultBlock(YES, user, @"登录成功");
            }
            return;
        }
    }
    
    if (resultBlock) {
        resultBlock(NO, nil, @"用户名不存在");
    }
}


- (void)addQuestion:(Question *)aQuestion result:(HandleResultBlock)resultBlock
{
    [_questionArr addObject:aQuestion];
    [self save];
    
    if (resultBlock) {
        resultBlock(YES, aQuestion, @"提问发布成功");
    }
}

- (void)getQuestionListOfCourse:(NSString *)courseName result:(HandleResultBlock)resultBlock
{
    NSMutableArray *arr = [NSMutableArray array];
    for (Question *ques in _questionArr) {
        if ([ques.course isEqualToString:courseName]) {
            [arr addObject:ques];
        }
    }
    if (resultBlock) {
        resultBlock(YES, arr, @"获取成功");
    }
}

- (void)answerQuestion:(Question *)aQuestion withAnswer:(Answer *)anAnswer result:(HandleResultBlock)resultBlock
{
    [aQuestion.answerArr addObject:anAnswer];
    [self save];
    if (resultBlock) {
        resultBlock(YES, nil, @"回答成功");
    }
}

- (NSString *)valueForParam:(NSString *)aParam fromUrl:(NSString *)aUrl
{
    if (!aParam.length || !aUrl.length) {
        return nil;
    }
    
    NSString *regStr = [NSString stringWithFormat:@"(?<=[&?]%@=).+(?=&)|(?<=[&?]%@=).+(?=$)",aParam,aParam];
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regStr options:0 error:nil];
    NSTextCheckingResult *matchResult = [regExp firstMatchInString:aUrl options:0 range:NSMakeRange(0, aUrl.length)];
    if (matchResult) {
        NSString *value = [aUrl substringWithRange:matchResult.range];
        return value;
    }else{
        return nil;
    }
    
}

- (void)uploadUrl:(NSString *)anUrlStr toCourse:(NSString *)aCourseName withProgress:(void (^) (CGFloat progress))progressBlock result:(HandleResultBlock)resultBlock
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[anUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:urlRequest];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (progressBlock) {
        userInfo[@"progressBlock"] = progressBlock;
    }
    if (resultBlock) {
        userInfo[@"resultBlock"] = resultBlock;
    }
    userInfo[@"courseName"] = aCourseName;
    objc_setAssociatedObject(task, (__bridge const void *)(task), userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [task resume];
}

- (void)getFileListOfCourse:(NSString *)aCourseName withResult:(HandleResultBlock)resultBlcok
{
    if (resultBlcok) {
        CourseServerFolder *folder = [CourseServerFolder courseFolderWithCourseName:aCourseName];
        NSArray *arr = [folder getFileList];
        resultBlcok(YES, arr, nil);
    }
}


- (BOOL)isFileUploadByMe:(NSString *)aFileName inCourse:(NSString *)aCourseName
{
    CourseServerFolder *folder = [CourseServerFolder courseFolderWithCourseName:aCourseName];
    return [folder isFileUploadByMe:aFileName];
}

- (void)deleteFileWithName:(NSString *)aFileName inCourse:(NSString *)aCourseName
{
    CourseServerFolder *folder = [CourseServerFolder courseFolderWithCourseName:aCourseName];
    [folder deleteFileWithName:aFileName];
}

#pragma mark -
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat progress = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"进度：%.1f",progress);
    NSDictionary *userInfo = objc_getAssociatedObject(downloadTask, (__bridge const void *)(downloadTask));
    void (^progressBlock)(CGFloat progress) = userInfo[@"progressBlock"];
    if (progressBlock) {
        progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"位置：%@",location);
    
    NSDictionary *userInfo = objc_getAssociatedObject(downloadTask, (__bridge const void *)(downloadTask));
    NSString *courseName = userInfo[@"courseName"];
    HandleResultBlock resultBlock = userInfo[@"resultBlock"];
    
    CourseServerFolder *serverFolder = [CourseServerFolder courseFolderWithCourseName:courseName];
    
//    NSString *fileName = [self valueForParam:@"filename" fromUrl:downloadTask.originalRequest.URL.absoluteString]
    NSString *fileName = [self valueForParam:@"p" fromUrl:downloadTask.originalRequest.URL.absoluteString];
    fileName = [fileName stringByRemovingPercentEncoding];
    if (!fileName.length) {
        fileName = downloadTask.originalRequest.URL.absoluteString.lastPathComponent;
    }
    fileName = [fileName stringByRemovingPercentEncoding];
    
    [serverFolder addFileWithName:fileName fromUrl:location];
    
    ScoreRecord *record = [[ScoreRecord alloc]init];
    record.score = 10.;
    record.reason = [NSString stringWithFormat:@"上传文件《%@》到%@",fileName,courseName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    record.time = [dateFormatter stringFromDate:[NSDate date]];
    [CURRENT_USER.scoreRecordArr addObject:record];
    CURRENT_USER.score += 10.;
    [self save];
    
    if (resultBlock) {
        resultBlock(YES, nil, @"上传成功");
    }

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error) {
        NSLog(@"%@",error);
        NSDictionary *userInfo = objc_getAssociatedObject(task, (__bridge const void *)(task));
        HandleResultBlock resultBlock = userInfo[@"resultBlock"];
        if (resultBlock) {
            resultBlock(NO, nil, error.localizedDescription);
        }
    }
}

@end

