//
//  NightClassTableViewCell.m
//  classesHome
//
//  Created by fawks96 on 16/2/12.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "NightClassTableViewCell.h"

@implementation NightClassTableViewCell

- (void)awakeFromNib {

    self.courseLable.numberOfLines = 0;
}

- (void)setCourse:(NSString *)course {
    
    _course = course;
    self.courseLable.text = course;
}

+ (instancetype)newNightClassCell {

    return [[NSBundle mainBundle] loadNibNamed:@"NightClassTableViewCell" owner:nil options:nil][0];
}

@end
