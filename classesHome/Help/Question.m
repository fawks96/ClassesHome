//
//  Question.m
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "Question.h"

@implementation Question


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyArr = @[@"user", @"time", @"question", @"questionDetail", @"answerArr", @"course", @"image"];
    
    for (NSString *keyName in propertyArr) {
        NSString *value = [self valueForKeyPath:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSArray *propertyArr = @[@"user", @"time", @"question", @"questionDetail", @"answerArr", @"course", @"image"];
    if (self = [super init]) {
        for (NSString *keyName in propertyArr) {
            if ([aDecoder containsValueForKey:keyName]) {
                id value = [aDecoder decodeObjectForKey:keyName];
                [self setValue:value forKeyPath:keyName];
            }
        }
    }
    return self;
}

@end
