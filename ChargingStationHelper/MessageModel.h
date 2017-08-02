//
//  MessageModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property(nonatomic,copy)NSString *message_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *ifRead;
@end
