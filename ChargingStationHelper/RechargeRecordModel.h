//
//  RechargeRecordModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/12.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeRecordModel : NSObject

@property(nonatomic,copy)NSString *recordpaidFrom;
@property(nonatomic,copy)NSString *recordCreatedAt;

@property(nonatomic,copy)NSString *recordMoney;
@property(nonatomic,copy)NSString *recordstatus;

@end
