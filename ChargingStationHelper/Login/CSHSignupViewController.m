//
//  CSHSignupViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHSignupViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"
#import "AFNetworking.h"

#import "MBProgressHUD+MJ.h"

#import "CSHServiceAgreementVC.h"
#import "ActivityVC.h"

@interface CSHSignupViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputContainerView;

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//输入验证码
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
//点击获验证码 button
@property (weak, nonatomic) IBOutlet UIButton *captchaButton;
//注册 button
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
//点击 获取验证码之后的 button变为倒计时的label
@property (weak, nonatomic) IBOutlet UILabel *countingLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timerScheduledTime;

@property (weak, nonatomic) IBOutlet UILabel *phoneService;




@end

@implementation CSHSignupViewController

- (IBAction)makeCall:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0512-63957614"]];
}

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
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.phoneService.text];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:themeBlue
                    range:NSMakeRange(12, 13)];
    
    self.phoneService.attributedText=attrStr;
    
    [self setGoBackBtnStyle];
    
    self.phoneTextField.delegate=self;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.captchaTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    
    
    self.passwordTextField.delegate=self;
    self.passwordTextField.secureTextEntry=YES;
    
    self.captchaTextField.delegate=self;
    
    self.phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.captchaTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    [self.inputContainerView csh_setDefaultCornerRadius];
    [self.captchaButton csh_setDefaultCornerRadius];
    [self.captchaButton csh_enableWithLoginAppearance];
    [self.signupButton csh_setDefaultCornerRadius];
    [self.countingLabel csh_setDefaultCornerRadius];
    
    self.signupButton.backgroundColor=themeCorlor;
    self.captchaButton.backgroundColor=themeCorlor;
}
//textFiled限制长度x
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.phoneTextField) {
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
    if (textField==self.passwordTextField) {
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
    if (textField==self.captchaTextField) {
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
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//判断是否是有效的手机号
- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [phoneTest evaluateWithObject:phoneNumber];
}
#pragma mark --- 点击获取验证码按钮
- (IBAction)handleCaptchaButton:(UIButton *)sender {
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    
    if ([self isValidPhoneNumber:self.phoneTextField.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误！"];
        return;
    }
    
    
    [self getCode];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - 短信验证,手机获取验证码
-(void)getCode{
    //短信验证
    //type=1 注册 没注册成功可以一直发
    //type=2 找回密码 的发送短信的接口  注册成功之后可以一直发
    NSString *api=@"/oauth/send-otp-code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"type":@"1",@"phone":self.phoneTextField.text};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",response[@"httpErrorCode"]];
        NSString *message=response[@"errorDescr"];
        
        if ([httpErrorCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:message];
            [self timeOut];
        }else{
            [MBProgressHUD showError:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        NSData *jsonData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *message=dic[@"errorDescr"];
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",dic[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"422"]) {
            [MBProgressHUD showError:message];
            return ;
        }
        
//        NSString *statusCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
//        
//        if ([statusCode isEqualToString:@"422"]) {
//            [MBProgressHUD showError:@"手机号已被注册！"];
//            return ;
//        }
        
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

#pragma mark --- 点击注册 button
- (IBAction)handleSignupButton:(UIButton *)sender {
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    
    if ([self isValidPhoneNumber:self.phoneTextField.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误！"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码不能为空！"];
        return;
    }
    //6-16位
    if ((self.passwordTextField.text.length>16)||(self.passwordTextField.text.length<6)) {
        [MBProgressHUD showError:@"密码格式错误！"];
        return;
    }
    //数字 字母 特殊字符中的两种
    if ([self validatePassword:self.passwordTextField.text]==NO) {
        [MBProgressHUD showError:@"密码格式错误！"];
        return;
    }
    
    if ([self.captchaTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"验证码不能为空！"];
        return;
    }
    
    
    NSString *api=@"/api/user/register";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"phone":self.phoneTextField.text,@"password":self.passwordTextField.text,@"code":self.captchaTextField.text,@"type":@"1"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置请求格式
    //    _operation.requestSerializer = [AFJSONRequestSerializer serializer];
    //    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //发送请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",responseObject[@"httpErrorCode"]];
        
        if ([httpErrorCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"注册成功"];
            
            [self goToLogin];
            
        }else{
            [MBProgressHUD showError:@"注册失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        
        NSData *jsonData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *message=dic[@"errorDescr"];
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",dic[@"httpErrorCode"]];
        //180服务器上
        /*
         {"httpErrorCode":500,"errorCode":null,"errorDescr":"请求失败"}
         */
        if ([httpErrorCode isEqualToString:@"422"]) {
            [MBProgressHUD showError:message];
            return ;
        }
        
        
        [MBProgressHUD showError:@"网络错误！"];
        
    }];
}
-(void)goToLogin{
    
    UIViewController *vc  = self.navigationController.viewControllers[1];
    
    [self.navigationController  popToViewController:vc animated:YES];
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    
    
    //这里为什么不能pop到vc，但是可以push到？
    //    [self.navigationController popToViewController:vc animated:YES];
    //    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- 点击同意 优e通服务协议
- (IBAction)handleServiceItemsButton:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
//    CSHServiceAgreementVC *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ CSHServiceAgreementVC class])];
//    [self.navigationController pushViewController:paymentViewController animated:YES];
    
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
        //如果后台没有提交服务协议
        if (array.count==0) {
            return ;
        }
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


//倒计时1
-(void)timeOut{
    [self.captchaButton csh_disableWithLoginAppearance];
    [self.captchaButton setTitle:nil forState:UIControlStateNormal];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.timerScheduledTime = [[NSDate new] timeIntervalSince1970];
    [self.timer fire];
    
    
    self.countingLabel.hidden = NO;
}
//倒计时2 每隔一秒执行一次的方法
- (void)handleTimer:(NSTimer *)timer {
    if (timer.valid) {
        NSTimeInterval fireDateInterval = [[NSDate new] timeIntervalSince1970] - self.timerScheduledTime;
        NSInteger remainingInterval = round(59 - fireDateInterval);
        if (remainingInterval > 0) {
            self.countingLabel.text = [NSString stringWithFormat:@"%@秒", @(remainingInterval)];
        } else {
            [self.timer invalidate];
            self.timer = nil;
            [self.captchaButton csh_enableWithLoginAppearance];
            
            self.captchaButton.backgroundColor=themeBlue;
            
            [self.captchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.countingLabel.hidden = YES;
        }
    } else {
        [self.captchaButton csh_enableWithLoginAppearance];
        self.captchaButton.backgroundColor=themeBlue;
        [self.captchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    // send message
}

@end
