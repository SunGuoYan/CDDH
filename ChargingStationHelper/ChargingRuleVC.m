//
//  ChargingRuleVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/22.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ChargingRuleVC.h"

@interface ChargingRuleVC ()

@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UILabel *labb;

@property (weak, nonatomic) IBOutlet UILabel *labc;

@end

@implementation ChargingRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"计费规则";
    self.view.backgroundColor=initialGray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
