//
//  CourseFileCell.m
//  classesHome
//
//  Created by fawks96 on 16/9/6.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "CourseFileCell.h"

@interface CourseFileCell()

- (IBAction)onDelete:(id)sender;

@end



@implementation CourseFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapInfoLbl:)];
    [_infoLbl addGestureRecognizer:tap];
}


- (void)onTapInfoLbl:(UILabel *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapInfoLblOnCourseFileCell:)]) {
        [_delegate didTapInfoLblOnCourseFileCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onDelete:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickDeleteBtnOnCourseFileCell:)]) {
        [_delegate didClickDeleteBtnOnCourseFileCell:self];
    }
}

@end
