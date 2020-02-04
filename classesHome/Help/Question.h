//
//  Question.h
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answer.h"
#import "User.h"

@interface Question : NSObject

@property (nonatomic,strong)User *user;
@property (nonatomic,copy)NSDate *time;
@property (nonatomic,copy)NSString *course;
@property (nonatomic,copy)NSString *question;
@property (nonatomic,copy)NSString *questionDetail;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSMutableArray <__kindof Answer *> *answerArr;

@end

