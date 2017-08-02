//
//  CSHOnChargingVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/6.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHOnChargingVC : UIViewController

@property(nonatomic,copy)NSString *orderId;//查询充电，点击结束充电的时候需要

@property(nonatomic,copy)NSString *chargerNO;//查询进度

@property(nonatomic,copy)NSString *stationId;//后面评价的需要
@end
