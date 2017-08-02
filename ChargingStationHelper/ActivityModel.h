//
//  ActivityModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/1.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *releasedAt;
@property(nonatomic,copy)NSString *validAt;
@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *textType;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *text;
@end
