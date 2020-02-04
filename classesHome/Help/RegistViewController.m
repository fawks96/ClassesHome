//
//  RegistViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "RegistViewController.h"
#import "SVProgressHUD.h"
#import "Server.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTf;

- (IBAction)onConfirm:(id)sender;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onConfirm:(id)sender {
    if (!_userNameTf.text.length) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    
    if (!_passwordTf.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (![_passwordTf.text isEqualToString:_passwordAgainTf.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    [DEFAULT_SERVER registWithUserName:_userNameTf.text password:_passwordTf.text result:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self onClose:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (IBAction)onClose:(id)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
