//
//  AnswerEditController.h
//  classesHome
//
//  Created by fawks96 on 16/10/21.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnswerResultBlock)(NSString *answer);

@interface AnswerEditController : UIViewController


+ (void)editAnswerWithResult:(AnswerResultBlock)resultBlock;

@end
