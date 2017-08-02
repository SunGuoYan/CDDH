//
//  BindToTelephoneVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/10.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "BindToTelephoneVC.h"
#import "CSHServiceAgreementVC.h"
#import "ActivityVC.h"

@interface BindToTelephoneVC ()<UITextFieldDelegate>
{
    UIImage *image_open;
    UIImage *image_close;
}
@property (weak, nonatomic) IBOutlet UIView *bg;

//手机号
@property (weak, nonatomic) IBOutlet UITextField *textFielda;
//密码
@property (weak, nonatomic) IBOutlet UITextField *textFieldb;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *textFieldc;

//展开密码  button
@property (weak, nonatomic) IBOutlet UIButton *btna;

//获取验证码 button
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//立即绑定
@property (weak, nonatomic) IBOutlet UIButton *btnc;
//同意优e通服务协议
@property (weak, nonatomic) IBOutlet UIButton *btnd;


@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timerScheduledTime;

@end

@implementation BindToTelephoneVC
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
    image_open=[[UIImage imageNamed:@"pwd_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image_close=[[UIImage imageNamed:@"pwd_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.btnb.backgroundColor=themeCorlor;
    self.btnb.radius=3;
    
    self.btnc.backgroundColor=themeCorlor;
    self.btnc.radius=3;
    
    self.bg.radius=3;
    
    [self.btnd setTitleColor:themeCorlor forState:UIControlStateNormal];
    self.title=@"绑定手机号";
    
    [self.btna setImage:image_open forState:UIControlStateNormal];
//    [self.btna setBackgroundImage:image_open forState:UIControlStateNormal];
    
    [self setGoBackBtnStyle];
    
    //手机号
    self.textFielda.keyboardType=UIKeyboardTypeNumberPad;
    self.textFielda.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFielda.delegate=self;
    
    //密码
    self.textFieldb.secureTextEntry=YES;
    self.textFieldb.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFieldb.delegate=self;
    
    //验证码
    self.textFieldc.keyboardType=UIKeyboardTypeNumberPad;
    self.textFieldc.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFieldc.delegate=self;
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.textFielda) {
        if (string.length==0) {
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
        
    }
    if (textField==self.textFieldb) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    if (textField==self.textFieldc) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

//展开密码  button
- (IBAction)btnaClicked:(UIButton *)sender {
    if (!self.btna.selected==YES) {
        [self.btna setImage:image_close forState:UIControlStateNormal];
//        [self.btna setBackgroundImage:image_close forState:UIControlStateNormal];
        self.textFieldb.secureTextEntry=NO;
    }else{
        [self.btna setImage:image_open forState:UIControlStateNormal];
//        [self.btna setBackgroundImage:image_open forState:UIControlStateNormal];
        self.textFieldb.secureTextEntry=YES;
    }
    self.btna.selected=!self.btna.selected;
}



//判断是否是有效的手机号
- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [phoneTest evaluateWithObject:phoneNumber];
}
#pragma mark --- 点击 获取验证码 button
- (IBAction)btnbClicked:(UIButton *)sender {
    
    if ([self.textFielda.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    if ([self isValidPhoneNumber:self.textFielda.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误！"];
        return;
    }
    
    [self getCode];

}
//倒计时1
-(void)timeOut{
//    [self.captchaButton csh_disableWithLoginAppearance];
    self.btnb.hidden=YES;
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.timerScheduledTime = [[NSDate new] timeIntervalSince1970];
    [self.timer fire];
    
    self.timeLab.hidden = NO;
    self.timeLab.backgroundColor=initialGray;
}
//倒计时2 每隔一秒执行一次的方法
- (void)handleTimer:(NSTimer *)timer {
    if (timer.valid) {
        NSTimeInterval fireDateInterval = [[NSDate new] timeIntervalSince1970] - self.timerScheduledTime;
        NSInteger remainingInterval = round(59 - fireDateInterval);
        if (remainingInterval > 0) {
            self.timeLab.text = [NSString stringWithFormat:@"%@秒", @(remainingInterval)];
        } else {
            [self.timer invalidate];
            self.timer = nil;
            
            self.btnb.hidden=NO;
            self.timeLab.hidden=YES;
            
//            [self.captchaButton csh_enableWithLoginAppearance];
//            self.countingLabel.hidden = YES;
        }
    } else {
        self.btnb.hidden=NO;
//        [self.captchaButton csh_enableWithLoginAppearance];
    }
    
    // send message
}

-(void)getCode{
    //短信验证
    //type=1 注册 没注册成功可以一直发
    //type=2 找回密码 的发送短信的接口  注册成功之后可以一直发
    //type =3 绑定
    
    NSString *api=@"/oauth/send-otp-code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"type":@"3",@"phone":self.textFielda.text};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置超时时间
//    [_operation.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    _operation.requestSerializer.timeoutInterval = 3.f;
//    [_operation.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",response[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"短信发送成功！"];
            [self timeOut];
            
        }else{
            [MBProgressHUD showError:@"短信发送失败！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [MBProgressHUD showError:@"网络请求错误！"];
    }];
}
//密码需要包含数字、字母、字符两种及两种以上组合
-(BOOL)validatePassword:(NSString *)password
{
    NSString * patt = @"^(?![A-Z]*$)(?![a-z]*$)(?![0-9]*$)(?![^a-zA-Z0-9]*$)\\S+$";
    NSPredicate * predd1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patt];
    BOOL isSuccess = [predd1 evaluateWithObject:password];
    return isSuccess;
}
#pragma mark--- 立即绑定
- (IBAction)btncClicked:(UIButton *)sender {
    
    if ([self.textFielda.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    if ([self isValidPhoneNumber:self.textFielda.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误！"];
        return;
    }
    if ([self.textFieldb.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码不能为空！"];
        return;
    }
    //6-16
    if ((self.textFieldb.text.length>16)||(self.textFieldb.text.length<6)) {
        [MBProgressHUD showError:@"密码格式错误！"];
        return;
    }
    //数字 字母 特殊字符中的两种
    if ([self validatePassword:self.textFieldb.text]==NO) {
        [MBProgressHUD showError:@"密码格式错误！"];
        return;
    }
    
    if ([self.textFieldc.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"验证码不能为空！"];
        return;
    }
    if ((self.textFieldc.text.length>6)||(self.textFieldc.text.length<5)) {
        [MBProgressHUD showError:@"验证码格式错误！"];
        return;
    }
    
    [self bindToTelephone];
}
-(void)bindToTelephone{
    NSString *api=@"/oauth/token";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"grant_type":@"bind",
                             @"phone":self.textFielda.text,
                             @"password":self.textFieldb.text,
                             @"code":self.textFieldc.text,
                             @"provider":self.provider,
                             @"uid":self.uid};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置请求格式
    //    _operation.requestSerializer = [AFJSONRequestSerializer serializer];
    //    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头 一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    //设置请求头 二
    [_operation.requestSerializer setValue:@"Basic eW91ZXRvbmctYW5kcm9pZDpzZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    
    //发送请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *token=responseObject[@"access_token"];
        if (token!=nil) {
            //记录登录状态
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"accountId"];
            [defaults setObject:token forKey:@"access_token"];
            [defaults synchronize];
            
            //登录成功之后获取用户信息
            [self getUserInfomation];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
     
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        NSLog(@"errorCode:%@",errorCode);
        if ([errorCode isEqualToString:@"400"]) {
            [MBProgressHUD showError:@"验证码错误！"];
            return ;
        }
        [MBProgressHUD showError:@"网络连接错！"];
        NSLog(@"error:%@",error);
        
    }];
    
    
}

-(void)getUserInfomation{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取用户基本信息
        NSString *nickname=responseObject[@"nickname"];
        NSString *phone=responseObject[@"phone"];
        NSString *imageUrlStr=[NSString stringWithFormat:@"%@",responseObject[@"avatar"]];
        NSString *userMoney=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if (![nickname isEqualToString:@"<null>"]) {
            
            [defaults setObject:nickname forKey:@"userName"];
        }
        
        [defaults setObject:phone forKey:@"userPhone"];
        //        if (imageUrlStr!=nil) {
        //            [defaults setObject:imageUrlStr forKey:@"userImage"];
        //        }
        if (![imageUrlStr isEqualToString:@"<null>"]) {
            
            [defaults setObject:imageUrlStr forKey:@"userImage"];
        }
        
        if (![userMoney isEqualToString:@"<null>"]) {
            
            [defaults setObject:userMoney forKey:@"userMoney"];
        }
        
        
        [defaults synchronize];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

//同意优e通服务协议
- (IBAction)btndClicked:(UIButton *)sender {
    [self getServiceAgreementData];
}
-(void)getServiceAgreementData{
    NSString *api=@"/api/contents/checklog";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"classification":@"REGISTER"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array=responseObject;
        NSDictionary *tempDic=array[0];
        
        [self pushToServiceAgreementVCWithtextType:tempDic[@"textType"] andText:tempDic[@"text"]  andUrl:tempDic[@"url"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)pushToServiceAgreementVCWithtextType:(NSString *)textType andText:(NSString *)text andUrl:(NSString *)url{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    ActivityVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ActivityVC class])];
    vc.textType=textType;
    vc.url=url;
    vc.text=text;
    vc.navigationTitle=@"充电大亨服务协议";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
