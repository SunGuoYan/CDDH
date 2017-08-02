//
//  CSHTabBarController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/14/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHTabBarController.h"
#import "CSHChargingViewController.h"
#import "CSHMapViewController.h"
#import "SDKExport/WXApi.h"
@interface CSHTabBarController () <CSHChargingViewControllerDelegate>

@end

@implementation CSHTabBarController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor=[UIColor colorWithRed:0 green:0.71 blue:0.69 alpha:1];
//    self.tabBar.tintColor=[UIColor blueColor];//设置文字颜色
    self.tabBar.translucent=YES;
    // Do any additional setup after loading the view.
    
    UINavigationController *navigationController = self.viewControllers[1];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        CSHChargingViewController *chargingViewController = navigationController.viewControllers[0];
        if ([chargingViewController isKindOfClass:[CSHChargingViewController class]]) {
            chargingViewController.delegate = self;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CSHChargingViewControllerDelegate

- (void)chargingViewControllerDidStop {
    [self setSelectedIndex:0];
}

@end
