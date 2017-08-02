//
//  CSHClient.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHClient.h"
#import "CSHDevice.h"
#import "CSHAccount.h"
@implementation CSHClient

//这是一个继承自OVCHTTPSessionManager单例类
//设置了四个属性
+ (CSHClient *)sharedClient {
    
    //吴刚的IP
    NSString *baseURL=@"http://192.168.3.245:8100/api";
    
    //原IP
//    NSString *baseURL = @"http://120.52.12.203:8100/api";
    
    
    static CSHClient *sharedClient = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        //这里初始化了一个baseURL
        //在CSHNetworkingManager 的GET方法里面又有一个URL 和parameter ？？
        
        //1, baseURL
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        
        //2, format
        sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        
        //3 securityPolicy
        sharedClient.securityPolicy = policy;
        
        // default header
        //app版本
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        //操作系统版本
        NSOperatingSystemVersion systemVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
        //用户代理
        NSString *userAgentValue = [NSString stringWithFormat:@"ChargingStationHelper/%@ (iPhone; iOS %@.%@.%@; Scale/2.00)", appVersion, @(systemVersion.majorVersion), @(systemVersion.minorVersion), @(systemVersion.patchVersion)];
        //4, 请求头 用户代理
        [sharedClient.requestSerializer setValue:userAgentValue forHTTPHeaderField:@"User-Agent"];
    });
    return sharedClient;
}

+ (void)csh_setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password {
    [[CSHClient sharedClient].requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

+ (void)csh_clearAuthorizationHeaderField {
    [[CSHClient sharedClient].requestSerializer clearAuthorizationHeader];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
        @"/devices/search": [CSHDevice class],
        @"/accounts/*":     [CSHAccount class],
        @"/account":        [CSHAccount class],
        @"/accounts":       [CSHAccount class],
        };
}

@end
