//
//  CourseDownloadFolder.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "CourseDownloadFolder.h"
#import "User.h"

@implementation CourseDownloadFolder

+ (instancetype)courseFolderWithCourseName:(NSString *)aCourseName
{
    return [self courseFolderWithMiddlePath:@"DownloadFiles" courseName:aCourseName];
}

- (void)addFileWithName:(NSString *)aFileName fromUrl:(NSURL *)aUrl
{
    [super addFileWithName:aFileName fromUrl:aUrl];
    
    NSMutableArray *downloadUserArr = self.infoDic[aFileName];
    downloadUserArr = [NSMutableArray arrayWithArray:downloadUserArr];
    if (![downloadUserArr containsObject:CURRENT_USER.userName]) {
        [downloadUserArr addObject:CURRENT_USER.userName];
    }
    
    self.infoDic[aFileName] = downloadUserArr;
    [self saveInfoPlist];
}

- (void)downloadFile:(CourseFile *)aFile
{
    [self addFileWithName:aFile.fileName fromUrl:[NSURL fileURLWithPath:aFile.path]];
}

- (NSMutableArray *)getFileList
{
    NSMutableArray *fileArr = [super getFileList];
    
    NSMutableIndexSet *removeIndexSet = [NSMutableIndexSet indexSet];
    for (CourseFile *file in fileArr) {
        NSArray *downloadUserArr = self.infoDic[file.fileName];
        if (![downloadUserArr containsObject:CURRENT_USER.userName]) {
            [removeIndexSet addIndex:[fileArr indexOfObject:file]];
        }
    }
    
    [fileArr removeObjectsAtIndexes:removeIndexSet];
    
    return fileArr;
}


- (void)deleteFileWithName:(NSString *)aFileName
{
    NSMutableArray *downloadUserArr = self.infoDic[aFileName];
    downloadUserArr = [NSMutableArray arrayWithArray:downloadUserArr];
    [downloadUserArr removeObject:CURRENT_USER.userName];
    self.infoDic[aFileName] = downloadUserArr;
    
    if (downloadUserArr.count == 0) {
        [super deleteFileWithName:aFileName];
    }else{
        [self saveInfoPlist];
    }
}

- (BOOL)isFileDownloadByMe:(NSString *)aFileName
{
    NSMutableArray *downloadUserArr = self.infoDic[aFileName];
    return [downloadUserArr containsObject:CURRENT_USER.userName];
}

- (NSMutableArray *)getMyDownloadFiles
{
    NSArray *allFileArr = [self getFileList];
    NSMutableArray *fileArr = [NSMutableArray array];
    for (CourseFile *file in allFileArr) {
        if ([self isFileDownloadByMe:file.fileName]) {
            [fileArr addObject:file];
        }
    }
    
    return fileArr;
}

+ (NSMutableArray *)getMyDownloadFiles
{
    NSMutableArray *fileArr = [NSMutableArray array];
    
    NSString *downloadPath = [PROJ_DOC_PATH stringByAppendingPathComponent:@"DownloadFiles"];
    NSArray *subDirectoryArr = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:downloadPath error:nil];
    for (NSString *courseName in subDirectoryArr) {
        CourseDownloadFolder *folder = [CourseDownloadFolder courseFolderWithCourseName:courseName];
        [fileArr addObjectsFromArray:[folder getMyDownloadFiles]];
    }
    
    return fileArr;
}

@end


