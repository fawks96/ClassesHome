//
//  classTableController.m
//  classesHome
//
//  Created by fawks96 on 16/2/12.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "classTableController.h"
#import "OldClassTableView.h"
#import "iCarousel.h"
#import "LJTimeTool.h"
#import "DayClassTableViewCell.h"
#import "NightClassTableViewCell.h"
#import "testViewController.h"

#define CLASSTIMETABLEMODE @"ClassTimeTableMode"
@interface classTableController ()<UITableViewDataSource,UITableViewDelegate,iCarouselDataSource,iCarouselDelegate,OldClassTableViewDelegate>
/**
 *  3D分页展示每天课表的View
 */
@property (nonatomic,strong) iCarousel *iCaView;
/**
 *  存储课程信息的字典
 */
@property (nonatomic,strong) NSDictionary *dict;
/**
 *  存储查看课表模式的量
 */
@property (nonatomic,strong) NSUserDefaults *deft;
/**
 *  存储分天展示时是星期几的标题数组
 */
@property (nonatomic,strong) NSArray *titleArray;
/**
 *  存储课程信息的数组
 */
@property (nonatomic,strong) NSArray *courseArray;
/**
 *  查看一周完整课表的view
 */
@property (nonatomic,weak) OldClassTableView *oldView;
/**
 *  点击了右上角的切换查看模式按钮
 */
- (IBAction)changeModeClick;
@end

@implementation classTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新建一个信息存储单元
    self.deft = [NSUserDefaults standardUserDefaults];
    
    //显示对应的课程表展示方式的界面
    if (![self.deft objectForKey:CLASSTIMETABLEMODE]) {
        [self createNewClassView];
    } else {
        
        [self createOldClassView];
    }
    // Do any additional setup after loading the view from its nib.
}

/**
 *  创建并显示整周查看课程表的界面
 */
- (void)createOldClassView {
    
    
    OldClassTableView *oldClassTable = [OldClassTableView newOldClassTable];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"courses.plist" ofType:nil];
    
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.dict = dict;
    
    oldClassTable.dict = self.dict;

    CGRect newFrame = self.view.frame;
    
    newFrame.origin.y += 64;
    newFrame.size.height -= 64;
    
    oldClassTable.frame = newFrame;
    oldClassTable.delegate = self;
    
    self.oldView = oldClassTable;
    [self.view addSubview:oldClassTable];

}
/**
 *  创建并显示分天查看课程表的界面
 */
- (void)createNewClassView {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"courses.plist" ofType:nil];
    
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.courseArray = [self getCourseArray:dict];
    
    CGRect newFrame = self.view.frame;
    
    newFrame.origin.y += 64;
    newFrame.size.height -= 64;
    self.iCaView = [[iCarousel alloc] initWithFrame:newFrame];
    
    self.iCaView.delegate = self;
    self.iCaView.dataSource = self;
    self.iCaView.type = iCarouselTypeRotary;
    self.iCaView.pagingEnabled = YES;
    self.iCaView.backgroundColor = [UIColor clearColor];
    
    self.iCaView.currentItemIndex = [LJTimeTool getCurrentWeekDay] - 1;
    
    [self.view addSubview:self.iCaView];
    
    self.titleArray = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
}
/**
 *  从plist中读取出所有的课程信息存到数组中
 */
- (NSArray *)getCourseArray:(NSDictionary *)dict {
    
    NSDictionary *courses = dict[@"courses"];
    
    NSArray *arr0 = @[courses[@"7-1"], courses[@"7-2"], courses[@"7-3"], courses[@"7-4"], courses[@"7-5"]];
    NSArray *arr1 = @[courses[@"1-1"], courses[@"1-2"], courses[@"1-3"], courses[@"1-4"], courses[@"1-5"]];
    NSArray *arr2 = @[courses[@"2-1"], courses[@"2-2"], courses[@"2-3"], courses[@"2-4"], courses[@"2-5"]];
    NSArray *arr3 = @[courses[@"3-1"], courses[@"3-2"], courses[@"3-3"], courses[@"3-4"], courses[@"3-5"]];
    NSArray *arr4 = @[courses[@"4-1"], courses[@"4-2"], courses[@"4-3"], courses[@"4-4"], courses[@"4-5"]];
    NSArray *arr5 = @[courses[@"5-1"], courses[@"5-2"], courses[@"5-3"], courses[@"5-4"], courses[@"5-5"]];
    NSArray *arr6 = @[courses[@"6-1"], courses[@"6-2"], courses[@"6-3"], courses[@"6-4"], courses[@"6-5"]];
    
    NSArray *array = @[arr0, arr1, arr2, arr3, arr4, arr5, arr6];
    
    return array;
}


#pragma UIView实现动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition
{
    [UIView animateWithDuration:0.7f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}

/**
 *  点击了右上角的切换展示模式按钮
 */
- (IBAction)changeModeClick {
    
    [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
    NSLog(@"111%@111",[self.deft objectForKey:CLASSTIMETABLEMODE]);
    if (![self.deft objectForKey:CLASSTIMETABLEMODE]) {
        [self.iCaView removeFromSuperview];
        [self createOldClassView];
        [self.deft setObject:@"1" forKey:CLASSTIMETABLEMODE];
    } else {
        [self.oldView removeFromSuperview];
        [self createNewClassView];
        [self.deft setObject:nil forKey:CLASSTIMETABLEMODE];
    }
        [self.deft synchronize];
}

#pragma mark -carousel方法实现
/**
 *  总共有7页的分页需要展示
 */
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 7;
}
/**
 *  每一页展示一个tableView
 */
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSInteger HEIGHT = [UIScreen mainScreen].bounds.size.height - 40 - 64;
    NSInteger WIDTH = [UIScreen mainScreen].bounds.size.width - 30;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    
    tableView.tag = index;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
    tableView.backgroundColor = [UIColor colorWithRed:214/255.0 green:227/255.0 blue:181/255.0 alpha:1];
    
    return tableView;
}

#pragma mark -tableView方法实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = self.titleArray[tableView.tag];
        return cell;
    }
    if (indexPath.row == 1) {
        
        DayClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"day"];
        if (!cell) {
            cell = [DayClassTableViewCell newDayClassCell];
        }
        
        cell.course0 = self.courseArray[tableView.tag][0];
        cell.course1 = self.courseArray[tableView.tag][1];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_morning"]];
        return  cell;
    }
    if (indexPath.row == 2) {
        
        DayClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"day"];
        if (!cell) {
            cell = [DayClassTableViewCell newDayClassCell];
        }
        
        DayCourse *course = [DayCourse new];
        course.class0 = self.courseArray[tableView.tag][2];
        course.class1 = self.courseArray[tableView.tag][3];
        
        cell.course = course;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_afternoon"]];
        return  cell;
    }
    else {
        
        NightClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"night"];
        if (!cell) {
            cell = [NightClassTableViewCell newNightClassCell];
        }
        
        cell.course = self.courseArray[tableView.tag][4];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_night"]];
        return cell;
    }
    
}
/**
 *  设置每一个cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 44;
    }
    if (indexPath.row == 3) {
        return 140;
    }
    else {
        
        return 212;
    }
}


#pragma mark -
#pragma mark - OldClassTableViewDelegate
- (void)oldClassTableView:(OldClassTableView *)aView didSelectedCourse:(NSString *)aCourse
{
    testViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"1"];
    vc.course = aCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
