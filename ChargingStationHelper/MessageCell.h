//
//  MessageCell.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@interface MessageCell : UITableViewCell

@property(strong,nonatomic)UILabel *laba;
@property(strong,nonatomic)UILabel *labb;
@property(strong,nonatomic)UILabel *labc;
@property(strong,nonatomic)UIView  *line;//分割线
@property(strong,nonatomic)MessageModel *model;
@end
