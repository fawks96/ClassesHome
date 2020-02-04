//
//  MyScoreRecordViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "MyScoreRecordViewController.h"
#import "ScoreRecordCell.h"
#import "User.h"

@interface MyScoreRecordViewController (){
    NSMutableArray *scoreRecordArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyScoreRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scoreRecordArr = CURRENT_USER.scoreRecordArr;
    _tableView.estimatedRowHeight = 60.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = [NSString stringWithFormat:@"我的积分(%d)",(int)CURRENT_USER.score];
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


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scoreRecordArr.count;
}

- (ScoreRecordCell *)getCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ScoreRecordCell";
    ScoreRecordCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    ScoreRecord *scoreRecord = scoreRecordArr[indexPath.row];
    cell.titleLbl.text = scoreRecord.reason;
    cell.timeLbl.text = scoreRecord.time;
    cell.scoreLbl.text = [NSString stringWithFormat:@"+%.f",scoreRecord.score];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreRecordCell *cell = [self getCellAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
