//
//  QuestionListController.m
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "QuestionListController.h"
#import "EditQuestionController.h"
#import "QuestionCell.h"
#import "Server.h"
#import "SVProgressHUD.h"
#import "QuestionDetailController.h"


@interface QuestionListController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *questionArr;
}

- (IBAction)onEditQuestion:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QuestionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 70.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [DEFAULT_SERVER getQuestionListOfCourse:_course result:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            questionArr = resultObj;
            [_tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onEditQuestion:(id)sender {
    
    EditQuestionController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"EditQuestionController"];
    vc.course = _course;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questionArr.count;
}

- (QuestionCell *)getCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"QuestionCell";
    QuestionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    Question *ques = questionArr[indexPath.row];
    cell.questionLbl.text = ques.question;
    cell.detailLbl.text = ques.questionDetail;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = [self getCellAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionDetailController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionDetailController"];
    vc.question = questionArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
