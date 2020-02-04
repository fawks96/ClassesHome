//
//  MyMaterialViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "MyMaterialViewController.h"
#import "CourseFolder.h"
#import "CourseServerFolder.h"
#import "CourseDownloadFolder.h"
#import "SVProgressHUD.h"
#import "CourseFileCell.h"
#import "FileDetailController.h"
#import "Server.h"

@interface MyMaterialViewController ()<CourseFileCellDelegate>{
    NSMutableArray <__kindof CourseFile *> *myUploadFileArr;
    NSMutableArray <__kindof CourseFile *> *myDownloadFileArr;
    
    NSMutableArray <__kindof CourseFile *> *currentFileArr;
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)onChangeSegment:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePageData];
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

- (void)updatePageData
{
    myUploadFileArr = [CourseServerFolder getMyUploadFiles];
    myDownloadFileArr = [CourseDownloadFolder getMyDownloadFiles];
    
    [self onChangeSegment:_segment];
}

- (IBAction)onChangeSegment:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
        currentFileArr = myUploadFileArr;
    }else{
        currentFileArr = myDownloadFileArr;
    }
    
    [_tableView reloadData];
}



#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentFileArr && !currentFileArr.count) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
    }
    return currentFileArr.count;
}

- (CourseFileCell *)getCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CourseFileCell";
    CourseFileCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CourseFileCell" owner:nil options:nil]firstObject];
        cell.delegate = self;
        cell.deleteBtn.hidden = YES;
        
        cell.infoLbl.text = @"删除";
        cell.infoLbl.userInteractionEnabled = YES;
        cell.infoLbl.textColor = [UIColor redColor];
    }
    
    CourseFile *file = currentFileArr[indexPath.row];
    cell.nameLbl.text = file.fileName;
    
    return cell;
}

- (CourseFileCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseFileCell *cell = [self getCellAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FileDetailController *vc = [[FileDetailController alloc]init];
    CourseFile *file = currentFileArr[indexPath.row];
    vc.url = [NSURL fileURLWithPath:file.path];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.;
}

#pragma mark -
#pragma mark - CourseFileCellDelegate
- (void)didTapInfoLblOnCourseFileCell:(CourseFileCell *)aCell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:aCell];
    CourseFile *file = currentFileArr[indexPath.row];
    if (currentFileArr == myUploadFileArr) {
        //我上传的
        [DEFAULT_SERVER deleteFileWithName:file.fileName inCourse:file.courseName];
        [self updatePageData];
    }else{
        //我下载的
        CourseDownloadFolder *downloadFolder = [CourseDownloadFolder courseFolderWithCourseName:file.courseName];
        [downloadFolder deleteFileWithName:file.fileName];
        [self updatePageData];
    }
}

@end
