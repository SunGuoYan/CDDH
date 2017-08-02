//
//  CSHError.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHModel.h"

@interface CSHHTTPError : CSHModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *resource;
@property (nonatomic, copy, readonly) NSString *field;
@property (nonatomic, copy, readonly) NSString *code;

@end
