//
//  CSHModel.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/3/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHModel.h"

@implementation CSHModel
//NSDateFormatter
+ (NSDateFormatter *)p_csh_dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    return dateFormatter;
}
//NSValueTransformer   数据类型的转换  这里的string怎么传进来的？
+ (NSValueTransformer *)csh_dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        //NSString ->NSDate
        return [[self p_csh_dateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        //NSDate ->NSString
        return [[self p_csh_dateFormatter] stringFromDate:date];
    }];
}


@end
