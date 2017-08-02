//
//  chargingHistoryCell.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/8/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chargingHistoryCell : UITableViewCell
//充电点
@property (weak, nonatomic) IBOutlet UILabel *chargingPlaceLab;
//电桩号
@property (weak, nonatomic) IBOutlet UILabel *stationNOLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLongLab;

@property (weak, nonatomic) IBOutlet UILabel *chargeState;


@property (weak, nonatomic) IBOutlet UILabel *creatAtLab;


//时间的label
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//消耗的能量块
@property (weak, nonatomic) IBOutlet UILabel *spendMoneyLab;

@end
