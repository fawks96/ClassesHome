//
//  CourseFolder.h
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROJ_DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface CourseFolder : NSObject

@property (nonatomic,copy)NSString *middlePath;
@property (nonatomic,copy)NSString *courseName;
@property (nonatomic,copy)NSString *path;

+ (instancetype)courseFolderWithCourseName:(NSString *)aCourseName;
+ (instancetype)courseFolderWithMiddlePath:(NSString *)aMiddlePath courseName:(NSString *)aCourseName;

- (void)addFileWithName:(NSString *)aFileName fromUrl:(NSURL *)aUrl;
- (NSMutableArray *)getFileList;

- (void)deleteFileWithName:(NSString *)aFileName;

@property (nonatomic,strong)NSMutableDictionary *infoDic;
- (void)saveInfoPlist;


@end



@interface CourseFile : NSObject

@property (nonatomic,copy)NSString *courseName;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString *path;

@end

