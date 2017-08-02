//
//  collectionModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/9.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectionModel : NSObject

@property(nonatomic,copy)NSString *stationLocation;
@property(nonatomic,copy)NSString *stationName;
@property(nonatomic,copy)NSString *stationType;
@property(nonatomic,copy)NSString *stationtotalCount;

@property(nonatomic,copy)NSString *stationlongitude;
@property(nonatomic,copy)NSString *stationlatitude;
@property(nonatomic,copy)NSString *stationId;
@property(nonatomic,copy)NSString *operatorStr;
@end
