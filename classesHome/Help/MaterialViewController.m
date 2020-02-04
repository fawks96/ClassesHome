//
//  MaterialViewController.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "MaterialViewController.h"
#import "UploadMaterialViewController.h"
#import "CourseFolder.h"
#import "CourseDownloadFolder.h"
#import "Server.h"
#import "SVProgressHUD.h"
#import "CourseFileCell.h"
#import "FileDetailController.h"


@interface MaterialViewController ()<CourseFileCellDelegate>{
    NSMutableArray <__kindof CourseFile *> *serverFileList;
    NSMutableArray <__kindof CourseFile *> *downloadFileList;
    
    NSMutableArray <__kindof CourseFile *> *currentFileList;
    
    CourseDownloadFolder *downloadFolder;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)onUpload:(id)sender;

@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    downloadFolder = [CourseDownloadFolder courseFolderWithCourseName:_courseName];
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
    [DEFAULT_SERVER getFileListOfCourse:_courseName withResult:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            serverFileList = resultObj;
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
    downloadFileList = [downloadFolder getFileList];
    [self onChangeSeg:_segment];
}

- (BOOL)isFileDownloaded:(CourseFile *)aFile
{
    for (CourseFile *file in downloadFileList) {
        if ([file.fileName isEqualToString:aFile.fileName]) {
            NSArray *downloadUserArr = [downloadFolder.infoDic objectForKey:aFile.fileName];
            if ([downloadUserArr containsObject:CURRENT_USER.userName]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (IBAction)onUpload:(id)sender {
    UploadMaterialViewController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadMaterialViewController"];
    vc.courseName = _courseName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onChangeSeg:(UISegmentedControl *)sender {
    if (_segment.selectedSegmentIndex == 0) {
        currentFileList = serverFileList;
    }else{
        currentFileList = downloadFileList;
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
    if (currentFileList && !currentFileList.count) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
    }
    return currentFileList.count;
}

- (CourseFileCell *)getCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CourseFileCell";
    CourseFileCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CourseFileCell" owner:nil options:nil]firstObject];
        cell.delegate = self;
    }

    CourseFile *file = currentFileList[indexPath.row];
    cell.nameLbl.text = file.fileName;
    
    if (currentFileList == serverFileList) {
        //全部
        BOOL isDownloaded = [self isFileDownloaded:file];
        if (isDownloaded) {
            cell.infoLbl.text = @"已下载";
            cell.infoLbl.userInteractionEnabled = NO;
            cell.infoLbl.textColor = [UIColor lightGrayColor];
        }else{
            cell.infoLbl.text = @"下载";
            cell.infoLbl.userInteractionEnabled = YES;
            cell.infoLbl.textColor = [UIColor blueColor];
        }
        cell.deleteBtn.hidden = ![DEFAULT_SERVER isFileUploadByMe:file.fileName inCourse:file.courseName];
    }else{
        //已下载
        cell.infoLbl.text = @"删除";
        cell.infoLbl.userInteractionEnabled = YES;
        cell.infoLbl.textColor = [UIColor redColor];
        cell.deleteBtn.hidden = YES;
    }
    
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
    CourseFile *file = currentFileList[indexPath.row];
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
    CourseFile *file = currentFileList[indexPath.row];
    if (currentFileList == serverFileList) {
        //下载
        [downloadFolder downloadFile:file];
        [self updatePageData];
    }else{
        //删除
        [downloadFolder deleteFileWithName:file.fileName];
        [self updatePageData];
    }
}

- (void)didClickDeleteBtnOnCourseFileCell:(CourseFileCell *)aCell
{
    if (currentFileList == serverFileList) {
        NSIndexPath *indexPath = [_tableView indexPathForCell:aCell];
        CourseFile *file = currentFileList[indexPath.row];
        [DEFAULT_SERVER deleteFileWithName:file.fileName inCourse:file.courseName];
        [self updatePageData];
    }
}

@end
