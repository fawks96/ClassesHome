//
//  testViewController.m
//  classesHome
//
//  Created by fawks96 on 16/4/1.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "testViewController.h"
#import "MaterialViewController.h"
#import "QuestionListController.h"

@interface testViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLable;

- (IBAction)onShowCourseMaterial:(id)sender;
- (IBAction)onClickWork:(id)sender;
- (IBAction)onClickProgress:(id)sender;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *arr = [_course componentsSeparatedByString:@"\n"];
    if (arr.count == 4) {
        _courseLabel.text = arr[0];
        _weekLabel.text = arr[1];
        _teacherLabel.text = arr[2];
        _roomLable.text = arr[3];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(onGoBack:)];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.tintColor = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

- (void)onGoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onShowCourseMaterial:(id)sender {
    MaterialViewController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"MaterialViewController"];
    vc.courseName = _courseLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickWork:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"courses" ofType:@"plist"];
    NSDictionary *courseDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *workDic = courseDic[@"work"];
    NSString *work = workDic[_courseLabel.text];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"作业" message:work preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onClickProgress:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"courses" ofType:@"plist"];
    NSDictionary *courseDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *progressDic = courseDic[@"progress"];
    NSString *progress = progressDic[_courseLabel.text];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"课程进度" message:progress preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onClickQuestion:(id)sender {
    QuestionListController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionListController"];
    vc.course = _course;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
