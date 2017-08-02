//
//  CSHAnotation.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/10/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//一个带有coordinate和device属性的 NSObject
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CSHDevice;

@interface CSHDeviceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, strong) CSHDevice *device;

- (instancetype)initWithDevice:(CSHDevice *)device;

@end
