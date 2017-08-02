//
//  EndChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/22.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "EndChargingVC.h"

@interface EndChargingVC ()
//

@property (weak, nonatomic) IBOutlet UIView *containerViewa;
@property (weak, nonatomic) IBOutlet UIView *containerViewb;
//完成充电 更改颜色需要
@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;
@property (weak, nonatomic) IBOutlet UILabel *labd;


@property (weak, nonatomic) IBOutlet UILabel *labe;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation EndChargingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=initialGray;
    self.containerViewa.backgroundColor=initialGray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmBtnClicked:(UIButton *)sender {
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
