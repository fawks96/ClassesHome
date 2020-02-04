//
//  Answer.h
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface Answer : NSObject


@property (nonatomic,strong)User *user;
@property (nonatomic,copy)NSString *answer;
@property (nonatomic,copy)NSDate *time;


@end
