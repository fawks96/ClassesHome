//
//  AnswerEditController.m
//  classesHome
//
//  Created by fawks96 on 16/10/21.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "AnswerEditController.h"
#import "SVProgressHUD.h"

@interface AnswerEditController (){
    
}

@property (strong, nonatomic) IBOutlet UITextView *answerTf;
- (IBAction)onConfirm:(id)sender;

@property (nonatomic,copy)AnswerResultBlock answerResultBlock;

@end

@implementation AnswerEditController

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

+ (void)editAnswerWithResult:(AnswerResultBlock)resultBlock
{
    AnswerEditController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"AnswerEditController"];
    vc.answerResultBlock = resultBlock;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    UIViewController *preVC = [[[UIApplication sharedApplication]delegate] window].rootViewController.presentedViewController;
    [preVC presentViewController:nav animated:YES completion:nil];
}

- (IBAction)onConfirm:(id)sender {
    if (!_answerTf.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入回答内容"];
        return;
    }
    
    if (_answerResultBlock) {
        _answerResultBlock(_answerTf.text);
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
