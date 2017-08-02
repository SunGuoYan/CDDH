//
//  NSUserDefaults+CSH.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 6/26/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//类别  Command+N source->Objective-C file
#import <Foundation/Foundation.h>

@interface NSUserDefaults (CSH)
//取出存储Keywords的数组
+ (NSArray<NSString *> *)csh_cachedKeywords;

//取出数组，头部插入新元素再存储起来
+ (void)csh_addKeywords:(NSString *)keyword;

//删除keyword这个元素
+ (void)csh_clearKeywords;

@end
