//
//  CSHAccount.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHAccount.h"
#import "CSHDevice.h"

@implementation CSHCard
//card 类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"cardId":   @"id",
        @"identity": @"cardId",
        @"balance":  @"money"
        };
}

@end

@implementation CSHAccount
//account 类
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"accountId": @"id",
        @"gender":    @"gender",
        @"nickname":  @"nickname",
        @"email":     @"email",
        @"phone":     @"phone",
        @"avatarURL": @"avatar",
        @"balance":   @"money",
        @"cards":     @"cards",
        @"favoriteDevices": @"favorites"
        };
}
//枚举 性别
+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"FEMALE": @(CSHGenderFemale),
        @"MALE":   @(CSHGenderMale)
        }];
}
//account类 属性avatarURL的转换
+ (NSValueTransformer *)avatarURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
//account类 属性cards的转换
+ (NSValueTransformer *)cardsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSHCard class]];
}
//account类 属性favoriteDevices的转换
+ (NSValueTransformer *)favoriteDevicesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CSHDevice class]];
}

@end
