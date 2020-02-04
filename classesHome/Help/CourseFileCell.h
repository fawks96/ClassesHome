//
//  CourseFileCell.h
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseFileCellDelegate;

@interface CourseFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,assign)id<CourseFileCellDelegate> delegate;


@end


@protocol CourseFileCellDelegate <NSObject>

@optional
- (void)didTapInfoLblOnCourseFileCell:(CourseFileCell *)aCell;
- (void)didClickDeleteBtnOnCourseFileCell:(CourseFileCell *)aCell;

@end


