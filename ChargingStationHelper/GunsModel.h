//
//  GunsModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 17/1/6.
//  Copyright © 2017年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GunsModel : NSObject
@property(nonatomic,copy)NSString *gunNo;//枪标号10 20 30
@property(nonatomic,copy)NSString *gunName;//A
@property(nonatomic,copy)NSString *cif;//国标直流枪
@property(nonatomic,copy)NSString *voltage;
@property(nonatomic,copy)NSString *power;
@property(nonatomic,copy)NSString *status;
@end
