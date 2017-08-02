//
//  ChangePWDVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ChangePWDVC.h"

@interface ChangePWDVC ()<UITextFieldDelegate>

//原密码
@property (weak, nonatomic) IBOutlet UITextField *textFielda;
//新密码（1）
@property (weak, nonatomic) IBOutlet UITextField *textFieldb;
//新密码（2）
@property (weak, nonatomic) IBOutlet UITextField *textFieldc;



//原密码 btn
@property (weak, nonatomic) IBOutlet UIButton *btna;
//新密码 btn（1）
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//新密码 btn（2）
@property (weak, nonatomic) IBOutlet UIButton *btnAgain;



//保存
@property (weak, nonatomic) IBOutlet UIButton *btnc;


//
@end

@implementation ChangePWDVC
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoBackBtnStyle];
    
    image_open=[[UIImage imageNamed:@"pwd_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image_close=[[UIImage imageNamed:@"pwd_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.textFielda.secureTextEntry=YES;
    self.textFielda.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFielda.delegate=self;
    
    self.textFieldb.secureTextEntry=YES;
    self.textFieldb.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFieldb.delegate=self;
    
    self.textFieldc.secureTextEntry=YES;
    self.textFieldc.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFieldc.delegate=self;
    
    [self.btna setImage:image_open forState:UIControlStateNormal];
    [self.btnb setImage:image_open forState:UIControlStateNormal];
    [self.btnAgain setImage:image_open forState:UIControlStateNormal];
    
    self.title=@"修改密码";
    
    self.btnc.backgroundColor=[UIColor lightGrayColor];
    self.btnc.userInteractionEnabled=NO;
    
    self.btnc.radius=4;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.btnc.backgroundColor=themeCorlor;
    self.btnc.userInteractionEnabled=YES;
}
#pragma mark --- textField的代理函数
//长度限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==self.textFielda) {
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
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)btna:(UIButton *)sender {
    if (!sender.selected==YES) {
        [self.btna setImage:image_close forState:UIControlStateNormal];
        self.textFielda.secureTextEntry=NO;
    }else{
        
        [self.btna setImage: image_open forState:UIControlStateNormal];
        self.textFielda.secureTextEntry=YES;
    }
    sender.selected=!sender.selected;
}

- (IBAction)btnb:(UIButton *)sender {
    if (!sender.selected==YES) {
        [self.btnb setImage:image_close forState:UIControlStateNormal];
        
        self.textFieldb.secureTextEntry=NO;
    }else{
        [self.btnb setImage: image_open forState:UIControlStateNormal];
        self.textFieldb.secureTextEntry=YES;
    }
    sender.selected=!sender.selected;
}
- (IBAction)btnAgain:(UIButton *)sender {
    if (!sender.selected==YES) {
        [self.btnAgain setImage:image_close forState:UIControlStateNormal];
        self.textFieldc.secureTextEntry=NO;
    }else{
        [self.btnAgain setImage: image_open forState:UIControlStateNormal];
        self.textFieldc.secureTextEntry=YES;
    }
    sender.selected=!sender.selected;
}


//密码需要包含数字、字母、字符两种及两种以上组合
-(BOOL)validatePassword:(NSString *)password
{
    NSString * patt = @"^(?![A-Z]*$)(?![a-z]*$)(?![0-9]*$)(?![^a-zA-Z0-9]*$)\\S+$";
    NSPredicate * predd1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patt];
    BOOL isSuccess = [predd1 evaluateWithObject:password];
    return isSuccess;
}
//保存
- (IBAction)btnc:(UIButton *)sender {
    if ([self.textFielda.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"原密码不能为空"];
        return;
    }
    if ((self.textFielda.text.length>16)||(self.textFielda.text.length<6)) {
        [MBProgressHUD showError:@"原码格式错误！"];
        return;
    }
    if ([self.textFieldb.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"新密码不能为空"];
        return;
    }
    if ((self.textFieldb.text.length>16)||(self.textFieldb.text.length<6)) {
        [MBProgressHUD showError:@"新密码格式错误！"];
        return;
    }
    
    if ([self validatePassword:self.textFieldb.text ]==NO) {
        [MBProgressHUD showError:@"新密码格式错误！"];
        return;
    }
    if (![self.textFieldb.text isEqualToString:self.textFieldc.text]) {
        [MBProgressHUD showError:@"两次密码不一致！"];
        return;
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *api=@"/api/account/updatePassword";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"oldpass":self.textFielda.text,@"newpass":self.textFieldb.text,@"confirmpass":self.textFieldb.text};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    
    [_operation PUT:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%ld",operation.response.statusCode);
        
        //        NSLog(@"response:%@",responseObject);
        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",responseObject[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"200"]) {
          
            [MBProgressHUD showError:@"修改成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        NSLog(@"errorCode:%@",errorCode);
        if ([errorCode isEqualToString:@"422"]) {
            [MBProgressHUD showError:@"原密码错误！"];
            return ;
        }
        // 0 网络错误
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"error:%@",error);
        [MBProgressHUD showError:@"网络连接错误！"];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
