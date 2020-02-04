//
//  WeekViewLabel.m
//  classesHome
//
//  Created by fawks96 on 16/2/12.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "WeekViewLable.h"
#import "testViewController.h"
@implementation WeekViewLable

//处理每个label（课程）的点击事件
- (void)click:(UITapGestureRecognizer *)gesture
{
    //设置代理，通知代理点击事件的发生
    NSLog(@"====%ld,",gesture.view.tag);
    UILabel *label = (UILabel*)gesture.view;
    NSLog(@"%@",label.text);

   
    
}

//给每一个label添加手势
-(void)layoutSubviews
{
    [super layoutSubviews];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
//    tap.numberOfTouchesRequired = 1;
//    [self addGestureRecognizer:tap];
    
}
- (void)setText:(NSString *)text {
    [super setText:text];
    
    if ([text isEqualToString:@""]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if ([[[text componentsSeparatedByString:@"\n"] lastObject] isEqualToString:@"未开课"]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
