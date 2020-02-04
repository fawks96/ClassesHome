//
//  NightClassTableViewCell.h
//  classesHome
//
//  Created by fawks96 on 16/2/12.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NightClassTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *courseLable;

@property (strong, nonatomic) NSString *course;

+ (instancetype)newNightClassCell;

@end
