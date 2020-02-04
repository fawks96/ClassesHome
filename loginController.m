//
//  loginController.m
//  classesHome
//
//  Created by fawks96 on 16/2/11.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "loginController.h"
#import "Server.h"
#import "SVProgressHUD.h"

@interface loginController ()
/**
 *  账号输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
/**
 *  登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**
 *  密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;
/**
 *  点击了登录按钮
 */
- (IBAction)loginClick;
/**
 *  点击了注册按钮
 */
- (IBAction)registerClick;
@end

@implementation loginController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置整个view的背景色
    self.view.backgroundColor = [UIColor blueColor];
    
    //监听两个文本框文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.accountLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdLabel];
    
    //设置登录按钮初始状态为不可点击（账号和密码都有输入内容才可以点击登录按钮）
    self.loginBtn.enabled = NO;
    
    //设置登录和密码输入框的圆形背景
    UIView *bagView = [[UIView alloc] init];
    CGRect accountFrame = self.accountLabel.frame;
    CGRect pwdFrame = self.pwdLabel.frame;
    CGFloat bagX = accountFrame.origin.x;
    CGFloat bagY = accountFrame.origin.y;
    CGFloat bagW = accountFrame.size.width;
    CGFloat bagH = accountFrame.size.height + pwdFrame.size.height;
    bagView.backgroundColor = [UIColor whiteColor];
    bagView.layer.cornerRadius = 5;
    bagView.clipsToBounds = YES;
    
    //设置登录框和密码框之间的分割线
    bagView.frame = CGRectMake(bagX, bagY, bagW, bagH);
    UIView *divider = [[UIView alloc] init];
    CGFloat divX = accountFrame.origin.x;
    CGFloat divY = CGRectGetMaxY(accountFrame);
    CGFloat divW = accountFrame.size.width;
    CGFloat divH = 1;
    divider.frame = CGRectMake(divX, divY, divW, divH);
    divider.backgroundColor = [UIColor blackColor];
    divider.alpha = 0.2;
    
    //把它们添加到view中进行显示
    [self.view addSubview:bagView];
    [self.view addSubview:divider];
    [self.view sendSubviewToBack:bagView];
    
    //设置文本框和密码框左边显示的view
    self.accountLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.pwdLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    
    //设置为永远显示这个左边的小view
    self.accountLabel.leftViewMode = UITextFieldViewModeAlways;
    self.pwdLabel.leftViewMode = UITextFieldViewModeAlways;
    
//    _accountLabel.text = @"a";
//    _pwdLabel.text = @"a";
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self loginClick];
//    });
}

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange
{
    //当账号栏和密码输入栏都有内容时设置登录按钮为可点击状态
    self.loginBtn.enabled = (self.accountLabel.text.length && self.pwdLabel.text.length);
}

//点击空白处时回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)registerClick {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"RegistViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)loginClick {
    [DEFAULT_SERVER loginWithUserName:_accountLabel.text password:_pwdLabel.text result:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            [self performSegueWithIdentifier:@"tabBarVC" sender:nil];
            _accountLabel.text = @"";
            _pwdLabel.text = @"";
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}

@end
