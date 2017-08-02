//
//  CSHProvinceSelectionViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/20/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSHProvinceSelectionViewControllerDelegate <NSObject>

- (void)provinceSelectionViewControllerDidStop;
- (void)provinceSelectionViewControllerDidStopWithName:(NSString *)name;

@end

@interface CSHProvinceSelectionViewController : UIViewController

@property (nonatomic, weak) id <CSHProvinceSelectionViewControllerDelegate> delegate;

@end
