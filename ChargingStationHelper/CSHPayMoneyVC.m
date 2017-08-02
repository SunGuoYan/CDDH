//
//  CSHPayMoneyVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/5.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHPayMoneyVC.h"

#import "SDKExport/WXApi.h"//记得在header search里面配置路径
#import <AlipaySDK/AlipaySDK.h>

@interface CSHPayMoneyVC ()<UITextFieldDelegate>
{
    
    UIColor *themeColor;
    NSString *_info;
    NSString *payFrom;
    
    AFHTTPRequestOperationManager *manger;
    NSMutableDictionary *weixin;
}

@property (weak, nonatomic) IBOutlet UIButton *btna;

@property (weak, nonatomic) IBOutlet UIButton *btnb;

@property (weak, nonatomic) IBOutlet UIButton *btnc;

@property (weak, nonatomic) IBOutlet UIButton *btnd;

@property (weak, nonatomic) IBOutlet UIButton *btne;
@property (weak, nonatomic) IBOutlet UIButton *btnf;

@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTF;

//两个icon
@property (weak, nonatomic) IBOutlet UIImageView *alipayIcon;
@property (weak, nonatomic) IBOutlet UIImageView *weixinPayIcon;

//两个选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseAlipay;
@property (weak, nonatomic) IBOutlet UIButton *chooseWeiXinPay;
//总面额
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
//
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
//
@end

@implementation CSHPayMoneyVC


-(void)setGoBackBtnStyle{
    
//    [self.navigationItem setHidesBackButton:YES];
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackAction) name:@"goBackToMyBalance" object:nil];

    
    [self setGoBackBtnStyle];
    
    self.btna.backgroundColor=initialGray;
    self.btnb.backgroundColor=initialGray;
    self.btnc.backgroundColor=initialGray;
    self.btnd.backgroundColor=initialGray;
    self.btne.backgroundColor=initialGray;
    self.btnf.backgroundColor=initialGray;
    
    //默认支付宝
    payFrom=@"ALIPAY";
    
    self.totalMoneyTF.delegate=self;
    self.totalMoneyTF.keyboardType=UIKeyboardTypeDecimalPad;
    themeColor=[UIColor colorWithRed:0 green:0.71 blue:0.69 alpha:1];
    
    self.totalMoneyTF.layer.borderWidth=1;
    self.totalMoneyTF.layer.borderColor=initialGray.CGColor;
    
    self.btna.backgroundColor=themeBlue;
    [self.btna setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.totalMoneyLab.textColor=[UIColor whiteColor];
    
    self.totalMoneyTF.text=@"30";
//    self.totalMoneyTF.keyboardType=UIKeyboardTypeNumberPad;
    
    self.totalMoneyLab.text=[NSString stringWithFormat:@"%@",self.totalMoneyTF.text];
    self.payBtn.backgroundColor=themeBlue;
    
    self.payBtn.radius=4;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.totalMoneyLab.text=[NSString stringWithFormat:@"%@",self.totalMoneyTF.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




- (IBAction)btnaClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"30"];
    
}

- (IBAction)btnbClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"50"];
}

- (IBAction)btncClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"100"];
}

- (IBAction)btndClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"200"];
}

- (IBAction)btneClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"300"];
}
- (IBAction)btnfClicked:(UIButton *)sender {
    [self changeWithButton:sender];
    [self changeTotalTFAndLab:@"500"];
}
-(void)changeWithButton:(UIButton *)button{

    self.btna.backgroundColor=initialGray;
    self.btnb.backgroundColor=initialGray;
    self.btnc.backgroundColor=initialGray;
    self.btnd.backgroundColor=initialGray;
    self.btne.backgroundColor=initialGray;
    self.btnf.backgroundColor=initialGray;
    
    button.backgroundColor=themeBlue;
    
    [self.btna setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnf setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)changeTotalTFAndLab:(NSString *)number{
    self.totalMoneyTF.text=number;
    self.totalMoneyLab.text=[NSString stringWithFormat:@"%@",number];
}

//选择支付宝
- (IBAction)chooseAlipayBtnClicked:(UIButton *)sender {
    
    self.alipayIcon.image=[UIImage imageNamed:@"icon_pay_checked"];
    self.weixinPayIcon.image=[UIImage imageNamed:@"icon_pay_unchecked"];
    
    payFrom=@"ALIPAY";
}
//选择微信
- (IBAction)chooseWeiXinPayBtnClicked:(UIButton *)sender {
    
    self.alipayIcon.image=[UIImage imageNamed:@"icon_pay_unchecked"];
    self.weixinPayIcon.image=[UIImage imageNamed:@"icon_pay_checked"];
    
    payFrom=@"WEBCHART";
}

//验证金额的方法如下:
-(BOOL)validateMoney:(NSString *)money
{
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}
#pragma mark --- 点击支付按钮
- (IBAction)payBtnClicked:(UIButton *)sender {
    
    if (![self validateMoney:self.totalMoneyLab.text]==YES) {
        [MBProgressHUD showError:@"充值金额不正确！"];
        return;
    }
    if (self.totalMoneyLab.text.floatValue>8000) {
        [MBProgressHUD showError:@"单次充值不超过8000！"];
        return;
    }
    
    if (self.totalMoneyLab.text.floatValue>0.009) {
        if ([payFrom isEqualToString:@"ALIPAY"]) {
            [self sendPayMoneyRequest];
        }else{
            [self WXPay];
        }
    }else{
        [MBProgressHUD showError:@"充值金额不正确！"];
    }
}
//获取后台返回的数据
- (void)WXPay{
    NSString *api=@"/api/orders/createRechargeRecord";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    //WEBCHART
    NSDictionary *para=@{@"payFrom":@"WEBCHART",@"money":self.totalMoneyLab.text};//WEBCHART
    manger = [AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    // 设置返回格式
    manger.responseSerializer= [AFHTTPResponseSerializer serializer];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [manger.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];

    
    [manger POST:urlStr parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //请求成功执行此处的代码
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dic:%@",dic);
        
//        NSLog(@"收到的:%@---线程:%@", responseObject, [NSThread currentThread]);
        
        //官方后台返回的数据
        /*
         
         {
         appid = wxb4ba3c02aa476ea1;
         noncestr = 94c4e76bcc1caf24df46063911544012;
         package = "Sign=WXPay";
         partnerid = 1305176001;
         
         prepayid = wx201609210940393b80c581740462564511;
         sign = FD6D827AE2EE43B83A12F756F245A1E5;
         timestamp = 1474422039;
         }
         */
        
        //后台返回的字典  优e通里面 返回的是String ？
        weixin = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self GoToWXPay];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
    
    }];
}
#pragma mark ---调用微信支付接口
- (void)GoToWXPay{
    NSMutableString *stamp  = [weixin objectForKey:@"timestamp"];
    
    PayReq *req = [[PayReq alloc]init];
    
    //调试微信的官方接口成功
    //自己做的的时候也是配置req的这几个属性，或者直接后台返回的信息作为req？？？
    req.partnerId           = [weixin objectForKey:@"partnerid"];
    req.prepayId            = [weixin objectForKey:@"prepayid"];
    req.nonceStr            = [weixin objectForKey:@"noncestr"];
    
    req.timeStamp           = stamp.intValue;
    req.package             = [weixin objectForKey:@"package"];
    req.sign                = [weixin objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}


#pragma mark ---后台获取支付宝支付的订单信息
-(void)sendPayMoneyRequest{
    NSString *api=@"/api/orders/createRechargeRecord";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"payFrom":payFrom,@"money":self.totalMoneyLab.text};//WEBCHART
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *token=[defaults objectForKey:@"access_token"];
  
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _info=[NSString stringWithFormat:@"%@",operation.responseString];
        
//        NSLog(@"info:%@",_info);
        
        if (_info!=nil) {
            
            [self goToAlipayAPI];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];
}

#pragma mark --- 支付宝支付成功的回调
-(void)goToAlipayAPI{
    if (_info!=nil) {
        
        NSString *urlScheme=@"iycharge";
        
        //调用支付宝的SDK
        [[AlipaySDK defaultService] payOrder:_info fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"resultDic:%@",resultDic);
            
        }];
    }
}




@end
