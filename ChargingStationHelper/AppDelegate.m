//
//  AppDelegate.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+CSH.h"

#import <AlipaySDK/AlipaySDK.h>

#import "CSHMapViewController.h"
#import "CSHChargingViewController.h"
#import "CSHTimelineViewController.h"
#import "CSHMenuTableViewController.h"

#import "LeadViewController.h"

#import "SDKExport/WXApi.h"//微信支付

#import <UMSocialCore/UMSocialCore.h>

#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

#import "CSHNavigationController.h"

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>
@property(strong,nonatomic)UITabBarController *tabBarVC;
@end

@implementation AppDelegate


//第三方平台的分享函数
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //支付宝的回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            /*
             resultStatus = 9000  成功
             
             resultStatus = 6001; 失败
             */
            NSString *resultStatus=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([resultStatus isEqualToString:@"9000"]) {
                //发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackToMyBalance" object:nil];
            }
            
            
            
           
        }];
    }
    //test
    BOOL WXResult=[WXApi handleOpenURL:url delegate:self];
    
    if (WXResult ==YES) {
        
    }
    
    
    //Umeng第三方分享
    BOOL result=[[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShareBoard" object:nil];
       }
    return result;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    
//    [UINavigationBar appearance].tintColor = [UIColor csh_brandColor];
//    [UINavigationBar appearance].tintColor = [UIColor lightGrayColor];
    [UINavigationBar appearance].translucent = NO;
    //back-bar-button
    
    //好像没有作用
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back-bar-button"]];
    
//    [UINavigationBar appearance].barTintColor = [UIColor csh_brandColor];
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
   
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    BOOL rect=[user boolForKey:@"isFirst"];
    if (rect==NO) {
//        NSLog(@"第一次启动");
        NSUserDefaults *anotherUser=[NSUserDefaults standardUserDefaults];
        [anotherUser setBool:YES forKey:@"isFirst"];
        [anotherUser synchronize];
        LeadViewController *lvc=[[LeadViewController alloc]init];

        self.window.rootViewController=lvc;
    }else{
        [self pushMainVC];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMainVC) name:@"pushMainVC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootOne) name:@"setRootOne" object:nil];
    
     //wx2acd55b37b3ac821
    
    //微信官方APPID  （微信支付？）
    [WXApi registerApp:@"wx2acd55b37b3ac821" withDescription:@"demo 2.0"];
    
    [self setUM];
    
    [self setPushWith:launchOptions];
    
    return YES;
}
//A
-(void)setPushWith:(NSDictionary *)launchOptions {
    //1
    [UMessage startWithAppkey:@"5819dbeb717c1908880029a1" launchOptions:launchOptions];
    
    //2,注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //3,iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //交互
    
    //4,如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"cddh";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //5,如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    
    //6,如果对角标，文字和声音的取舍，请用下面的方法
    UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    [UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    
    
    //7,打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    
}
//B 获得设备的deviceToken 64位
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device_token=[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken：%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:device_token forKey:@"device_token"];
    [defaults synchronize];
    
    
}
//C，接受通知
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框 这里设置成为NO之后，下面的自定义弹框才会出来
//        [UMessage setAutoAlert:YES];
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    
    //如果app正在运行中 弹个框（屏幕中间） 如果app退出模式 则状态栏上闪现出一下
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        
        NSString *body=userInfo[@"aps"][@"alert"][@"body"];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知" message:body preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [UMessage sendClickReportForRemoteNotification:userInfo];
            NSLog(@"uuuuuu-%@",userInfo);
            /*
             {
             aps =     {
             alert =         {
             body = m;
             subtitle = m;
             title = m;
             };
             sound = default;
             };
             d = us45479147894553011110;
             p = 0;
             }
             
             */
        }];
        [alertController addAction:defaultActiona];
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
        
    }
    
    
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


-(void)setUM{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //充电大亨 5819dbeb717c1908880029a1
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57e49c14e0f55a0cc700062c"];
    
    
    //AppID:    wx8a1c9f51480714b5
    //AppSecret  9bd5e4c6abbb601608657c6a926e41d1
    
    
    //AppID       ： wx2acd55b37b3ac821 优e通（安卓）
    //AppSecret： ca19520173f41b618234b3e184fc2288
    
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2acd55b37b3ac821" appSecret:@"ca19520173f41b618234b3e184fc2288" redirectURL:@"http://mobile.umeng.com/social"];
    
    //APP ID   1105640699 优e通 个
    //APP KEY   Dg0o94XsTxUQcQ0H
    
    //APP ID 1105652555  优e通 公
    //APP KEY LGb5B9ecNfbUm9Bf
    
    
    
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105652555"  appSecret:@"LGb5B9ecNfbUm9Bf" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
}
//设置系统回调 被禁了
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    BOOL result=[[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//
//    }
//    return result;
//}
//设置系统回调
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    BOOL result=[[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        
//    }
//    return result;
//}

//微信支付回调的两个方法 一
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //分享
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    //微信支付
    return  [WXApi handleOpenURL:url delegate:self];
}
//微信支付回调的两个方法 二
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //分享
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    
    //微信支付
    return [WXApi handleOpenURL:url delegate:self];
}
//微信支付完成后的回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                //                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackToMyBalance" object:nil];
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}


-(void)pushMainVC
{
    NSArray *array1=@[@"附近",@"充电",@"活动",@"我的"];
    NSArray *array2=@[@"tabbar_one",@"tabbar_two",@"tabbar_five",@"tabbar_four"];
    NSArray *array3=@[@"tabbar_oneHL",@"tabbar_twoHL",@"tabbar_fiveHL",@"tabbar_fourHL"];
    NSMutableArray *mArr=[[NSMutableArray alloc]init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //1
    CSHMapViewController *vc1=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHMapViewController class])];
    
    UIImage *image11=[[UIImage imageNamed:array2[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image12=[[UIImage imageNamed:array3[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.navigationItem.title=array1[0];
    vc1.tabBarItem=[[UITabBarItem alloc]initWithTitle:array1[0] image:image11 selectedImage:image12];
    
    UINavigationController *nvc1=[[UINavigationController alloc]initWithRootViewController:vc1];
    
    [mArr addObject:nvc1];
    //2
    CSHChargingViewController *vc2=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingViewController class])];
    UIImage *image21=[[UIImage imageNamed:array2[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image22=[[UIImage imageNamed:array3[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.navigationItem.title=array1[1];
    vc2.tabBarItem=[[UITabBarItem alloc]initWithTitle:array1[1] image:image21 selectedImage:image22];
    UINavigationController *nvc2=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    [mArr addObject:nvc2];
    //3
    CSHTimelineViewController *vc3=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHTimelineViewController class])];
    UIImage *image31=[[UIImage imageNamed:array2[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image32=[[UIImage imageNamed:array3[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.navigationItem.title=array1[2];
    vc3.tabBarItem=[[UITabBarItem alloc]initWithTitle:array1[2] image:image31 selectedImage:image32];
    UINavigationController *nvc3=[[UINavigationController alloc]initWithRootViewController:vc3];
    
    [mArr addObject:nvc3];
    //4
    CSHMenuTableViewController *vc4=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHMenuTableViewController class])];
    UIImage *image41=[[UIImage imageNamed:array2[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image42=[[UIImage imageNamed:array3[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc4.navigationItem.title=array1[3];
    vc4.tabBarItem=[[UITabBarItem alloc]initWithTitle:array1[3] image:image41 selectedImage:image42];
    UINavigationController *nvc4=[[UINavigationController alloc]initWithRootViewController:vc4];
    [mArr addObject:nvc4];
    
    
    self.tabBarVC=[[UITabBarController alloc]init];
    self.tabBarVC.tabBar.tintColor=themeRed;
//    self.tabBarVC.tabBar.translucent=YES;
    self.tabBarVC.viewControllers=mArr;
    self.tabBarVC.modalPresentationStyle=UIModalPresentationCustom;
    self.window.rootViewController=self.tabBarVC;
}

-(void)setRootOne{
    self.tabBarVC.selectedIndex=0;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"程序进入后台了");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
