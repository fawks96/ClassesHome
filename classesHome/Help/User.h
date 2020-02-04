//
//  User.h
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CURRENT_USER [User currentUser]

@interface User : NSObject

+ (void)setCurrentUser:(User *)aUser;
+ (User *)currentUser;


@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,strong)UIImage *headImage;
@property (nonatomic,assign)CGFloat score;
@property (nonatomic,strong)NSMutableArray *scoreRecordArr;

@end




@interface ScoreRecord : NSObject

@property (nonatomic,assign)CGFloat score;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *reason;

@end