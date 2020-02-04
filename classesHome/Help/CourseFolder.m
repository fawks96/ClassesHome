//
//  CourseFolder.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "CourseFolder.h"
#import "User.h"


@interface CourseFolder()

@property (nonatomic,copy)NSString *infoPlistPath;

@end


@implementation CourseFolder

+ (instancetype)courseFolderWithCourseName:(NSString *)aCourseName
{
    return [self courseFolderWithMiddlePath:nil courseName:aCourseName];
}

+ (instancetype)courseFolderWithMiddlePath:(NSString *)aMiddlePath courseName:(NSString *)aCourseName
{
    CourseFolder *folder = [[self alloc]initWithMiddlePath:aMiddlePath courseName:aCourseName];
    
    return folder;
}

- (instancetype)initWithMiddlePath:(NSString *)aMiddlePath courseName:(NSString *)aCourseName
{
    self = [super init];
    if (self) {
        NSString *path = PROJ_DOC_PATH;
        if (aMiddlePath.length) {
            path = [path stringByAppendingPathComponent:aMiddlePath];
        }
        path = [path stringByAppendingPathComponent:aCourseName];
        self.middlePath = aMiddlePath;
        self.courseName = aCourseName;
        self.path = path;
        self.infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
        self.infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:_infoPlistPath];
        if (!self.infoDic) {
            self.infoDic = [NSMutableDictionary dictionary];
        }
        [self createDirectory];
        NSLog(@"文件夹路径：%@",_path);
    }
    return self;
}


- (void)createDirectory
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic writeToFile:_infoPlistPath atomically:YES];
    }
}

- (void)addFileWithName:(NSString *)aFileName fromUrl:(NSURL *)aUrl
{
    NSString *toPath = [_path stringByAppendingPathComponent:aFileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:toPath]) {
        NSURL *toUrl = [NSURL fileURLWithPath:toPath];
        [[NSFileManager defaultManager]copyItemAtURL:aUrl toURL:toUrl error:nil];
    }
}

- (void)deleteFileWithName:(NSString *)aFileName
{
    NSString *filePath = [_path stringByAppendingPathComponent:aFileName];
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    [_infoDic removeObjectForKey:aFileName];
    [self saveInfoPlist];
}

- (NSMutableArray *)getFileList
{
    NSMutableArray *fileArr = [NSMutableArray array];
    NSArray *arr = [[NSFileManager defaultManager]subpathsAtPath:_path];
    for (NSString *fileName in arr) {
        if ([fileName isEqualToString:@"info.plist"]) {
            continue;
        }
        CourseFile *file = [[CourseFile alloc]init];
        file.courseName = _courseName;
        file.fileName = fileName;
        file.path = [_path stringByAppendingPathComponent:fileName];
        [fileArr addObject:file];
    }
    
    return fileArr;
}

- (void)saveInfoPlist
{
    [_infoDic writeToFile:_infoPlistPath atomically:YES];
}

#pragma mark -
#pragma mark - setters
- (void)setInfoDic:(NSMutableDictionary *)infoDic
{
    _infoDic = infoDic;
    
    [self saveInfoPlist];
}




@end








@implementation CourseFile


@end


