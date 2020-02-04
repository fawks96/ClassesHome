//
//  QuestionDetailController.m
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "QuestionDetailController.h"
#import "AnswerEditController.h"
#import "AnswerCell.h"
#import "Server.h"
#import "Answer.h"
#import "SVProgressHUD.h"

@interface QuestionDetailController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UIImageView *largeImageView;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *questionLbl;
@property (strong, nonatomic) IBOutlet UILabel *detailLbl;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHCstt;


- (IBAction)onAnswer:(id)sender;


@end

@implementation QuestionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _tableView.estimatedRowHeight = 58.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _nameLbl.text = _question.user.userName;
    _timeLbl.text = [self timeStringFromDate:_question.time];
    _questionLbl.text = _question.question;
    _detailLbl.text = _question.questionDetail;
    _imageViewHCstt.constant = _question.image?150.:0.;
    _imageView.image = _question.image;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImageView:)];
    [_imageView addGestureRecognizer:tap];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect frame = _headerView.frame;
        frame.size.height = CGRectGetMaxY(_imageView.frame)+10.;
        _headerView.frame = frame;
        _tableView.tableHeaderView = _headerView;
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)timeStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSString *str = [dateFormatter stringFromDate:date];
    
    return str;
}

- (IBAction)onAnswer:(id)sender {
    
    [AnswerEditController editAnswerWithResult:^(NSString *answer) {
        
        Answer *ans = [[Answer alloc]init];
        ans.user = CURRENT_USER;
        ans.answer = answer;
        ans.time = [NSDate date];
        
        [DEFAULT_SERVER answerQuestion:_question withAnswer:ans result:^(BOOL success, id resultObj, NSString *msg) {
            if (success) {
                [_tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"回答成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        }];
    }];
    
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"回答" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"输入回答内容";
//        textField.keyboardType = UIKeyboardTypeDefault;
//    }];
//    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UITextField *tf = vc.textFields.firstObject;
//        if (tf.text.length) {
//            
//        }
//        
//    }]];
//    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)onTapImageView:(id)sender
{
    largeImageView = [[UIImageView alloc]initWithImage:_imageView.image];;
    largeImageView.frame = [UIScreen mainScreen].bounds;
    largeImageView.userInteractionEnabled = YES;
    largeImageView.backgroundColor = [UIColor blackColor];
    largeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[[[UIApplication sharedApplication]delegate] window] addSubview:largeImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapLargeImageView:)];
    [largeImageView addGestureRecognizer:tap];
}

- (void)onTapLargeImageView:(id)sender
{
    if (largeImageView) {
        [largeImageView removeFromSuperview];
        largeImageView = nil;
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _question.answerArr.count;
}

- (AnswerCell *)getCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AnswerCell";
    AnswerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    Answer *answer = _question.answerArr[indexPath.row];
    cell.nameLbl.text = answer.user.userName;
    cell.timeLbl.text = [self timeStringFromDate:answer.time];
    cell.answerLbl.text = answer.answer;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell *cell = [self getCellAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
