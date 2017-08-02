//
//  CSHStartChargingVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/6.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHStartChargingVC : UIViewController

//正向传值
@property(nonatomic,copy)NSString *cif;
@property(nonatomic,copy)NSString *voltage;
@property(nonatomic,copy)NSString *power;

@property(nonatomic,copy)NSString *chargerConn;//电桩上面的枪的id

@property(nonatomic,copy)NSString *chargerCode;//用于电桩的界面查询 code不是id
//@property(nonatomic,copy)NSString *chargerId;//电桩id

@property(nonatomic,copy)NSString *stationId;


@end
