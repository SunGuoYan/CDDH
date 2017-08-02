//
//  chargeHistoryModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/9.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chargeHistoryModel : NSObject
@property(nonatomic,copy)NSString *stationName;
@property(nonatomic,copy)NSString *chargeName;
@property(nonatomic,strong)NSNumber *chargeNo;
@property(nonatomic,strong)NSString *chargeTime;
@property(nonatomic,copy)NSString *startAt;
@property(nonatomic,strong)NSNumber *money;
@property(nonatomic,copy)NSString *ChargeStatus;

@end
