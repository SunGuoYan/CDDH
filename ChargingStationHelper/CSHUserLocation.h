//
//  CSHUserLocation.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/10.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface CSHUserLocation : NSObject

@property (nonatomic, strong) CLLocation *location;

+(instancetype)shareSingleton;

@end
