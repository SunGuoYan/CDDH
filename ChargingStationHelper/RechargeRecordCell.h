//
//  RechargeRecordCell.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/7.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *spaceLab;

@property (weak, nonatomic) IBOutlet UILabel *recordCreatedAt;

@property (weak, nonatomic) IBOutlet UILabel *recordMoney;
//
@property (weak, nonatomic) IBOutlet UILabel *recordPaidFrom;
@property (weak, nonatomic) IBOutlet UILabel *recordStatus;


@end
