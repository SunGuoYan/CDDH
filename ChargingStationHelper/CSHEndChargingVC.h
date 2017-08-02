//
//  CSHEndChargingVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHEndChargingVC : UIViewController

@property(nonatomic,copy)NSString *orderId;//点击结束充电的时候需要


@property(nonatomic,copy)NSString *chargerNO;//查询充电结果需要

@property(nonatomic,copy)NSString *stationId;//评价需要
@end
