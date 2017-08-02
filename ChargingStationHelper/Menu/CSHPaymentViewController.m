//
//  CSHPaymentViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/19/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHPaymentViewController.h"

@interface CSHPaymentViewController ()
//请输入充值金额
@property (weak, nonatomic) IBOutlet UITextField *PaymentTextField;

//背景视图
@property (weak, nonatomic) IBOutlet UIView *choosePaymentContainerView;

//选择支付方式 label
@property (weak, nonatomic) IBOutlet UILabel *choosePaymentLab;
//支付宝 label
@property (weak, nonatomic) IBOutlet UILabel *zhiFuBaoLab;
//微信 label
@property (weak, nonatomic) IBOutlet UILabel *weiXinLab;
//支付宝 icon
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoIcon;
//微信 icon
@property (weak, nonatomic) IBOutlet UIImageView *weiXinIcon;
//分界线
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation CSHPaymentViewController
-(void)setGoBackBtnStyle{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(35, 5, 10, 20);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoBackBtnStyle];
    
    self.PaymentTextField.keyboardType=UIKeyboardTypeNumberPad;
    
//    self.choosePaymentLab.hidden=YES;
//    self.weiXinLab.hidden=YES;
//    self.weiXinIcon.hidden=YES;
//    self.separatorLine.hidden=YES;
    
    CGFloat h=self.choosePaymentContainerView.frame.size.height;
    CGFloat w=self.choosePaymentContainerView.frame.size.width;
    CGFloat x=self.choosePaymentContainerView.frame.origin.x;
    CGFloat y=self.choosePaymentContainerView.frame.origin.y;
    self.choosePaymentContainerView.frame=CGRectMake(x, y, w, h/3);
    
    self.title = @"钱包充值";
}
- (IBAction)paymentClicked:(UIButton *)sender {
    
    NSLog(@"%@",self.PaymentTextField.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
