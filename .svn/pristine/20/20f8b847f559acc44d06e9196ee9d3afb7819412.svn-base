//
//  CSHNetworkingManager+API.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHNetworkingManager+API.h"

@implementation CSHNetworkingManager (Device)

//搜索的接口 传入 关键字 location的经纬度，但是这里经纬度传进去好像并没有什么用
- (void)searchDevicesWithKeyword:(NSString *)keyword latitude:(double)latitude longitude:(double)longitude idleOnly:(BOOL)idleOnly success:(CSHNetworkingDeviceSuccessHandler)success failure:(CSHNetworkingFailureHandler)failure {
    
    NSString *path = @"/devices/search";
    [self csh_GET:path
       parameters:nil
          success:^(NSInteger statusCode, id result) {
              if (success) {
                  success(statusCode, result);
              }
          } failure:^(NSInteger statusCode, NSError *error) {
              if (failure) {
                  failure(statusCode, error);
              }
          }];
}

@end

@implementation CSHNetworkingManager (Account)

- (void)loadCurrentUserWithSuccess:(CSHNetworkingAccountSuccessHandler)success failure:(CSHNetworkingFailureHandler)failure {
    [self csh_GET:@"/account"
       parameters:nil
          success:^(NSInteger statusCode, id result) {
              if (success) {
                  success(result);
              }
          } failure:^(NSInteger statusCode, NSError *error) {
              if (failure) {
                  failure(statusCode, error);
              }
          }];
}

//自己封装的GET请求的使用
- (void)loadAccountForId:(NSNumber *)accountId success:(CSHNetworkingAccountSuccessHandler)success failure:(CSHNetworkingFailureHandler)failure {
    [self csh_GET:[NSString stringWithFormat:@"/account/%@", accountId]
       parameters:nil
          success:^(NSInteger statusCode, id result) {
              if (success) {
                  success(result);
              }
          } failure:^(NSInteger statusCode, NSError *error) {
              if (failure) {
                  failure(statusCode, error);
              }
          }];
}

- (void)updateAccountNickname:(NSString *)nickname gender:(NSString *)gender success:(CSHNetworkingAccountSuccessHandler)success failure:(CSHNetworkingFailureHandler)failure {
    NSMutableDictionary *parameters = [@{} mutableCopy];
    if (nickname) {
        parameters[@"nickname"] = nickname;
    }
    if (gender) {
        parameters[@"gender"] = gender;
    }
    
    [self csh_PATCH:@"/account"
         parameters:[parameters copy]
            success:^(NSInteger statusCode, id result) {
                if (success) {
                    success(result);
                }
            } failure:^(NSInteger statusCode, NSError *error) {
                if (failure) {
                    failure(statusCode, error);
                }
            }];
}

- (void)logInWithPhoneNumber:(NSString *)phoneNumber captcha:(NSString *)captcha success:(CSHNetworkingAccountSuccessHandler)success failure:(CSHNetworkingFailureHandler)failure {
    NSMutableDictionary *parameters = [@{
        @"phone": phoneNumber
        } mutableCopy];
    if (captcha) {
        parameters[@"captcha"] = captcha;
    }
    
    [self csh_POST:@"/accounts"
        parameters:parameters
           success:^(NSInteger statusCode, id result) {
               if (success) {
                   success(result);
               }
           } failure:^(NSInteger statusCode, NSError *error) {
               if (failure) {
                   failure(statusCode, error);
               }
           }];
}

@end
