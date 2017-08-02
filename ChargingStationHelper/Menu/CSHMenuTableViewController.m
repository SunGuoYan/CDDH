//
//  CSHMenuTableViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//
#import "UITabBar+badge.h"
#import "UIImageView+WebCache.h"
// 这里的UITableVC 直接与sb关联
#import "CSHMenuTableViewController.h"
#import "CSHLoginViewController.h"
#import "CSHLoginAndSignupViewController.h"
#import "NSUserDefaults+UserConfig.h"
#import "CSHPreferenceTableViewController.h"
#import "CSHBalanceViewController.h"
#import "CSHDriverCertificatingViewController.h"
#import "CSHSettingsViewController.h"
#import "CSHMyCollectionViewController.h"
#import "CSHMessageCenterViewController.h"
#import "CSHChargingHistoryViewController.h"
#import "CSHBookingHistoryViewController.h"
#import "CSHRecommendationViewController.h"

#import "CSHPersonnelTableVC.h"
#import "GuidelineVC.h"

#import "CSHChargingStationVC.h"
#import "BindToTelephoneVC.h"   //测试


@interface CSHMenuTableViewController ()

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
//用户手机号码
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLab;

//完善资料 icon
@property (weak, nonatomic) IBOutlet UIImageView *improveInfoIcon;

//登录/注册 label
@property (weak, nonatomic) IBOutlet UILabel *loginAndRegister;


//车主认证 label
@property (weak, nonatomic) IBOutlet UILabel *driverCertificate;

//消息中心 icon  my-message-iconH
@property (weak, nonatomic) IBOutlet UIImageView *messageCenterIcon;


//正向传值
@property(nonatomic,copy)NSString *driverId;

@property(nonatomic,copy)NSString *carBrand;
@property(nonatomic,copy)NSString *carType;
@property(nonatomic,copy)NSString *frameNumber;
@property(nonatomic,copy)NSString *engineNumber;
@property(nonatomic,copy)NSString *drivingLicensePhoto;
@property(nonatomic,copy)NSString *plateNumber;
//btn
@property(nonatomic,copy)NSString *carIdentifyStatus;

//小红点
@property (weak, nonatomic) IBOutlet UIView *redPoint;

@end

@implementation CSHMenuTableViewController
-(void)notificationRead{
    NSString *api=@"/api/getnotify/get";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
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
        NSLog(@"%@",operation.responseString);
        /*
         true 1 没有未读消息
         */
        NSString *flag=[NSString stringWithFormat:@"%@",responseObject[@"flag"]];
        if ([flag isEqualToString:@"1"]) {
            self.redPoint.hidden=YES;
        }else{
            self.redPoint.hidden=NO;
        }
        /*
         false 0  有未读消息
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self notificationRead] ;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"accountId"]!=nil) {
        //如果登陆
        self.loginAndRegister.hidden=YES;
        
        self.userNameLab.hidden=NO;
        self.userPhoneNumberLab.hidden=NO;
        self.improveInfoIcon.hidden=NO;
    }else{
        //未登陆状态
        self.loginAndRegister.hidden=NO;
        
        self.userNameLab.hidden=YES;
        self.userPhoneNumberLab.hidden=YES;
        self.improveInfoIcon.hidden=YES;
    }
    if ([defaults objectForKey:@"access_token"]!=nil) {//登陆状态
        [self getUserInfomation];
        [self checkDriver];
        
    }else if ([defaults objectForKey:@"access_token"]==nil){//退出状态
        self.userIcon.image=[UIImage imageNamed:@"cddh"];
        self.driverCertificate.text=@"";
    }
}

-(void)getUserInfomation{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *personNickName=[NSString stringWithFormat:@"%@",responseObject[@"nickname"]];
        NSString *personAvatar=[NSString stringWithFormat:@"%@",responseObject[@"avatar"]];

        //数据类型
        NSNumber *personPhone=responseObject[@"phone"];
        self.userPhoneNumberLab.text=[NSString stringWithFormat:@"%@",personPhone];
        if ([personNickName isEqualToString:@"<null>"]) {
            self.userNameLab.text=@"";
        }else{
            self.userNameLab.text=[NSString stringWithFormat:@"%@",personNickName];
        }
        
        
        if (![personAvatar isEqualToString:@"<null>"]) {
            UIImage *image=[UIImage imageNamed:@"cddh"];
            [self.userIcon sd_setImageWithURL:[NSURL URLWithString:personAvatar] placeholderImage:image];
        }else{
            self.userIcon.image=[UIImage imageNamed:@"cddh"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        NSData *jsonData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSString *message=dic[@"error"];
        
        if ([message isEqualToString:@"invalid_token"]) {
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"access_token"];//作为退出的标志
            [defaults removeObjectForKey:@"accountId"];
            [defaults removeObjectForKey:@"userPhone"];
            [defaults removeObjectForKey:@"userName"];
            [defaults removeObjectForKey:@"userImage"];
            [defaults synchronize];
    
            //1,
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号已过期，请重新登录" preferredStyle:UIAlertControllerStyleAlert];

            //2
            UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"a");
            }];
            UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self showLoginViewController];
                
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:defaultActiona];
            [alertController addAction:defaultActionb];
            
            //3
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:alertController animated: YES completion: nil];
        }
        /*
         (lldb) po operation.response.statusCode
         401
         (lldb) po operation.responseString
         {"error":"invalid_token","error_description":"Cannot convert access token to JSON"}
         */
    }];
}

#pragma mark ---未认证
-(void)checkDriver{
    NSString *api=@"/api/carIdentify/car";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject[@"msg"]!=nil) {
            self.driverCertificate.text=responseObject[@"msg"];
            return ;
        }
        
        self.driverId=responseObject[@"id"];
        
        NSString *carIdentifyStatus=[NSString stringWithFormat:@"%@",responseObject[@"status"]];
        self.driverCertificate.text=carIdentifyStatus;
        
        self.carBrand=[NSString stringWithFormat:@"%@",responseObject[@"carBrand"]];
        self.carType=[NSString stringWithFormat:@"%@",responseObject[@"carType"]];
        
        self.frameNumber=[NSString stringWithFormat:@"%@",responseObject[@"frameNumber"]];
        self.engineNumber=[NSString stringWithFormat:@"%@",responseObject[@"engineNumber"]];
        self.drivingLicensePhoto=[NSString stringWithFormat:@"%@",responseObject[@"drivingLicensePhoto"]];
        self.plateNumber=[NSString stringWithFormat:@"%@",responseObject[@"plateNumber"]];
        self.carIdentifyStatus=[NSString stringWithFormat:@"%@",responseObject[@"status"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置item的小红点 1
//    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    //设置消息中心的小红点 2
    self.redPoint.layer.cornerRadius=4;
    self.redPoint.layer.masksToBounds=YES;
    self.redPoint.hidden=YES;
    
    self.navigationItem.title = @"个人中心";

    [self.loginAndRegister setTextColor:themeCorlor];
    
//    [self getUserInfomation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 点击右上角 设置图标 跳转到详情页面
- (IBAction)handleSettingsBarButton:(UIBarButtonItem *)sender {
    CSHSettingsViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHSettingsViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --- 消息中心 的点击事件
- (IBAction)btna:(UIButton *)sender {
    if ([NSUserDefaults csh_isLogin]==NO) {
        [self showLoginViewController];
        return;
    }
    CSHMessageCenterViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHMessageCenterViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --- 我的收藏 的点击事件
- (IBAction)btnb:(UIButton *)sender {
    if ([NSUserDefaults csh_isLogin]==NO) {
        [self showLoginViewController];
        return;
    }
    CSHMyCollectionViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHMyCollectionViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --- 充值记录 的点击事件

- (IBAction)btnc:(UIButton *)sender {
    if ([NSUserDefaults csh_isLogin]==NO) {
        [self showLoginViewController];
        return;
    }
    
    CSHChargingHistoryViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingHistoryViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Table view data source & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - cell 的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ？
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击cell  push 到登录界面
    //&& indexPath.row == 1
    if (indexPath.section == 0 || (indexPath.section == 1 )  || indexPath.section == 2||indexPath.section == 3) {
        if ([NSUserDefaults csh_isLogin]==NO) {
            //push 到登录界面
            [self showLoginViewController];
//
            return;
        }
    }
    if (indexPath.section==0) {
        if ([NSUserDefaults csh_isLogin]==YES) {
            [self goToPersonnelInfomation];
        }
    }
    
    //push 我的钱包界面
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        CSHBalanceViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHBalanceViewController class])];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    //push 车主认证
    if (indexPath.section == 2 && indexPath.row == 0) {
        CSHDriverCertificatingViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHDriverCertificatingViewController class])];
        viewController.driverId=self.driverId;
        viewController.carBrand=self.carBrand;
        viewController.carType=self.carType;
        viewController.frameNumber=self.frameNumber;
        viewController.engineNumber=self.engineNumber;
        viewController.drivingLicensePhoto=self.drivingLicensePhoto;
        viewController.plateNumber=self.plateNumber;
        viewController.carIdentifyStatus=self.carIdentifyStatus;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    //push 偏好设置
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        CSHPreferenceTableViewController *perferenceViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHPreferenceTableViewController class])];
        [self.navigationController pushViewController:perferenceViewController animated:YES];
    }
    
    // push 操作指引
    if (indexPath.section==4) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        
        GuidelineVC *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ GuidelineVC class])];
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        backItem.tintColor=[UIColor blackColor];
        self.navigationItem.backBarButtonItem=backItem;
      
        
        [self.navigationController pushViewController:paymentViewController animated:YES];
    }
}




-(void)goToPersonnelInfomation{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personneInfo" bundle:nil];
    CSHPersonnelTableVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHPersonnelTableVC class])];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - push到登录界面
- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    vc.tel=self.userPhoneNumberLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
