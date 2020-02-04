//
//  CourseServerFolder.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "CourseServerFolder.h"
#import "User.h"

@implementation CourseServerFolder

+ (instancetype)courseFolderWithCourseName:(NSString *)aCourseName
{
    return [self courseFolderWithMiddlePath:@"ServerFiles" courseName:aCourseName];
}

- (void)addFileWithName:(NSString *)aFileName fromUrl:(NSURL *)aUrl
{
    [super addFileWithName:aFileName fromUrl:aUrl];
    
    self.infoDic[aFileName] = CURRENT_USER.userName;
    [self saveInfoPlist];
}

- (BOOL)isFileUploadByMe:(NSString *)aFileName
{
    NSString *uploaderUserName = self.infoDic[aFileName];
    if ([uploaderUserName isEqualToString:CURRENT_USER.userName]) {
        return YES;
    }
    
    return NO;
}

- (NSMutableArray *)getMyUploadFiles
{
    NSArray *allFileArr = [self getFileList];
    NSMutableArray *fileArr = [NSMutableArray array];
    for (CourseFile *file in allFileArr) {
        if ([self isFileUploadByMe:file.fileName]) {
            [fileArr addObject:file];
        }
    }
    
    return fileArr;
}

+ (NSMutableArray *)getMyUploadFiles
{
    NSMutableArray *fileArr = [NSMutableArray array];
    
    NSString *uploadPath = [PROJ_DOC_PATH stringByAppendingPathComponent:@"ServerFiles"];
    NSArray *subDirectoryArr = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:uploadPath error:nil];
    for (NSString *courseName in subDirectoryArr) {
        CourseServerFolder *folder = [CourseServerFolder courseFolderWithCourseName:courseName];
        [fileArr addObjectsFromArray:[folder getMyUploadFiles]];
    }
    
    return fileArr;
}

@end

