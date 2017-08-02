//
//  CSHChangePWDTableVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/8/23.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//



#import "CSHChangePWDTableVC.h"

@interface CSHChangePWDTableVC ()<UITextFieldDelegate>
{
    UIImage *image_open;
    UIImage *image_close;
}
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *myPersonnelPassWord;

@property (weak, nonatomic) IBOutlet UIButton *oldPassWordBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPersonnelPassBtn;


@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation CSHChangePWDTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    image_open=[[UIImage imageNamed:@"pwd_open"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image_close=[[UIImage imageNamed:@"pwd_close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.saveBtn.backgroundColor=themeCorlor;
    
    self.oldPassWordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.oldPassWordTF.delegate=self;
    
    self.myPersonnelPassWord.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.myPersonnelPassWord.delegate=self;
    
    
    [self.myPersonnelPassBtn setImage:image_open forState:UIControlStateNormal];
    [self.oldPassWordBtn setImage:image_open forState:UIControlStateNormal];
    
    self.oldPassWordTF.secureTextEntry=YES;
    self.myPersonnelPassWord.secureTextEntry=YES;
    
    self.title=@"修改密码";
}
#pragma mark --- textField的代理函数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField==self.oldPassWordTF) {
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
    
    if (textField==self.myPersonnelPassWord) {
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
//保存按钮
- (IBAction)saveBtnClicked:(UIButton *)sender {
    if ([self.oldPassWordTF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"原密码不能为空"];
        return;
    }
    if ([self.myPersonnelPassWord.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"新密码不能为空"];
        return;
    }
    
    if ((self.oldPassWordTF.text.length>16)||(self.oldPassWordTF.text.length<6)) {
        [MBProgressHUD showError:@"原码格式错误！"];
        return;
    }
    if ((self.myPersonnelPassWord.text.length>16)||(self.myPersonnelPassWord.text.length<6)) {
        [MBProgressHUD showError:@"新码格式错误！"];
        return;
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *api=@"/api/account/updatePassword";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"oldpass":self.oldPassWordTF.text,@"newpass":self.myPersonnelPassWord.text,@"confirmpass":self.myPersonnelPassWord.text};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    
    [_operation PUT:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"response:%@",responseObject);
        
        NSString *httpErrorCode=[NSString stringWithFormat:@"%@",responseObject[@"httpErrorCode"]];
        if ([httpErrorCode isEqualToString:@"200"]) {
            NSLog(@"修改成功");
            [MBProgressHUD showError:@"修改成功"];
        }else{
            NSLog(@"修改失败");
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [MBProgressHUD showError:@"修改失败"];
    }];
   
    
    
}
//
//old
- (IBAction)oldPassWordBtnClicked:(UIButton *)sender {
    
    if (sender.selected==YES) {
        [self.oldPassWordBtn setImage:image_close forState:UIControlStateNormal];
        self.oldPassWordTF.secureTextEntry=NO;
    }else{
        
        [self.oldPassWordBtn setImage: image_open forState:UIControlStateNormal];
        
        self.oldPassWordTF.secureTextEntry=YES;
    }
    sender.selected=!sender.selected;
    
}
//new
- (IBAction)myPersonnelPassBtnClicked:(UIButton *)sender {
    if (sender.selected==YES) {
        [self.myPersonnelPassBtn setImage:image_close forState:UIControlStateNormal];
        
        self.myPersonnelPassWord.secureTextEntry=NO;
    }else{
        [self.myPersonnelPassBtn setImage: image_open forState:UIControlStateNormal];
        self.myPersonnelPassWord.secureTextEntry=YES;
    }
    sender.selected=!sender.selected;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 10;
    }else{
        return 100;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

@end
