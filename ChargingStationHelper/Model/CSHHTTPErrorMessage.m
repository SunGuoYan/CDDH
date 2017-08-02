//
//  CSHErrorMessage.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHHTTPErrorMessage.h"
#import "CSHHTTPError.h"

@implementation CSHHTTPErrorMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"message": @"message",
             @"errors":  @"errors"
             };
}
//当前类 属性errors的转换
+ (NSValueTransformer *)errorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSHHTTPError class]];
}

@end
