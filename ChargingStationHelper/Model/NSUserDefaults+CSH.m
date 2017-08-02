//
//  NSUserDefaults+CSH.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 6/26/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "NSUserDefaults+CSH.h"

@implementation NSUserDefaults (CSH)

static NSString *const kCSHUserDefaultKeyKeywords = @"Keywords";

//取出存储的数组
+ (NSArray<NSString *> *)csh_cachedKeywords {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCSHUserDefaultKeyKeywords];
}
//取出数组，头部插入新元素再存储起来
+ (void)csh_addKeywords:(NSString *)keyword {
    NSArray <NSString *> *unmutableKeywords = [self csh_cachedKeywords];
    NSMutableArray <NSString *> *keywords = unmutableKeywords ? [unmutableKeywords mutableCopy] : [[NSMutableArray alloc] init];
    [keywords insertObject:keyword atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[keywords copy] forKey:kCSHUserDefaultKeyKeywords];
}

//删除keyword这个元素
+ (void)csh_clearKeywords {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCSHUserDefaultKeyKeywords];
}

@end
