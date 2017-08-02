//
//  CSHOnChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/6.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHOnChargingVC.h"
#import "CSHEndChargingVC.h"
@interface CSHOnChargingVC ()


@property (weak, nonatomic) IBOutlet UILabel *labA;
@property (weak, nonatomic) IBOutlet UILabel *labB;
@property (weak, nonatomic) IBOutlet UILabel *labC;





@property (weak, nonatomic) IBOutlet UILabel *laba;


//已充电时间
//h
@property (weak, nonatomic) IBOutlet UILabel *labb;
//m
@property (weak, nonatomic) IBOutlet UILabel *labc;
//剩余充电时间
//h
@property (weak, nonatomic) IBOutlet UILabel *labd;
//m
@property (weak, nonatomic) IBOutlet UILabel *labe;


@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

//结束充电按钮
@property (weak, nonatomic) IBOutlet UIButton *endChargingBtn;



@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timerScheduledTime;
@end

@implementation CSHOnChargingVC
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.endChargingBtn.radius=50;
    
    //还需要做个定时器 自己刷新
    [self getChargingProgress];
    
    self.timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.timerScheduledTime = [[NSDate new] timeIntervalSince1970];
    [self.timer fire];
    
}
-(void)endChargingBtnClicked{
    NSString *api=@"/api/charging/stop";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerNO,
                         @"chargerConn":@"10",
                         @"orderId":self.orderId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:TOKEN];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else if ([state isEqualToString:@"1"]){//结束充电-push查询充电结果
            [self PushToEndVCWithOrderId:self.orderId];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation.responseString);
        NSLog(@"error：%@",error);
        
    }];
}
-(void)goMianBtnClicked{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootOne" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setWarningOpen" object:nil];
}
- (void)handleTimer:(NSTimer *)timer {
    if (timer.valid) {
        [self getChargingProgress];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark --- 检测充电进度
-(void)getChargingProgress{
    
    NSString *api=@"/api/charging/progress";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerNO,
                         @"chargerConn":@"10",
                         @"orderId":self.orderId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:TOKEN];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.labA.text=responseObject[@"electric"];
        self.labB.text=responseObject[@"chargeTime"];
        self.labC.text=responseObject[@"remainedTime"];
        NSLog(@"remainedTime:%@",responseObject[@"remainedTime"]);
        
        NSString *status=[NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"true"]) {
            [self PushToEndVCWithOrderId:self.orderId];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(root2) name:@"root2" object:nil];
}
-(void)root2{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"root" object:nil];
}
#pragma mark --- 点击左上角 返回按钮
- (IBAction)goBackBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"root" object:nil];
    
}
#pragma mark ---点击 结束充电 按钮 1 发送请求  跳转页面
- (IBAction)endChargingBtn:(UIButton *)sender {
    
    NSString *api=@"/api/charging/stop";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerNO,
                         @"chargerConn":@"10",
                         @"orderId":self.orderId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:TOKEN];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else if ([state isEqualToString:@"1"]){//结束充电-push查询充电结果
            [self PushToEndVCWithOrderId:self.orderId];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];
}
#pragma mark ---点击 结束充电 按钮 2
-(void)PushToEndVCWithOrderId:(NSString *)orderId{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHEndChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHEndChargingVC class])];
    vc.orderId=orderId;
    vc.chargerNO=self.chargerNO;
    vc.stationId=self.stationId;
    
    [self presentViewController:vc animated:YES completion:nil];
    //点击 开启充电的时候存起来 点击结束充电的时候remove
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"chargerNO"];
    [defaults removeObjectForKey:@"stationId"];
    [defaults removeObjectForKey:@"orderId"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
