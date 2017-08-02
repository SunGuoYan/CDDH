//
//  CSHDeviceAnnotationView.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/10/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <MapKit/MapKit.h>

@class CSHDevice;

@interface CSHDeviceAnnotationView : MKAnnotationView

@property (nonatomic, readonly) CSHDevice *device;

//根据device的不同状态将annotationView设置成 红 蓝 白色
- (void)updateImage;

@end
