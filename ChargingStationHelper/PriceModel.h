//
//  PriceModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/10.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceModel : NSObject
@property(nonatomic,copy)NSString *startAt;
@property(nonatomic,copy)NSString *endAt;
@property(nonatomic,copy)NSString *price;//电价
@property(nonatomic,copy)NSString *fee;//服务费

@end
