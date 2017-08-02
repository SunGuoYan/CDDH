//
//  CSHBalanceViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/19/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHBalanceViewController.h"
#import "CSHPaymentViewController.h"

#import "CSHPayMoneyVC.h"
#import "CSHRechargeRecordTableVC.h"
#import "CSHRechargeRecordsVC.h"


@interface CSHBalanceViewController ()
{
    NSString *_userMoney;
}
@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (weak, nonatomic) IBOutlet UIView *backContainerView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@end

@implementation CSHBalanceViewController

-(void)setGoBackBtnStyle{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payBtn.backgroundColor=themeBlue;
    self.backContainerView.backgroundColor=themeBlue;
    
    self.view.backgroundColor=bginitialGray;
    self.title = @"我的钱包";
    
    [self setGoBackBtnStyle];
}
-(void)getUserInfomationMyMoney{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        NSString *doubleString=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
        NSDecimalNumber *decNumber=[NSDecimalNumber decimalNumberWithString:doubleString];
        self.balance.text=decNumber.stringValue;
         */

        NSString *userMoney=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
        ;
        
        self.balance.text=[NSString stringWithFormat:@"%.2lf元",[userMoney doubleValue]];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:userMoney forKey:@"userMoney"];
        [defaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error:%@",error);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getUserInfomationMyMoney];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark --- 点击充值按钮  push到 钱包充值界面
- (IBAction)handlePaymentButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    CSHPayMoneyVC *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHPayMoneyVC class])];
    [self.navigationController pushViewController:paymentViewController animated:YES];
    
}
#pragma mark --- 点击充值记录
- (IBAction)rechargeRecordBtnClicked:(UIButton *)sender {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    CSHRechargeRecordsVC *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ CSHRechargeRecordsVC class])];
    [self.navigationController pushViewController:paymentViewController animated:YES];
}


@end
