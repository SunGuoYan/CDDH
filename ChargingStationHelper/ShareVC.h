//
//  ShareVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/2.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareVC : UIViewController

@property(nonatomic,copy)NSString *stationId;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;

@end
