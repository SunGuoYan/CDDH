//
//  ChargingListCell.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/13.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ChargingListCell.h"

@implementation ChargingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberLab.radius=20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
