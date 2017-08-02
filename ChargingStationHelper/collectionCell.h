//
//  collectionCell.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/8/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;


@property (weak, nonatomic) IBOutlet UILabel *publicStationLab;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;


@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UIButton *bookingBtn;

@end
