//
//  CSHCarBrandListViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/18/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

//逆向传值
@protocol CSHCarBrandListViewControllerDelegate <NSObject>
//- (void)carBrandListViewControllerDidStopWithBrand:(NSString *)brand series:(NSString *)series;
- (void)carBrandListViewControllerDidStopWithBrandName:(NSString *)brandName andBrandImageStr:(NSString *)brandImageStr andSeries:(NSString *)series;
@end

@interface CSHCarBrandListViewController : UIViewController

@property (nonatomic, weak) id <CSHCarBrandListViewControllerDelegate> delegate;

@end
