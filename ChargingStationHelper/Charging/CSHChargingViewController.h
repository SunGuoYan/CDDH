//
//  CSHChargingViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理传值 给tabBarVC下命令 index=1
@protocol CSHChargingViewControllerDelegate <NSObject>

- (void)chargingViewControllerDidStop;

@end

@interface CSHChargingViewController : UIViewController

@property (nonatomic, weak) id<CSHChargingViewControllerDelegate> delegate;

@end
