//
//  GunCell.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 17/1/5.
//  Copyright © 2017年 com.iycharge. All rights reserved.
//

#import "GunCell.h"

@implementation GunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labb.layer.cornerRadius=3;
    self.labb.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
