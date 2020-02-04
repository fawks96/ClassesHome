//
//  SettingViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "SettingViewController.h"
#import "User.h"

@interface SettingViewController()

@property (strong, nonatomic) IBOutlet UIButton *quitLogBtn;
- (IBAction)onQuitLog:(id)sender;

@end

@implementation SettingViewController

- (IBAction)onQuitLog:(id)sender {
    [User setCurrentUser:nil];
    [self.tabBarController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
