//
//  CSHAccount.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHModel.h"

@class CSHDevice;

//枚举：性别
typedef NS_ENUM(NSInteger, CSHGender) {
    CSHGenderFemale = 0,
    CSHGenderMale
};

//声明一个card的类
@interface CSHCard : CSHModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *cardId;//卡片ID值
@property (nonatomic, copy) NSString *identity;//数据库存储ID值
@property (nonatomic, strong) NSNumber *balance;//余额

@end

//声明一个account的类
@interface CSHAccount : CSHModel <MTLJSONSerializing>


@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) CSHGender gender;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSURL *avatarURL;
@property (nonatomic, strong) NSNumber *balance;
//卡片
@property (nonatomic, copy) NSArray<CSHCard *> *cards;
//用户收藏的电桩和电站
@property (nonatomic, copy) NSArray<CSHDevice *> *favoriteDevices;

@end
