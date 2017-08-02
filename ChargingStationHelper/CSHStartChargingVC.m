//
//  CSHStartChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/6.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHStartChargingVC.h"
#import "CSHChargingRuleVC.h"
#import "CSHOnChargingVC.h"

#import "CSHLoginViewController.h"
#import "CSHPayMoneyVC.h"
#import "CSHUserLocation.h"
#import "PriceModel.h"
@interface CSHStartChargingVC ()
{
    NSString *userMoney;
}
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *btna;
//计费规则按钮
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//开启电桩
@property (weak, nonatomic) IBOutlet UIButton *btnc;

//充电站
@property (weak, nonatomic) IBOutlet UILabel *laba;
//充电桩
@property (weak, nonatomic) IBOutlet UILabel *labb;


//交流电桩
@property (weak, nonatomic) IBOutlet UILabel *labc;
//最大功率
@property (weak, nonatomic) IBOutlet UILabel *labd;
//输出电流
@property (weak, nonatomic) IBOutlet UILabel *labe;
//余额
@property (weak, nonatomic) IBOutlet UILabel *labf;


//开启电桩的小背景图
@property (weak, nonatomic) IBOutlet UIImageView *animationImageV;

@property(strong,nonatomic)NSString *stationlatitude;
@property(strong,nonatomic)NSString *stationlongitude;

//电价列表的数据源
@property(strong,nonatomic)NSMutableArray *dataArray;


@end

@implementation CSHStartChargingVC

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
    [self.navigationController setNavigationBarHidden:YES];
    
    [self getUserInfomation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(root) name:@"root" object:nil];
}
-(void)root{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootOne" object:nil];
}
//这里只要money
-(void)getUserInfomation{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //获取用户基本信息
        userMoney=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
        
        //self.labf.text=[NSString stringWithFormat:@"￥%@",userMoney];
        NSString *moneyStr=[NSString stringWithFormat:@"我的余额：%@元",userMoney];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        //2 attrStr添加文字颜色
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, 5)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(attrStr.length-1, 1)];
        
        self.labf.attributedText=attrStr;
        
        //后面评价的时候需要传入 accountId
        NSString *accountId=[NSString stringWithFormat:@"%@",responseObject[@"id"]];
        
        [defaults setObject:accountId forKey:@"accountId"];
        [defaults synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
    }];
}


-(void)setGoBackBtnStyle{
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
    
    //正向传值
    self.labc.text=self.cif;
    self.labd.text=self.power;
    self.labe.text=self.voltage;
    
    [self setGoBackBtnStyle];
    //2.7
    [self getOneChargerByCodeWithChargerNO:self.chargerCode];
   // [self getOneChargerByCodeWithChargerNO:self.chargerNO];
    
    self.btnc.layer.cornerRadius=50;
    self.btnc.layer.masksToBounds=YES;
    
    //设置波纹动画
    [self setAnimationFunction];
    
}
-(void)setAnimationFunction{
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(nextAnimation) userInfo:nil repeats:YES];
    
}
-(void)nextAnimation{
    //圆形变圆弧
    CAShapeLayer * clickCicrleLayer = [CAShapeLayer layer];
    
    clickCicrleLayer.frame = CGRectMake(75, 75, 50,50);
    
    clickCicrleLayer.fillColor = [UIColor colorWithRed:0.5 green:0.51 blue:0.9 alpha:1].CGColor;
    //    clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.lineWidth = 2;
    clickCicrleLayer.path=[self drawclickCircleBezierPath:1].CGPath;
    [self.animationImageV.layer addSublayer:clickCicrleLayer];
    
    //圆弧变大
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 3.0;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(100)].CGPath);
    //    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:([UIScreen mainScreen].bounds.size.width)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    
    //变透明
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.toValue = @0;
    basicAnimation1.beginTime = 0.00;
    basicAnimation1.duration = 3.0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    animationGroup.repeatCount=0;
    //    animationGroup.repeatCount=MAXFLOAT;
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [clickCicrleLayer addAnimation:animationGroup forKey:nil];
}
-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    /**
     *  center: 弧线中心点的坐标
     radius: 弧线所在圆的半径
     startAngle: 弧线开始的角度值
     endAngle: 弧线结束的角度值
     clockwise: 是否顺时针画弧线
     *
     */
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return bezierPath;
}
-(void)getOneChargerByCodeWithChargerNO:(NSString *)chargerNO{
    
    //NSString *api=[NSString stringWithFormat:@"/api/chargers/%@",chargerNO];
    NSString *api=@"/api/chargers/code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"code":self.chargerCode};
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject!=nil) {
            
            NSDictionary *stationDic=responseObject[@"station"];
            
            self.stationId=stationDic[@"id"];
            
            self.laba.text=stationDic[@"name"];
            self.labb.text=responseObject[@"code"];
            /*
            NSString *chargeIf=[NSString stringWithFormat:@"%@",responseObject[@"chargeIf"]];
            if ([chargeIf isEqualToString:@"DC"]) {
                self.labc.text=@"快充";
            }else if ([chargeIf isEqualToString:@"DC"]){
                self.labc.text=@"慢充";
            }
            
//            self.labc.text=responseObject[@"chargeIf"];
            self.labd.text=[NSString stringWithFormat:@"功率：%@",responseObject[@"power"]];
            self.labe.text=[NSString stringWithFormat:@"电流：%@",responseObject[@"electricity"]];
             */
            
            self.stationlatitude=[NSString stringWithFormat:@"%@",responseObject[@"station"][@"latitude"]];
            self.stationlongitude=[NSString stringWithFormat:@"%@",responseObject[@"station"][@"longitude"]];
        
            //电价模块
            NSArray *priceTemplate=responseObject[@"priceTemplate"];
            if (priceTemplate.count>0)
            {
                    for (NSDictionary *tempDic in priceTemplate)
                    {
                        PriceModel *model=[[PriceModel alloc]init];
                        model.startAt=tempDic[@"startAt"];
                        model.endAt=tempDic[@"endAt"];
                        model.fee=tempDic[@"fee"];
                        model.price=tempDic[@"price"];
                        
                        [self.dataArray addObject:model];
                    }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//返回
- (IBAction)btnaClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goBackBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 点击 计费规则 按钮
- (IBAction)btnbClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHChargingRuleVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingRuleVC class])];
    vc.dataArray=self.dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 点击 开启电桩 按钮
- (IBAction)btncClicked:(UIButton *)sender {
  
    
    CSHUserLocation *single=[CSHUserLocation shareSingleton];
    CLLocation *userLocation= single.location;
    
    CLLocationDistance distance = [userLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:[self.stationlatitude doubleValue] longitude:[self.stationlongitude doubleValue]]];
    
#warning 实际上线的时候改成500 和 100
    if (distance>500000000) {
        [MBProgressHUD showError:@"您距离站点较远！"];
        return;
    }else if (distance<100000000){
        
        NSString *message=[NSString stringWithFormat:@"你当前位置距离站点%.2lf米,是否确定充电？",distance];
        //1,
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
       
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            return ;
        }];
        UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
            [self startCharging];
        }];
        [alertController addAction:defaultActiona];
        [alertController addAction:defaultActionb];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
    }
    
    NSString *distanceToUser = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];
    
    NSString *message=[NSString stringWithFormat:@"当前距离：%@",distanceToUser];
    
    NSLog(@"%@",message);
    
}
#pragma mark --- 跳转到充电界面
-(void)startCharging{
    //1，判断距离
    
    //2，判断登录
    [self isLoginOrNot];
    
    //3，判断余额
    [self isMoneyOrNot];
    
    //4，判断插枪
    [self isInsertOrNot];
    
    //因为4有延时，所以在4里面请求成功之后写5
    
    //5,发起充电请求
}
//1，判断登录
-(void)isLoginOrNot{
    if ([NSUserDefaults csh_isLogin]==NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要登录才可以进行此操作" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"a");
        }];
        UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self showLoginViewController];
        }];
        [alertController addAction:defaultActiona];
        [alertController addAction:defaultActionb];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
        
        return;
    }
}
//2，判断余额
-(void)isMoneyOrNot{
    
    if (!(userMoney.floatValue>0)) {//如果小于0
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的余额不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"a");
        }];
        UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self pushToMoneyVC];
            
        }];
        [alertController addAction:defaultActiona];
        [alertController addAction:defaultActionb];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
        
        return;
    }
}

//3，判断插枪
-(void)isInsertOrNot{
    
    NSString *api=@"/api/charging/connector/status";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerCode,
                         @"chargerConn":self.chargerConn};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else if ([state isEqualToString:@"1"]){//插枪成功-发起充电请求
            
            [self sendChargingRequest];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
   
}
-(void)sendChargingRequest{
    NSString *api=@"/api/charging/auth";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerCode,
                         @"chargerConn":self.chargerConn};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else if ([state isEqualToString:@"1"]){//发起充电请求-开启电桩
            
            NSString *orderId=[NSString stringWithFormat:@"%@",responseObject[@"orderId"]];
            
            
            [self startChargerWithOrderId:orderId];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];
}
-(void)startChargerWithOrderId:(NSString *)orderId{
    NSString *api=@"/api/charging/start";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerCode,
                         @"chargerConn":self.chargerConn,
                         @"orderId":orderId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else if ([state isEqualToString:@"1"]){//开启电桩-push充电中
            
            [self pushToChargingVCWithOrderId:orderId];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];

}
#pragma mark --- push到充电界面
//4，跳转到充电界面
-(void)pushToChargingVCWithOrderId:(NSString *)orderId{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHOnChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHOnChargingVC class])];
    
    vc.chargerNO=self.chargerCode;
    vc.stationId=self.stationId;
    vc.orderId=orderId;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.chargerCode forKey:@"chargerNO"];
    [defaults setObject:self.stationId forKey:@"stationId"];
    [defaults setObject:orderId forKey:@"orderId"];
    [defaults synchronize];
    
    [self presentViewController:vc animated:YES completion:nil];
    
   // [self.navigationController pushViewController:vc animated:YES];
}

//跳到登录界面
- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}
//跳到充值界面
-(void)pushToMoneyVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    CSHPayMoneyVC *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHPayMoneyVC class])];
    [self.navigationController pushViewController:paymentViewController animated:YES];
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
