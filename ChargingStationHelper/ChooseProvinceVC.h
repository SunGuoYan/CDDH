//
//  ChooseProvinceVC.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/12/15.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseProvinceBlock)(NSString *provinceStr,NSString *cityStr,NSString *districtStr);
@interface ChooseProvinceVC : UIViewController
@property(nonatomic,copy)ChooseProvinceBlock myBlcok;
@end
