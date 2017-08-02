//
//  CSHChargerDetailVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSHCharger.h"
//@class CSHCharger;

@interface CSHChargerDetailVC : UIViewController
//正向传值
@property(nonatomic,copy)NSString *chargerCode;
//@property(nonatomic,copy)NSString *chargerId;

@property(nonatomic,copy)NSString *chargerQrcode;//扫码充电

@property (weak, nonatomic) IBOutlet UILabel *chargerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerEndNameLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerParkNumLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerConnectLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *chargerStateLab;

//横幅
@property (weak, nonatomic) IBOutlet UILabel *chargerBrand;

//立即充电的btn
@property (weak, nonatomic) IBOutlet UIButton *startChargingBtn;

@end
