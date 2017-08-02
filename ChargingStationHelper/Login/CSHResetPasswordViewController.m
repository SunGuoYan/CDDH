//
//  CSHResetPasswordViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHResetPasswordViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"
#import "CSHNewPasswordViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "NewPasswordVC.h"

@interface CSHResetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *captchaButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *countingLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timerScheduledTime;

//
//

@property (weak, nonatomic) IBOutlet UITextField *textFileda;

@end

@implementation CSHResetPasswordViewController

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
    
    self.textFileda.delegate=self;
    self.textFileda.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.phoneNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.captchaTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    [self.inputContainerView csh_setDefaultCornerRadius];
    [self.captchaButton csh_setDefaultCornerRadius];
    [self.captchaButton csh_enableWithLoginAppearance];
    [self.nextButton csh_setDefaultCornerRadius];
    
    self.nextButton.backgroundColor=themeCorlor;
    [self.countingLabel csh_setDefaultCornerRadius];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField==self.textFileda) {
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
   
   
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//判断是否是有效的手机号
- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [phoneTest evaluateWithObject:phoneNumber];
}
#pragma mark - 点击获取验证码按钮
- (IBAction)handleCaptchaButton:(UIButton *)sender {
    
    if ([self isValidPhoneNumber:self.phoneNumberTextField.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误"];
        return ;
    }
    
    [self getCode];
    
    [self timeOut];
    
    
}



#pragma mark -   点击下一步按钮
- (IBAction)handleNextButton:(UIButton *)sender {
    
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.captchaTextField.text forKey:@"resetCode"];
//    [defaults setObject:self.phoneNumberTextField.text forKey:@"resetPhoneNumber"];
//    [defaults synchronize];
    
    
    if ([self isValidPhoneNumber:self.textFileda.text]==NO) {
        [MBProgressHUD showError:@"手机号格式错误"];
        return ;
    }
    [self getCode];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)getCode{
    //短信验证
    //type=1 注册 没注册成功可以一直发
    //type=2 找回密码 的发送短信的接口  注册成功之后可以一直发
    
    NSString *api=@"/oauth/send-otp-code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    
    NSDictionary *para=@{@"type":@"2",@"phone":self.textFileda.text};
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.textFileda.text forKey:@"resetPhoneNumber"];
    [defaults synchronize];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置超时时间
    [_operation.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _operation.requestSerializer.timeoutInterval = 3.f;
    [_operation.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",response[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"短信发送成功！"];
            
            [self showNewPasswordViewController];
            
        }else{
            [MBProgressHUD showError:@"短信发送失败！"];
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
        
        [MBProgressHUD showError:@"网络请求错误！"];
    }];
}

-(void)timeOut{
    self.captchaButton.hidden=YES;
//    [self.captchaButton csh_disableWithLoginAppearance];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timerScheduledTime = [[NSDate new] timeIntervalSince1970];
    [self.timer fire];
    self.countingLabel.hidden = NO;
    
    
    // test
//    [self showNewPasswordViewController];
}
//60 秒倒计时
- (void)handleTimer:(NSTimer *)timer {
    if (timer.valid) {
        NSTimeInterval fireDateInterval = [[NSDate new] timeIntervalSince1970] - self.timerScheduledTime;
        NSInteger remainingInterval = round(59 - fireDateInterval);
        if (remainingInterval > 0) {
            self.countingLabel.text = [NSString stringWithFormat:@"%@", @(remainingInterval)];
        } else {
            [self.timer invalidate];
            self.timer = nil;
            self.captchaButton.hidden=NO;
//            [self.captchaButton csh_enableWithLoginAppearance];
            self.countingLabel.hidden = YES;
        }
    } else {
        self.captchaButton.hidden=NO;
//        [self.captchaButton csh_enableWithLoginAppearance];
    }
    
    // send message
}

#pragma mark - navigation

- (void)showNewPasswordViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    NewPasswordVC *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewPasswordVC class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
