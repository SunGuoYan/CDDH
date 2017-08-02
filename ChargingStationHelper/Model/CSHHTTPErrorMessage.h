//
//  CSHErrorMessage.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHModel.h"

@interface CSHHTTPErrorMessage : CSHModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSArray *errors;

@end
