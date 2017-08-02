//
//  CSHDevice.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 6/12/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//数据模型 一系列属性
//带一个返回三个device的数组的方法
#import "CSHModel.h"
//1.设备类型
typedef NS_ENUM(NSUInteger, CSHDeviceType) {
    CSHDeviceTypeCharger = 0,
    CSHDeviceTypeStation
};
//2.设备状态
typedef NS_ENUM(NSUInteger, CSHDeviceStatus) {
    CSHDeviceStatusIdle = 0,
    CSHDeviceStatusOffline,
    CSHDeviceStatusRepair,
    CSHDeviceStatusCharging,
    CSHDeviceStatusOccupied
};
//3.设备支付方式
typedef NS_ENUM(NSUInteger, CSHDevicePaymentMethod) {
    CSHDevicePaymentMethodOther = 0,
    CSHDevicePaymentMethodCard
};
//4.设备区域类型
typedef NS_ENUM(NSUInteger, CSHDeviceAreaType) {
    CSHDeviceAreaTypeOther = 0,
    CSHDeviceAreaTypeUptown, // 住宅小区
    CSHDeviceAreaTypeOffice // 办公场所
};
//1.声明一个坐标点Coordinate的类
@interface CSHCoordinatePoint : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
//2.声明一个图片Image的类
@interface CSHImage : CSHModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, strong) NSURL *url;

@end

//3.声明一个设备等级DeviceRating的类
@interface CSHDeviceRating : CSHModel <MTLJSONSerializing>

@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, assign) NSUInteger device;
@property (nonatomic, assign) NSUInteger speed;

@end

@interface CSHDevice : CSHModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *searchId;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<CSHImage *> *images;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, assign) NSNumber *price;
//四个枚举
@property (nonatomic, assign) CSHDeviceType type;
@property (nonatomic, assign) CSHDeviceStatus status;
@property (nonatomic, assign) CSHDevicePaymentMethod paymentMethod;
@property (nonatomic, assign) CSHDeviceAreaType areaType;

@property (nonatomic, strong) CSHCoordinatePoint *coordinatePoint;
@property (nonatomic, strong) CSHDeviceRating *rating;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *address;


@property (nonatomic, copy) NSNumber *deviceId;
//自己添加的
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *atype;//   住宅小区/其他
@property (nonatomic, copy) NSString *stype;//   驻地站/公共站
@property (nonatomic, copy) NSString *ctype;//  快充/慢充
@property (nonatomic, copy) NSString *payType;//  刷卡支付/其他支付

@property (nonatomic, copy) NSString *idleCount;
@property (nonatomic, copy) NSString *totalCount;

@property (nonatomic, copy) NSString *totalGuns;
@property (nonatomic, copy) NSString *totalIdelCung;

@property (nonatomic, copy) NSString *priceStr;
@property (nonatomic, copy) NSString *feeStr;
@property (nonatomic, copy) NSString *openTime;
//电站里面装的电桩的数组集合 调用的时候记得初始化
@property(nonatomic,copy)NSMutableArray *chargesDataArray;


@property (nonatomic, assign) BOOL isPrivate; //是否私人电桩
//以下两个属性判断充电桩大头针是 红（联网，认证） 蓝（未联网 认证） 白色（未联网，未认证）
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL isCertified;

//计算location与device之间的距离
@property (nonatomic, copy) NSString *distance;

@end

@interface CSHDevice (Test)

//返回三个device的数组
+ (NSArray<CSHDevice *> *)testDevices;

@end
