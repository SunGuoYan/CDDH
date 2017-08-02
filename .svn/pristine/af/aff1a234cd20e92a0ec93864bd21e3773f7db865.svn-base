//
//  CSHAnotation.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/10/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHDeviceAnnotation.h"
#import "CSHDevice.h"

@interface CSHDeviceAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, strong) CSHDevice *device;

@end

@implementation CSHDeviceAnnotation

//self.coordinate 是通过传入的桩的经纬度来的
- (instancetype)initWithDevice:(CSHDevice *)device {
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake(device.coordinatePoint.latitude, device.coordinatePoint.longitude);
        self.device = device;
    }
    return self;
}

@end
