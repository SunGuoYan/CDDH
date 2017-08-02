//
//  FeedBackModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/8.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackModel : NSObject
@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *replay;//其实是个数组，取数组的字典的content对应的内容

@end
