//
//  CSHChargingStationVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/15.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface CSHChargingStationVC : UIViewController

@property (nonatomic, strong) CLLocation *location;
@property(nonatomic,strong)NSString *stationId;

@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;

@end
