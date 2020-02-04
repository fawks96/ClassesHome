//
//  CourseDownloadFolder.h
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "CourseFolder.h"

@interface CourseDownloadFolder : CourseFolder

- (void)downloadFile:(CourseFile *)aFile;

+ (NSMutableArray *)getMyDownloadFiles;

@end
