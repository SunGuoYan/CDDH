//
//  CSHDriverCertificatingViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/20/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHDriverCertificatingViewController : UITableViewController
//正向传值
@property(nonatomic,copy)NSString *driverId;

@property(nonatomic,copy)NSString *carBrand;
@property(nonatomic,copy)NSString *carType;

@property(nonatomic,copy)NSString *frameNumber;
@property(nonatomic,copy)NSString *engineNumber;
@property(nonatomic,copy)NSString *drivingLicensePhoto;
@property(nonatomic,copy)NSString *plateNumber;
//btn
@property(nonatomic,copy)NSString *carIdentifyStatus;
@end
