//
//  FileDetailController.m
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "FileDetailController.h"

@interface FileDetailController (){
    UIWebView *webView;
}

@end

@implementation FileDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:_url]];
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

@end
