//
//  CSHChargingStationViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/14/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//搜索结果Cell点击之后跳转到 充电点详情 页面
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CSHDevice;


@interface CSHChargingStationViewController : UIViewController
//属性是CSHMapViewController 从首页正向传值  给详情页面的基本信息赋值

//设备列表也是有个点击push到详情的
//真正使用的只有 device.deviceId 和定位者的location而已
@property (nonatomic, strong) CSHDevice *device;
@property (nonatomic, strong) CLLocation *location;

//自己加的
@property(nonatomic,strong)NSString *stationId;
@end
