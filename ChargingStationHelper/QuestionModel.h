//
//  QuestionModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/31.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *textType;

@property(nonatomic,copy)NSString *urlStr;//网页
@property(nonatomic,copy)NSString *text;//html

@end
