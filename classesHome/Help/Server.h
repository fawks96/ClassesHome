//
//  Server.h
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Question.h"
#import "Answer.h"

#define DEFAULT_SERVER [Server defaultServer]

///处理结果回调
typedef void (^HandleResultBlock)(BOOL success, id resultObj, NSString *msg);



@interface Server : NSObject

+ (instancetype)defaultServer;

- (void)registWithUserName:(NSString *)aUserName password:(NSString *)aPassword result:(HandleResultBlock)resultBlock;
- (void)loginWithUserName:(NSString *)aUserName password:(NSString *)aPassword result:(HandleResultBlock)resultBlock;
- (void)uploadUrl:(NSString *)anUrlStr toCourse:(NSString *)aCourseName withProgress:(void (^) (CGFloat progress))progressBlock result:(HandleResultBlock)resultBlock;
- (void)getFileListOfCourse:(NSString *)aCourseName withResult:(HandleResultBlock)resultBlcok;

- (BOOL)isFileUploadByMe:(NSString *)aFileName inCourse:(NSString *)aCourseName;
- (void)deleteFileWithName:(NSString *)aFileName inCourse:(NSString *)aCourseName;

- (void)addQuestion:(Question *)aQuestion result:(HandleResultBlock)resultBlock;
- (void)getQuestionListOfCourse:(NSString *)courseName result:(HandleResultBlock)resultBlock;
- (void)answerQuestion:(Question *)aQuestion withAnswer:(Answer *)anAnswer result:(HandleResultBlock)resultBlock;


@end
