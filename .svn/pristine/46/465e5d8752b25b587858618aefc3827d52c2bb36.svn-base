//
//  CSHDevice.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 6/12/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHDevice.h"

@implementation CSHCoordinatePoint
//一，Coordinate的类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"latitude":  @"lat",
        @"longitude": @"lon"
        };
}

@end

@implementation CSHImage
//二，image的类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageId": @"id",
        @"width":   @"width",
        @"height":  @"height",
        @"url":     @"src"
        };
}

@end

@implementation CSHDeviceRating
//三，deviceRating的类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"total" : @"total",
        @"device": @"device",
        @"speed":  @"speed"
        };
}

@end

@implementation CSHDevice
// CSHDevice的类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"searchId":        @"id",
        @"deviceId":        @"objectId",
        @"code":            @"code",
        @"name":            @"name",
        @"images":          @"images",
        @"count":           @"count",
        @"price":           @"price",
        @"type":            @"type",
        @"status":          @"status",
        @"paymentMethod":   @"paymentMethod",
        @"coordinatePoint": @"geoPoint",
        @"rating":          @"rating",
        @"province":        @"province",
        @"city":            @"city",
        @"district":        @"district",
        @"address":         @"address",
        @"isPrivate":       @"standalone",
        @"isOnline":        @"online",
        @"isCertified":     @"certified"
        };
}


/*   枚举 ????   */
//以下方法是重写？？并没对外做声明接口
//1,type
+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"CHARGER": @(CSHDeviceTypeCharger),
        @"STATION": @(CSHDeviceTypeStation)
        }];
}
//2,status
+ (NSValueTransformer *)statusJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"IDLE":     @(CSHDeviceStatusIdle),
        @"REPAIR":   @(CSHDeviceStatusRepair),
        @"CHARGING": @(CSHDeviceStatusCharging),
        @"OFFLINE":  @(CSHDeviceStatusOffline),
        @"OCCUPIED": @(CSHDeviceStatusOccupied)
        }];
}
//3,payment
+ (NSValueTransformer *)paymentMethodJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"OTHER": @(CSHDevicePaymentMethodOther),
        @"CARD":  @(CSHDevicePaymentMethodCard)
        }];
}
//4，area
+ (NSValueTransformer *)areaTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"OTHER":  @(CSHDeviceAreaTypeOther),
        @"UPTOWN": @(CSHDeviceAreaTypeUptown),
        @"OFFICE": @(CSHDeviceAreaTypeOffice)
        }];
}
//一，coordinate
+ (NSValueTransformer *)coordinatePointJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CSHCoordinatePoint class]];
}
//二，image
+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSHImage class]];
}
//三，deviceRating
+ (NSValueTransformer *)ratingJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CSHDeviceRating class]];
}

@end

@implementation CSHDevice (Test)

+ (NSArray<CSHDevice *> *)testDevices {
    
    //武汉 文韬楼
    double latitude = 30.4893069294;
    double longitude = 114.4208743175;
    
    //北京
//    double latitude = 39.98435135882711;
//    double longitude = 116.4705799942443;
    
    
    // online
    CSHDevice *device1 = [CSHDevice new];
    //自定义的枚举
//    device.areaType=CSHDeviceAreaTypeOther;
    device1.deviceId=@(1);
    CSHCoordinatePoint *coordinate1 = [CSHCoordinatePoint new];
    coordinate1.latitude = latitude + 0.005;
    coordinate1.longitude = longitude;
    device1.coordinatePoint = coordinate1;
    //红色
    device1.isOnline = YES;
    device1.isCertified = YES;
    
    device1.isPrivate = NO;
    device1.name = @"武汉市聚点车间（对外）";
    device1.paymentMethod = CSHDevicePaymentMethodCard;
    device1.address = @"武汉市光谷大道国际企业中心一期";
    
    
    
    // certificated
    CSHDevice *device2 = [CSHDevice new];
    device2.deviceId=@(2);
    CSHCoordinatePoint *coordinate2 = [CSHCoordinatePoint new];
    coordinate2.latitude = latitude - 0.005;
    coordinate2.longitude = longitude;
    device2.coordinatePoint = coordinate2;
    //蓝色
    device2.isOnline = NO;
    device2.isCertified = YES;
    
    device2.isPrivate = YES;
    device2.name = @"武汉聚点车间";
    device2.paymentMethod = CSHDevicePaymentMethodOther;
    device2.address = @"武汉市光谷大道国际企业中心二期";
    
    
    
    // uncertificated
    CSHDevice *device3 = [CSHDevice new];
    device3.deviceId=@(3);
    CSHCoordinatePoint *coordinate3 = [CSHCoordinatePoint new];
    coordinate3.latitude = latitude + 0.005;
    coordinate3.longitude = longitude + 0.005;
    device3.coordinatePoint = coordinate3;
    //白色
    device3.isOnline = NO;
    device3.isCertified = NO;
    //白色
    device3.name = @"金鑫国际";
    device3.isPrivate = YES;//加
    device3.paymentMethod = CSHDevicePaymentMethodOther;
    device3.address = @"武汉市光谷大道国际企业中心三期";
    
    
    // online
    CSHDevice *device4 = [CSHDevice new];
    device4.deviceId=@(4);
    //自定义的枚举
    //    device.areaType=CSHDeviceAreaTypeOther;
    CSHCoordinatePoint *coordinate4 = [CSHCoordinatePoint new];
    coordinate4.latitude = latitude + 0.005+ 0.005;
    coordinate4.longitude = longitude;
    device4.coordinatePoint = coordinate4;
    //红色
    device4.isOnline = YES;
    device4.isCertified = YES;
    
    device4.isPrivate = NO;
    device4.name = @"4号电站";
    device4.paymentMethod = CSHDevicePaymentMethodCard;
    device4.address = @"武汉市光谷大道国际企业中心4期";
    
    
    
    // certificated
    CSHDevice *device5 = [CSHDevice new];
    device5.deviceId=@(5);
    CSHCoordinatePoint *coordinate5 = [CSHCoordinatePoint new];
    coordinate5.latitude = latitude - 0.005;
    coordinate5.longitude = longitude- 0.005;
    device5.coordinatePoint = coordinate5;
    //蓝色
    device5.isOnline = NO;
    device5.isCertified = YES;
    
    device5.isPrivate = YES;
    device5.name = @"5号电站";
    device5.paymentMethod = CSHDevicePaymentMethodOther;
    device5.address = @"武汉市光谷大道国际企业中心5期";
    
    
    
    // uncertificated
    CSHDevice *device6 = [CSHDevice new];
    device6.deviceId=@(6);
    CSHCoordinatePoint *coordinate6 = [CSHCoordinatePoint new];
    coordinate6.latitude = latitude -0.005- 0.005;
    coordinate6.longitude = longitude + 0.005+ 0.005;
    device6.coordinatePoint = coordinate6;
    //白色
    device6.isOnline = NO;
    device6.isCertified = NO;
    //白色
    device6.name = @"6号电站";
    device6.isPrivate = YES;//加
    device6.paymentMethod = CSHDevicePaymentMethodOther;
    device6.address = @"武汉市光谷大道国际企业中心6期";
    
    return @[device1, device2, device3,device4,device5,device6];
}

@end
