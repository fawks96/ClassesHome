//
//  User.m
//  classesHome
//
//  Created by fawks96 on 16/9/5.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "User.h"

static User *__currentUser = nil;

@implementation User

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyArr = @[@"userName",@"password",@"nickName",@"headImage",@"score",@"scoreRecordArr"];
    
    for (NSString *keyName in propertyArr) {
        NSString *value = [self valueForKeyPath:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSArray *propertyArr = @[@"userName",@"password",@"nickName",@"headImage",@"score",@"scoreRecordArr"];
    if (self = [self init]) {
        for (NSString *keyName in propertyArr) {
            if ([aDecoder containsValueForKey:keyName]) {
                id value = [aDecoder decodeObjectForKey:keyName];
                if (value) {
                    [self setValue:value forKeyPath:keyName];
                }
            }
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scoreRecordArr = [NSMutableArray array];
    }
    return self;
}

+ (void)setCurrentUser:(User *)aUser
{
    __currentUser = aUser;
}

+ (User *)currentUser
{
    return __currentUser;
}

@end






@implementation ScoreRecord


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyArr = @[@"score",@"time",@"reason"];
    
    for (NSString *keyName in propertyArr) {
        NSString *value = [self valueForKeyPath:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSArray *propertyArr = @[@"score",@"time",@"reason"];
    if (self = [super init]) {
        for (NSString *keyName in propertyArr) {
            if ([aDecoder containsValueForKey:keyName]) {
                id value = [aDecoder decodeObjectForKey:keyName];
                if (value) {
                    [self setValue:value forKeyPath:keyName];
                }
            }
        }
    }
    return self;
}


@end
