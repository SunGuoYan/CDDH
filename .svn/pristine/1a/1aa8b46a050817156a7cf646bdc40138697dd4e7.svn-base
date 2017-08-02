//
//  CSHNetworkingManager+API.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHNetworkingManager.h"

@class CSHDevice;
@class CSHAccount;

@interface CSHNetworkingManager (Device)

typedef void (^CSHNetworkingDeviceSuccessHandler)(NSInteger statusCode, NSArray<CSHDevice *> *devices);

- (void)searchDevicesWithKeyword:(NSString *)keyword
                        latitude:(double)latitude
                       longitude:(double)longitude
                        idleOnly:(BOOL)idleOnly
                         success:(CSHNetworkingDeviceSuccessHandler)success
                         failure:(CSHNetworkingFailureHandler)failure;

@end

static NSString *const kCSHThirdPartyAccountProviderWeibo = @"weibo";
static NSString *const kCSHThirdPartyAccountProviderQQ = @"qq";
static NSString *const kCSHThirdPartyAccountProviderWeChat = @"weixin";

@interface CSHNetworkingManager (Account)

typedef void (^CSHNetworkingAccountSuccessHandler)(CSHAccount *account);

- (void)loadCurrentUserWithSuccess:(CSHNetworkingAccountSuccessHandler)success
                           failure:(CSHNetworkingFailureHandler)failure;
- (void)loadAccountForId:(NSNumber *)accountId
                 success:(CSHNetworkingAccountSuccessHandler)success
                 failure:(CSHNetworkingFailureHandler)failure;

- (void)updateAccountNickname:(NSString *)nickname
                       gender:(NSString *)gender
                      success:(CSHNetworkingAccountSuccessHandler)success
                      failure:(CSHNetworkingFailureHandler)failure;

- (void)logInWithPhoneNumber:(NSString *)phoneNumber
                     captcha:(NSString *)captcha
                     success:(CSHNetworkingAccountSuccessHandler)success
                     failure:(CSHNetworkingFailureHandler)failure;

@end
