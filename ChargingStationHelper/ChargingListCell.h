//
//  ChargingListCell.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/13.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargingListCell : UITableViewCell


////cell左边的圆形
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

//cell中间的4个
@property (weak, nonatomic) IBOutlet UILabel *laba;
@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;
@property (weak, nonatomic) IBOutlet UILabel *labd;

//cell右边的两个
@property (weak, nonatomic) IBOutlet UILabel *labe;
@property (weak, nonatomic) IBOutlet UILabel *labf;

@property (weak, nonatomic) IBOutlet UILabel *qiangA;
@property (weak, nonatomic) IBOutlet UILabel *qiangB;
@property (weak, nonatomic) IBOutlet UILabel *qiangC;
@property (weak, nonatomic) IBOutlet UILabel *qiangD;





@end
