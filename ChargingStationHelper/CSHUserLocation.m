//
//  CSHUserLocation.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/10.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHUserLocation.h"

@implementation CSHUserLocation
+(instancetype)shareSingleton{
    static CSHUserLocation *single = nil;
    if (single==nil) {
        single=[[CSHUserLocation alloc]init];
        
    }
    return single;
}
@end
