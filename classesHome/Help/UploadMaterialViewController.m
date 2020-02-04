//
//  UploadMaterialViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "UploadMaterialViewController.h"
#import "SVProgressHUD.h"
#import "Server.h"

@interface UploadMaterialViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTf;
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;

- (IBAction)onUpload:(id)sender;

@end

@implementation UploadMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *arr = @[
//                     @"http://d.139.sh/3624259799/P104-7.ppt",
//                     
//                     @"http://d.139.sh/3624259799/二维数组与指针.ppt",
//                     
//                     @"http://d.139.sh/3624259799/String_中字符(串)查找.doc",
//                     
//                     @"http://d.139.sh/3624259799/文件读写.txt"];
    
    _urlTf.text = @"http://pan.plyz.net/s/?u=3624259799&p=B%e5%89%af%e6%9c%ac.txt";

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

- (IBAction)onUpload:(id)sender {
    
    if (![_urlTf.text hasPrefix:@"http"]) {
        [SVProgressHUD showErrorWithStatus:@"请正确填写要上传的文件URL"];
        return;
    }
    
    _uploadBtn.enabled = NO;
    [SVProgressHUD showProgress:0. status:@"正在上传"];
//    [DEFAULT_SERVER uploadUrl:_urlTf.text toCourse:_courseName withProgress:^(CGFloat progress) {
//        [SVProgressHUD showProgress:progress status:@"正在上传"];
//    } result:^(BOOL success, id resultObj, NSString *msg) {
//        if (success) {
//            [SVProgressHUD showSuccessWithStatus:msg];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [SVProgressHUD showErrorWithStatus:msg];
//        }
//        _uploadBtn.enabled = YES;
//    }];
    
    [DEFAULT_SERVER uploadUrl:[_urlTf.text stringByRemovingPercentEncoding] toCourse:_courseName withProgress:^(CGFloat progress) {
        [SVProgressHUD showProgress:progress status:@"正在上传"];
    } result:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        _uploadBtn.enabled = YES;
    }];
}


@end


