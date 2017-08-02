//
//  NSUserDefaults+UserConfig.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/6/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "NSUserDefaults+UserConfig.h"

static NSString *const kCSHUserDefaultsKeyAuthenticatedAccountId = @"accountId";

@implementation NSUserDefaults (UserConfig)

//判断是否登录
+ (BOOL)csh_isLogin {
    //TODO: remove test
    
    //这里测试直接返回YES，所以永远是登录状态，做的时候把YES注掉
    
//    return YES;
    //登录之后，用NSUserDefaults 将@"accountId"的value设置为YES
    //注销登录之后，将@"accountId"的value设置为nil
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kCSHUserDefaultsKeyAuthenticatedAccountId];
    return currentUserId != nil ? YES : NO;
}

@end
