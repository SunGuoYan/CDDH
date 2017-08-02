//
//  StartChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/18.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "StartChargingVC.h"
#import "OnChargingVC.h"
#import "ChargingRuleVC.h"

@interface StartChargingVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bigContainView;
@property (weak, nonatomic) IBOutlet UILabel *laba;
@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;
@property (weak, nonatomic) IBOutlet UILabel *labd;
@property (weak, nonatomic) IBOutlet UILabel *labe;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *Btn;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageV;


@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *chargeRuleLab;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

@end

@implementation StartChargingVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getUserInfomationStartCharging];
    
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)getUserInfomationStartCharging{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSString *userMoney=responseObject[@"money"];
        
        
        self.balance.text=[NSString stringWithFormat:@"%@",userMoney];
        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:userMoney forKey:@"userMoney"];
//        [defaults synchronize];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"开始充电";
    self.animationImageV.hidden=YES;
    
    self.Btn.radius=75;
}

#pragma mark --- 点击返回按钮
- (IBAction)goBackBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 点击充电规则按钮

- (IBAction)chargerRuleBtnClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChargingRuleVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChargingRuleVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 点击开启充电
- (IBAction)btnClicked:(UIButton *)sender {
    
    double balanceMoney=[self.balance.text doubleValue];
    NSLog(@"balance:%@",self.balance.text);
    
//    if (balanceMoney==0) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"钱包余额不足，请先充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",  nil];
//        alert.alertViewStyle=UIAlertViewStyleDefault;
//        [alert show];
//        
//    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OnChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OnChargingVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

//弹出框 协议函数 响应事件  未完待续
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) { //ok
        
    }else if (buttonIndex==0){//cancel
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
