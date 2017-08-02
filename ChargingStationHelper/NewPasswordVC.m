//
//  NewPasswordVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/24.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "NewPasswordVC.h"
#import "CSHLoginViewController.h"

@interface NewPasswordVC ()<UITextFieldDelegate>
{
    UIImage *image_open;
    UIImage *image_close;
}
//
@property (weak, nonatomic) IBOutlet UIView *containerView;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *textFielda;
//密码
@property (weak, nonatomic) IBOutlet UITextField *textFiledb;

//倒计时label
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIView *spaceView;

//倒计时 button
@property (weak, nonatomic) IBOutlet UIButton *btna;
//切换图片
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//确定
@property (weak, nonatomic) IBOutlet UIButton *btnc;


@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timerScheduledTime;



@end

@implementation NewPasswordVC
-(void)setGoBackBtnStyle{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGoBackBtnStyle];
    image_open=[[UIImage imageNamed:@"pwd_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image_close=[[UIImage imageNamed:@"pwd_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.btna csh_setDefaultCornerRadius];
    [self.btnc csh_setDefaultCornerRadius];
    [self.btnb setImage:image_open forState:UIControlStateNormal];
    
    self.title=@"忘记密码";
    
    self.btnc.backgroundColor=themeCorlor;
    
    self.textFielda.delegate=self;//验证码
    self.textFielda.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.textFiledb.delegate=self;//密码
    self.textFiledb.secureTextEntry=YES;
    self.textFiledb.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    [self timeOut];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.textFielda) {
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
    if (textField==self.textFiledb) {
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
    return YES;
}

-(void)timeOut{
    
    self.btna.hidden=YES;
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timerScheduledTime = [[NSDate new] timeIntervalSince1970];
    [self.timer fire];
}
//60 秒倒计时
- (void)handleTimer:(NSTimer *)timer {
    if (timer.valid) {
        NSTimeInterval fireDateInterval = [[NSDate new] timeIntervalSince1970] - self.timerScheduledTime;
        NSInteger remainingInterval = round(59 - fireDateInterval);
        
        if (remainingInterval > 0) {
            self.timeLab.hidden=NO;
            self.timeLab.text = [NSString stringWithFormat:@"%@秒", @(remainingInterval)];
        } else {
            [self.timer invalidate];
            self.timer = nil;
            
            self.timeLab.hidden=YES;
            
            self.btna.hidden=NO;
            self.btna.backgroundColor=themeCorlor;
            
//            [self.btna csh_enableWithLoginAppearance];
//            self.countingLabel.hidden = YES;
        }
    } else {
        
        self.btna.hidden=NO;
        self.btna.backgroundColor=themeCorlor;
        
//        self.btna.hidden=NO;
//        [self.captchaButton csh_enableWithLoginAppearance];
    }
    
    // send message
}
//倒计时 button
- (IBAction)btnaClicked:(UIButton *)sender {
   
    [self getCode];
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)getCode{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *phoneNumStr=[defaults objectForKey:@"resetPhoneNumber"];
    //短信验证
    //type=1 注册 没注册成功可以一直发
    //type=2 找回密码 的发送短信的接口  注册成功之后可以一直发
    NSString *api=@"/oauth/send-otp-code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"type":@"2",@"phone":phoneNumStr};
    
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
            [self timeOut];
            
        }else{
            [MBProgressHUD showError:@"短信发送失败！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [MBProgressHUD showError:@"网络请求错误！"];
    }];
}
//切换图片

- (IBAction)btnbClicked:(UIButton *)sender {
    if (self.btnb.selected==YES) {
        [self.btnb setImage:image_close forState:UIControlStateNormal];
        self.textFiledb.secureTextEntry=NO;
    }else{
        [self.btnb setImage:image_open forState:UIControlStateNormal];
        self.textFiledb.secureTextEntry=YES;
    }
    self.btnb.selected=!self.btnb.selected;
    
}
//确定
- (IBAction)btncClicked:(UIButton *)sender {
    NSLog(@"c");
    if ((self.textFiledb.text.length<6)||(self.textFiledb.text.length>16)) {
        [MBProgressHUD showError:@"密码格式错误"];
        return;
    }
    
     [self forgetSecret];
}
-(void)forgetSecret{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *resetPhoneNumber=[defaults objectForKey:@"resetPhoneNumber"];
    
    NSString *api=@"/api/user/forget";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"phone":resetPhoneNumber,@"password":self.textFiledb.text,@"code":self.textFielda.text,@"type":@"2"};
    
    NSLog(@"para:%@",para);
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //发送请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"response:%@",responseObject);
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",responseObject[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"修改成功"];
            
            [self goToLogin];
            
            
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *statusCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        if ([statusCode isEqualToString:@"422"]) {
            [MBProgressHUD showError:@"验证码无效！"];
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
