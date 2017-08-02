//
//  UITabBar+badge.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/22.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
/**
 1.类别（声明加实现）
 2.需要使用的类中调用即可
 */
//显示小红点
- (void)showBadgeOnItemIndex:(int)index;
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;
@end
