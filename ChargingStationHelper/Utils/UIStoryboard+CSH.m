//
//  UIStoryboard+CSH.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/20/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "UIStoryboard+CSH.h"

@implementation UIStoryboard (CSH)

+ (UIStoryboard *)csh_mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)csh_menuStoryboard {
    return [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
}

@end
