//
//  CSHClient.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <Overcoat/Overcoat.h>

@interface CSHClient : OVCHTTPSessionManager

+ (CSHClient *)sharedClient;
+ (void)csh_setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password;
+ (void)csh_clearAuthorizationHeaderField;

@end
