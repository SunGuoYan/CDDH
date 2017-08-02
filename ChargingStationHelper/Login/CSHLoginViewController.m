//
//  CSHLoginViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//登录界面 带注册字样

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
//#import "KVNProgress.h"
//#import "commonUtils.h"

#import "CSHLoginViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"
#import "CSHResetPasswordViewController.h"
#import "CSHSignupViewController.h"

//umeng
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"


#import "BindToTelephoneVC.h"

#import "ShareVC.h"

@interface CSHLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) IBOutlet UIImageView *weiXinIcon;
@property (weak, nonatomic) IBOutlet UIImageView *weiBoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *QQIcon;

@property (weak, nonatomic) IBOutlet UILabel *weiXinLab;
@property (weak, nonatomic) IBOutlet UILabel *weiBoLab;

@property (weak, nonatomic) IBOutlet UILabel *QQLab;
@property (weak, nonatomic) IBOutlet UILabel *chooseThirdLoginLab;

@property (weak, nonatomic) IBOutlet UIView *lineA;
@property (weak, nonatomic) IBOutlet UIView *lineB;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageV;


@property(assign,nonatomic)BOOL isWeChatBack;//判断微信是否退出
//

@end

@implementation CSHLoginViewController

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
    
#pragma mark --- 设置返回按钮
    
    [self setGoBackBtnStyle];
    
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.delegate=self;
    
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    NSString *tel=[defaults objectForKey:@"userPhone"];
//    self.phoneTextField.text=self.tel;
    self.phoneTextField.text=self.tel;
    
    self.passwordTextField.secureTextEntry=YES;
    self.passwordTextField.delegate=self;
    
    self.phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearButtonMode=UITextFieldViewModeWhileEditing;

    self.loginButton.backgroundColor=themeCorlor;
    
    [self.inputContainerView csh_setDefaultCornerRadius];
    [self.loginButton csh_setDefaultCornerRadius];
    
    CSHPublicModel *singler=[CSHPublicModel shareSingleton];
    self.loadingImageV.animationImages =singler.imagesArray ;
    self.loadingImageV.animationDuration = 2.0f;
    self.loadingImageV.animationRepeatCount = CGFLOAT_MAX;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
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
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - response to behavior

//判断是否是有效的手机号
- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [phoneTest evaluateWithObject:phoneNumber];
}

#pragma mark ---点击登录  按钮相应的事件
- (IBAction)handleLoginButton:(UIButton *)sender {
    [self login];
}
#pragma mark --- 正常登陆
-(void)login{
    /*
     //登录之后获取用户信息
     */
    
    
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
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
    if (!(self.passwordTextField.text.length>5&&self.passwordTextField.text.length<17)) {
        [MBProgressHUD showError:@"密码格式错误！"];
        return;
    }
    NSString *api=@"/oauth/token";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *device_token=[defaults objectForKey:@"device_token"];
    
    if (device_token==nil) {
        device_token=@"simulator";
    }
    
    NSDictionary *para=@{@"grant_type":@"password",
                         @"phone":self.phoneTextField.text,
                         @"password":self.passwordTextField.text,
                         @"device_token":device_token};
    
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_operation.requestSerializer setValue:@"Basic eW91ZXRvbmctYW5kcm9pZDpzZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        NSLog(@"errorCode:%@",errorCode);
        NSLog(@"statusCode:%ld",operation.response.statusCode);
        
        self.loadingImageV.hidden = YES;
        [self.loadingImageV stopAnimating];
        NSString *token=responseObject[@"access_token"];
        
        if (token!=nil) {
            
            //记录登录状态
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"accountId"];
            [defaults setObject:token forKey:@"access_token"];
            [defaults synchronize];
            
            //登录成功之后获取用户信息
            [self getUserInfomation];
            //这里网络请求延时 先返回 再进请求成功的block
            
//            [NSThread sleepForTimeInterval:1.5];//设置启动页面时间
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:@"手机号或密码错误！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"statusCode:%ld",operation.response.statusCode);
        
        self.loadingImageV.hidden = YES;
        [self.loadingImageV stopAnimating];
        
        NSString *errorCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        NSData *jsonData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *message=dic[@"error_description"];
       
        
        if ([errorCode isEqualToString:@"400"]) {//400 密码错误
            [MBProgressHUD showError:message];
            return ;
        }
        if ([errorCode isEqualToString:@"500"]) {//500 手机号错误
            [MBProgressHUD showError:message];
            return ;
        }
//        NSLog(@"error:%@",error);
        [MBProgressHUD showError:@"网络连接错！"];
        
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
        NSString *nickname=[NSString stringWithFormat:@"%@",responseObject[@"nickname"]];
        NSString *phone=responseObject[@"phone"];
        NSString *imageUrlStr=[NSString stringWithFormat:@"%@",responseObject[@"avatar"]];
        NSString *userMoney=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
        NSString *userid=[NSString stringWithFormat:@"%@",responseObject[@"id"]];
        
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:userid forKey:@"userid"];
        
        if (![nickname isEqualToString:@"<null>"]) {
            
            [defaults setObject:nickname forKey:@"userName"];
        }
        
        [defaults setObject:phone forKey:@"userPhone"];
        
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

#pragma mark ---微信登录
- (IBAction)weixinLogin:(UIButton *)sender {
    
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];
    
   self.isWeChatBack=YES;
    
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialAuthResponse *authresponse=result;
        
        NSLog(@"QQQ-accessToken:%@\nexpiration:%@\nrefreshToken:%@\nuid:%@\nopenid:%@\nplatformType:%ld\noriginalResponse:%@\noriginalUserProfile:%@",authresponse.accessToken,authresponse.expiration,authresponse.refreshToken,authresponse.uid,authresponse.openid,authresponse.platformType,authresponse.originalResponse,authresponse.originalUserProfile);
        
        if (authresponse.uid!=nil) {//如果用户授权登录的话
            self.isWeChatBack=NO;//
//            [self loginWithProvider:@"wechat" andUid:authresponse.uid andOpenid:authresponse.openid];
            [self loginWithProvider:@"wechat" andUid:authresponse.uid andOpenid:authresponse.openid andAccessToken:authresponse.accessToken];
        }else{
            self.loadingImageV.hidden = YES;
            [self.loadingImageV stopAnimating];
        }
    }];
    //这里微信和QQ不一样，QQ退出不授权会进blcok ，但是微信没有进block，
    if (self.isWeChatBack==YES) {
        self.loadingImageV.hidden = YES;
        [self.loadingImageV stopAnimating];
    }

}

//3，分享
-(void)share{
    //显示分享面板
    __weak typeof(self) weakSelf = self;

    [UMSocialUIManager showShareMenuViewInView:nil sharePlatformSelectionBlock:^(UMSocialShareSelectionView *shareSelectionView, NSIndexPath *indexPath, UMSocialPlatformType platformType) {

        
//        [weakSelf shareDataWithPlatform:platformType];
    }];
    
}

-(void)shareDataWithPlatform:(UMSocialPlatformType)platformType{
    UMSocialMessageObject *messageObject=[UMSocialMessageObject messageObject];
    
    NSString *title=@"充电大亨";
    NSString *text=@"这是充电大亨分享的第一条测试分享文本信息！";
    NSString *url =@"https://www.baidu.com";
    UIImage *image=[UIImage imageNamed:@"cddhH"];
    
    
    //0
    messageObject.text=text;
    /*
     一下是设置分享信息的分享体
     */
    
    //1 分享 url
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:@"http://dev.umeng.com/images/tab2_1.png"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareObject setWebpageUrl:url];
    messageObject.shareObject = shareObject;
    
    //2 分享 Image
    UMShareImageObject *shareImageObject=[UMShareImageObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareImageObject setShareImage:image];
//    messageObject.shareObject=shareImageObject;
    
    //3 分享 Video
    UMShareVideoObject *shareVideoObject=[UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareVideoObject setVideoUrl:@"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"];
//    messageObject.shareObject=shareVideoObject;
    
    //4 分享 Music
    UMShareMusicObject *shareMusicObject=[UMShareMusicObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareMusicObject setMusicUrl:@"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3"];
//    messageObject.shareObject=shareMusicObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        if (!error) {
            NSLog(@"success");
        }else{
            NSLog(@"fail");
        }
    }];
    
}



#pragma mark --- 微博登录
- (IBAction)weiBoLogin:(UIButton *)sender {
    
//    [self share];
//    [self shareDataWithPlatform:UMSocialPlatformType_WechatSession];
    [MBProgressHUD showError:@"功能暂未开放"];
    
    
//    ShareVC *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ShareVC class])];
//  
//    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:viewController animated:YES completion:nil];
    
}
#pragma mark ---QQ登录
- (IBAction)QQLogin:(UIButton *)sender {
    
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];

    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialAuthResponse *authresponse=result;
        
        NSLog(@"QQQ-accessToken:%@\nexpiration:%@\nrefreshToken:%@\nuid:%@\nopenid:%@\nplatformType:%ld\noriginalResponse:%@\noriginalUserProfile:%@",authresponse.accessToken,authresponse.expiration,authresponse.refreshToken,authresponse.uid,authresponse.openid,authresponse.platformType,authresponse.originalResponse,authresponse.originalUserProfile);
        
        if (authresponse.uid!=nil) {//如果用户授权登录的话
            [self loginWithProvider:@"qq" andUid:authresponse.uid andOpenid:authresponse.openid andAccessToken:authresponse.accessToken];
        }else{
            self.loadingImageV.hidden = YES;
            [self.loadingImageV stopAnimating];
        }
        
    }];
}

-(void)loginWithProvider:(NSString *)provider andUid:(NSString *)uid andOpenid:(NSString *)openid andAccessToken:(NSString *)accessToken{
    
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *device_token=[defaults objectForKey:@"device_token"];
    
    
    
    NSString *api=@"/oauth/token";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"grant_type":@"social",
                         @"provider":provider,
                         @"uid":uid,
                         @"openid":openid,
                         @"token":accessToken,
                         @"appid":@"1105652555",
                         @"device_token":device_token};
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置请求头二
    [_operation.requestSerializer setValue:@"Basic eW91ZXRvbmctYW5kcm9pZDpzZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.loadingImageV.hidden = YES;
        [self.loadingImageV stopAnimating];
        
        //如果已绑定 返回token
        NSString *token=responseObject[@"access_token"];
        if (token!=nil) {
            //记录登录状态
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"accountId"];
            [defaults setObject:token forKey:@"access_token"];
            [defaults synchronize];
            
            //登录成功之后获取用户信息
            [self getUserInfomation];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSString *error_description=responseObject[@"error_description"];
        //如果未绑定 跳转到绑定界面
        if ([error_description isEqualToString:@"unbind_phone"]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            BindToTelephoneVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ BindToTelephoneVC class])];
            vc.provider=provider;
            vc.uid=uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /*
     
         //如果response返回这个  这里面的AFN就直接进error  statusCode=400
         error = 501;
         "error_description" = "unbind_phone";
         */
     
        self.loadingImageV.hidden = YES;
        [self.loadingImageV stopAnimating];
        
        NSLog(@"statusCode:%ld",operation.response.statusCode);//400 参数错误   0 网络错误
        NSString *errorCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        NSLog(@"errorCode:%@",errorCode);
        //||[errorCode isEqualToString:@"500"]  ???
        if ([errorCode isEqualToString:@"400"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            BindToTelephoneVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ BindToTelephoneVC class])];
            vc.provider=provider;
            vc.uid=uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        NSLog(@"error:%@",error);
    }];
}

- (IBAction)handleTapOnQQGesture:(UITapGestureRecognizer *)sender {
}

- (IBAction)handleTapOnWeiboGesture:(UITapGestureRecognizer *)sender {
}

- (IBAction)handleTapOnWeChatGesture:(UITapGestureRecognizer *)sender {
}
#pragma mark ---注册按钮  sign up push到注册界面
- (IBAction)handleSignupButton:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CSHSignupViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHSignupViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark ---忘记密码  push到重置密码界面
- (IBAction)handleResetPasswordButton:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CSHResetPasswordViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHResetPasswordViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
