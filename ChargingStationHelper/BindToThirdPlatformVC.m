//
//  BindToThirdPlatformVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "BindToThirdPlatformVC.h"
#import "UMSocialUIManager.h"
@interface BindToThirdPlatformVC ()
//微信
@property (weak, nonatomic) IBOutlet UILabel *laba;
//微博
@property (weak, nonatomic) IBOutlet UILabel *labb;
//QQ
@property (weak, nonatomic) IBOutlet UILabel *labc;

//
@property (weak, nonatomic) IBOutlet UISwitch *switcha;
@property (weak, nonatomic) IBOutlet UISwitch *switchb;
@property (weak, nonatomic) IBOutlet UISwitch *switchc;




@end

@implementation BindToThirdPlatformVC
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
    self.title=@"绑定第三方账号";
    
    self.switcha.userInteractionEnabled=NO;
    self.switchb.userInteractionEnabled=NO;
    self.switchc.userInteractionEnabled=NO;
    
    [self setGoBackBtnStyle];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkIfBindInside];
}
-(void)checkIfBindInside{
    NSString *api=@"/api/account/checkBind";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tempArray=responseObject;
        if (tempArray.count>0) {
            for ( NSDictionary *tempDic in tempArray) {
                NSString *provider=tempDic[@"provider"];
                /*
                QQ”/”WECHAT”/”WEIBO”
                 */
                if ([provider isEqualToString:@"WECHAT"]) {
                    [self.switcha setOn:YES animated:YES];
                    self.laba.text=@"已绑定";
                    self.laba.textColor=[UIColor blackColor];
                }else if ([provider isEqualToString:@"WEIBO"]){
                    [self.switchb setOn:YES animated:YES];
                    self.labb.text=@"已绑定";
                    self.labb.textColor=[UIColor blackColor];
                }else if ([provider isEqualToString:@"QQ"]){
                    [self.switchc setOn:YES animated:YES];
                    self.labc.text=@"已绑定";
                    self.labc.textColor=[UIColor blackColor];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark --- 微信
- (IBAction)btna:(UIButton *)sender {
    
    if ([self.laba.text isEqualToString:@"已绑定"]) {//如果是绑定 解绑
        [self deletaBindInsideWithProvider:@"WECHAT"];
    }else{//如果未绑定 绑定
        [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            
            UMSocialAuthResponse *authresponse=result;
            
            NSLog(@"QQQ-accessToken:%@\nexpiration:%@\nrefreshToken:%@\nuid:%@\nopenid:%@\nplatformType:%ld\noriginalResponse:%@\noriginalUserProfile:%@",authresponse.accessToken,authresponse.expiration,authresponse.refreshToken,authresponse.uid,authresponse.openid,authresponse.platformType,authresponse.originalResponse,authresponse.originalUserProfile);
            
            if (authresponse.uid!=nil) {//如果用户授权登录的话
//                [self bindWithProvider:@"WECHAT" andUid:authresponse.uid];
                [self bindWithProvider:@"WECHAT" andUid:authresponse.uid andOpenid:authresponse.openid andAccessToken:authresponse.accessToken];
            }
            
        }];
        
    }
}
-(void)deletaBindInsideWithProvider:(NSString *)provider{
    NSString *api=@"/api/account/deleteBind";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"provider":provider};
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self deleteWithOperation:operation andProvider:provider];
        
    }];
}
-(void)deleteWithOperation:(AFHTTPRequestOperation *)operation andProvider:(NSString *)provider{
    
    NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
    if ([responseString isEqualToString:@"success"]) {
        
        if ([provider isEqualToString:@"WECHAT"]) {
            [self.switcha setOn:NO animated:YES];
            self.laba.text=@"未绑定";
            self.laba.textColor=[UIColor lightGrayColor];
        }else if ([provider isEqualToString:@"WEIBO"]){
            [self.switchb setOn:NO animated:YES];
            self.labb.text=@"未绑定";
            self.labb.textColor=[UIColor lightGrayColor];
        }else if ([provider isEqualToString:@"QQ"]){
            [self.switchc setOn:NO animated:YES];
            self.labc.text=@"未绑定";
            self.labc.textColor=[UIColor lightGrayColor];
        }
    }
    
}
-(void)bindWithProvider:(NSString *)provider andUid:(NSString *)uid andOpenid:(NSString *)openid andAccessToken:(NSString *)accessToken{
    NSString *api=@"/api/account/addBind";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    
    NSDictionary *para=@{
                         @"provider":provider,
                         @"uid":uid,
                         @"openid":openid,
                         @"token":accessToken,
                         @"appid":@"1105652555"};
    
//    NSDictionary *para=@{@"provider":provider,
//                         @"uid":uid,
//                         @"":};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self bindWithOperation:operation andWithProvider:provider];
        
        NSLog(@"%@",error);
    }];
}
-(void)bindWithOperation:(AFHTTPRequestOperation *)operation andWithProvider:(NSString *)provider{
    NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
    if ([responseString isEqualToString:@"success"]) {
        
        if ([provider isEqualToString:@"WECHAT"]) {
            [self.switcha setOn:YES animated:YES];
            self.laba.text=@"已绑定";
            self.laba.textColor=[UIColor blackColor];
        }else if ([provider isEqualToString:@"WEIBO"]){
            [self.switchb setOn:YES animated:YES];
            self.labb.text=@"已绑定";
            self.labb.textColor=[UIColor blackColor];
        }else if ([provider isEqualToString:@"QQ"]){
            [self.switchc setOn:YES animated:YES];
            self.labc.text=@"已绑定";
            self.labc.textColor=[UIColor blackColor];
        }
    }
}
#pragma mark --- 微博
- (IBAction)btnb:(UIButton *)sender {
    [MBProgressHUD showError:@"功能暂未开放"];
}
#pragma mark --- QQ
- (IBAction)btnc:(UIButton *)sender {
    if ([self.labc.text isEqualToString:@"已绑定"]) {//如果是绑定 解绑
        [self deletaBindInsideWithProvider:@"QQ"];
    }else{//如果未绑定 绑定
        [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
            
            UMSocialAuthResponse *authresponse=result;
            
            NSLog(@"QQQ-accessToken:%@\nexpiration:%@\nrefreshToken:%@\nuid:%@\nopenid:%@\nplatformType:%ld\noriginalResponse:%@\noriginalUserProfile:%@",authresponse.accessToken,authresponse.expiration,authresponse.refreshToken,authresponse.uid,authresponse.openid,authresponse.platformType,authresponse.originalResponse,authresponse.originalUserProfile);
            
            
            if (authresponse.uid!=nil) {//如果用户授权登录的话
//                [self bindWithProvider:@"QQ" andUid:authresponse.uid];
                [self bindWithProvider:@"QQ" andUid:authresponse.uid andOpenid:authresponse.openid andAccessToken:authresponse.accessToken];
            }
            
        }];
        
    }

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
