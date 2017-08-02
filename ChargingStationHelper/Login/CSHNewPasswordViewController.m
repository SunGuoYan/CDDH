//
//  CSHNewPasswordViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/6/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//输入新密码
#import "CSHNewPasswordViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface CSHNewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *textFielda;

@property (weak, nonatomic) IBOutlet UITextField *textFieldb;
//再次获取验证码
@property (weak, nonatomic) IBOutlet UIButton *btna;
//
@property (weak, nonatomic) IBOutlet UIButton *btnb;

//倒计时
@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
//



@end

@implementation CSHNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.inputContainerView csh_setDefaultCornerRadius];
    [self.confirmButton csh_setDefaultCornerRadius];
    
    self.confirmButton.backgroundColor=[UIColor colorWithRed:0 green:0.71 blue:0.69 alpha:1];
}

#pragma mark - response to behavior

- (IBAction)handleConfirmButton:(UIButton *)sender {
//    if ([self.passwordTextField.text isEqualToString:@""]) {
//        [MBProgressHUD showError:@"密码不能为空"];
//        return ;
//    }
    
    [self forgetSecret];
    
}
-(void)forgetSecret{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *resetCode=[defaults objectForKey:@"resetCode"];
    NSString *resetPhoneNumber=[defaults objectForKey:@"resetPhoneNumber"];
    
    
    NSString *api=@"/api/user/forget";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];

    NSDictionary *para=@{@"phone":resetPhoneNumber,@"password":self.textFieldb.text,@"code":resetCode,@"type":@"2"};
    
//    NSLog(@"para:%@",para);
    
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
        }else{
           [MBProgressHUD showError:@"修改失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
        [MBProgressHUD showError:@"网络错误"];
    }];
}

@end
