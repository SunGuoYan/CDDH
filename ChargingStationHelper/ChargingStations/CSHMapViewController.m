//
//  CSHMapViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 5/27/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//
#import "DrawCircleProgressButton.h"//启动广告
#import "CSHMapViewController.h"
#import "CSHChargingStationVC.h"
#import <CoreLocation/CoreLocation.h>
#import "ActivityVC.h"

#import <MapKit/MapKit.h>

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#import <Masonry/Masonry.h>
#import "UIView+CornerRadius.h"

#import "CSHChargingStationsViewController.h"
#import "CSHChargingStationViewController.h"
#import "CSHDevice.h"
#import "CSHDeviceAnnotation.h"
#import "CSHDeviceAnnotationView.h"

#import "CSHUserLocation.h"

#import "CSHLoginViewController.h"
#import "ServiceCenterVC.h"

#import "ShareVC.h"

#import "CSHOnChargingVC.h"
@interface CSHMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, CSHChargingStationsViewControllerDelegate,UIAlertViewDelegate>
{
    double _latitude;
    double _longitude;
}
//启动广告
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)DrawCircleProgressButton *drawCircleView;

@property(nonatomic,copy)NSString *AdImageUrlStr;
@property(nonatomic,copy)NSString *textType;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *text;

// map and loading
@property (weak, nonatomic) IBOutlet UIView *searchBarContainer;
//地图  MKMapView

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//全屏的UIView
@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

//等待加载符
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;


// device summay views
//设备概要图 背景
@property (weak, nonatomic) IBOutlet UIView *deviceSummaryView;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//小横条
@property (weak, nonatomic) IBOutlet UIView *deviceSummaryBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *summaryTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *summaryOnlineImageViw;
//
//亨通光电
@property (weak, nonatomic) IBOutlet UILabel *operatorNameLab;


@property (weak, nonatomic) IBOutlet UIView *deviceFeatureView;
//计费规则 lab1
@property (weak, nonatomic) IBOutlet UIButton *chargingRuleButton;
@property (weak, nonatomic) IBOutlet UIImageView *onlineChargingImageView;
//App充电 lab 3
@property (weak, nonatomic) IBOutlet UILabel *onlineChargingLabel;
//对外开放 lab 2
@property (weak, nonatomic) IBOutlet UILabel *privateInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *uncertificatedWarningView;

@property (weak, nonatomic) IBOutlet UIView *deviceChargingInfoView;

//共2个电桩，2个空闲的 label
@property (weak, nonatomic) IBOutlet UILabel *deviceChargingInfoLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *deviceParkingInfoLabel;
//点亮label
@property (weak, nonatomic) IBOutlet UILabel *lightUpLabel;
//当没有认证（没联网的前提下），白色的的那个警告小横条
@property (weak, nonatomic) IBOutlet UIView *deviceChargingUncertificatedWarningView;


// layout constraints
@property (strong, nonatomic) MASConstraint *deviceSummaryViewBottomConstraint;

//CSHDeviceAnnotationView
//自定义的类，代表地图上显示的大头针
@property (assign, nonatomic) CSHDeviceAnnotationView *selecteAnnotationView;

//是否聚焦到用户的位置
@property (assign, nonatomic) BOOL shouldZoomToUserLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic)NSString *selectDeviceID;

@property(strong,nonatomic)NSMutableArray *dataArray;

//更新
@property(strong,nonatomic)NSString *appLink;
@property(nonatomic,copy)NSString *tip;

//您的设备正在充电中！
@property(nonatomic,strong)UIButton *btn;

@property(nonatomic,copy)NSString *theStationIsLovedOrNot;// Y N
@end

@implementation CSHMapViewController

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
#pragma mark --- 首页的数据源
-(void)getNetData{
    
    NSString *api=@"/api/devices/search";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"longitude":@(0),@"latitude":@(0),@"search":@"",@"idelonly":@(NO)};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *tempDic in responseObject) {
            CSHDevice *device=[CSHDevice new];
            device.deviceId=tempDic[@"stationId"];
            
            CSHCoordinatePoint *coordinate = [CSHCoordinatePoint new];
            NSNumber *lon=tempDic[@"geoPoint"][@"lon"];
            NSNumber *lat=tempDic[@"geoPoint"][@"lat"];
            coordinate.longitude=lon.doubleValue;
            coordinate.latitude=lat.doubleValue;
            
            device.coordinatePoint=coordinate;
            device.isOnline=YES;
            device.isCertified=YES;
            device.paymentMethod=CSHDevicePaymentMethodOther;
            
            device.name=tempDic[@"name"];
            device.operatorName=tempDic[@"operatorName"];
            
            device.totalCount=[NSString stringWithFormat:@"%@",tempDic[@"totalCount"]];
            device.idleCount=[NSString stringWithFormat:@"%@",tempDic[@"idleCount"]];
           
            
            
            device.stype=[NSString stringWithFormat:@"%@",tempDic[@"stype"]];
            device.atype=[NSString stringWithFormat:@"%@",tempDic[@"atype"]];
            device.ctype=[NSString stringWithFormat:@"%@",tempDic[@"ctype"]];
            //payType
            device.payType=[NSString stringWithFormat:@"%@",tempDic[@"payType"]];
            
            device.province=[NSString stringWithFormat:@"%@",tempDic[@"province"]];
            device.city=[NSString stringWithFormat:@"%@",tempDic[@"city"]];
            device.district=[NSString stringWithFormat:@"%@",tempDic[@"district"]];
            device.address=[NSString stringWithFormat:@"%@",tempDic[@"address"]];
            
            [self.dataArray addObject:device];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.loadingImageView stopAnimating];
        self.loadingImageView.hidden = YES;
        [MBProgressHUD showError:@"加载失败"];
    }];
}
#pragma mark --- 点击 收藏按钮 响应的事件
- (IBAction)favoriteBtnClicked:(UIButton *)sender {
    
    if ([NSUserDefaults csh_isLogin]==NO) {
        
        [self showLoginViewController];
        return;
    }
    if ([self.theStationIsLovedOrNot isEqualToString:@"N"]) {
        [self addFavoriteStation];
    }else{
        [self cancelFavoriteStation];
    }
    self.favoriteBtn.selected=!self.favoriteBtn.selected;
}

-(void)addFavoriteStation{
    NSString *api=@"/api/account/like";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"objectId":self.selectDeviceID};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation PUT:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([operation.responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"收藏成功"];
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"Y";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self judgeTokenWith:operation];
        
    }];
}
-(void)judgeTokenWith:(AFHTTPRequestOperation *)operation{
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
    

}
-(void)cancelFavoriteStation{
    NSString *api=@"/api/account/like";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
   
    NSDictionary *para=@{@"objectId":self.selectDeviceID};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
  
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation DELETE:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([operation.responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"取消收藏成功"];
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"N";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self judgeTokenWith:operation];
    }];
}

#pragma mark --- 点击分享按钮 响应的事件

- (IBAction)shareBtnClicked:(UIButton *)sender {
    
    ShareVC *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ShareVC class])];
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewController.stationId=self.selectDeviceID;
    viewController.latitude=_latitude;
    viewController.longitude=_longitude;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark --- App升级检测
-(void)checkAppVersion{
    NSString *api=@"/api/app/update";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"appType":@(0)};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //先获取当前工程项目版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        NSString *Message=responseObject[@"Message:"];//暂时还没有版本
        NSString *serviceVersion=responseObject[@"version"];
    
        if (serviceVersion==nil) {
            return ;
        }
        self.appLink=[NSString stringWithFormat:@"%@",responseObject[@"appLink"]];
        
        NSString * updateDescr=responseObject[@"updateDescr"];
        NSString * forceUpdate=responseObject[@"forceUpdate"];
        
        NSLog(@"%@---%@---%@",currentVersion,serviceVersion,self.appLink);
        
        NSComparisonResult result=[currentVersion compare:serviceVersion];
        //NSOrderedAscending  实际上线的时候改成NSOrderedDescending
        if (result==NSOrderedAscending) {
            if ([forceUpdate isEqualToString:@"false"]) {//不是强制更新
                self.tip=@"下次再说";
            }else{
                self.tip=@"退出";
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本" message:updateDescr preferredStyle:UIAlertControllerStyleAlert];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            //行间距
            paragraphStyle.lineSpacing = 5.0;
            
            NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSParagraphStyleAttributeName : paragraphStyle};
            NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:updateDescr];
            [attributedTitle addAttributes:attributes range:NSMakeRange(0, updateDescr.length)];
            [alertController setValue:attributedTitle forKey:@"attributedMessage"];//attributedTitle\attributedMessage
            //end ---
            
            UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:self.tip style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self.tip isEqualToString:@"下次再说"]) {
                    
                }else if ([self.tip isEqualToString:@"退出"]) {
                    exit(0);
                }
            }];
            UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlStr=self.appLink;
                NSLog(@"appLink:%@",self.appLink);
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
                
                //                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:defaultActiona];
            [alertController addAction:defaultActionb];
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:alertController animated: YES completion: nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
}
//警告框协议函数 响应事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==258) {//更新 的弹出框
        if (buttonIndex==1) { //ok
            NSString *urlStr=self.appLink;
            NSLog(@"appLink:%@",self.appLink);
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
        }else if (buttonIndex==0){//cancel
            if ([self.tip isEqualToString:@"下次再说"]) {
                
            }else if ([self.tip isEqualToString:@"退出"]) {
                exit(0);
            }
        }
    }else if (alertView.tag==259){// 收藏的弹出框
        if (buttonIndex==1) { //ok
            
            [self showLoginViewController];
            
        }else if (buttonIndex==0){//cancel
           
        }
    }
}

- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark --- 广告接口
-(void)getAdImage{
    NSString *api=@"/api/contents/checklog";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"classification":@"START"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array=responseObject;
        if (array.count>0) {
            [self setAdImageWithArray:array];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)setAdImageWithArray:(NSArray *)array{
    
    NSInteger value = arc4random()%(array.count);
    NSDictionary *tempDic=array[value];
    NSString *urlStr=[NSString stringWithFormat:@"%@",tempDic[@"image"]];
    
    if ([urlStr isEqualToString:@"<null>"]) {
        return;
    }
    self.AdImageUrlStr=urlStr;
    self.textType=tempDic[@"textType"];
    self.url=tempDic[@"url"];
    self.text=tempDic[@"text"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.imageView];
    
    //---start 点击进入详情
    self.imageView.userInteractionEnabled=YES;
    //1.单击手势
    UITapGestureRecognizer *tapImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    //设置点击次数
    tapImage.numberOfTapsRequired=1;//默认1
    //设置手指个数
    tapImage.numberOfTouchesRequired=1;//默认1
    
    [self.imageView addGestureRecognizer:tapImage];
    //---end
    
    self.drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, 30, 40, 40)];
    self.drawCircleView.lineWidth = 2;
    [self.drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
    [self.drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.drawCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    
    //1，设置转圈的时间
    self.drawCircleView.animationDuration=5;
    self.drawCircleView.trackColor=[UIColor cyanColor];
    self.drawCircleView.progressColor=[UIColor lightGrayColor];
    self.drawCircleView.fillColor=[UIColor whiteColor];
    /**
     *  progress 完成时候的回调
     */
//    __weak ViewController *weakSelf = self;
    [self.drawCircleView startAnimationDuration:5 withBlock:^{
//        [weakSelf removeProgress];
        [self removeProgress];
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.drawCircleView];
//    [self.view addSubview:self.drawCircleView];
}
- (void)removeProgress
{
    self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    self.imageView.alpha = 1;
    
    //2，设置移走的时间
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.alpha = 0.05;
        self.imageView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        
        [self.imageView removeFromSuperview];
        [self.drawCircleView removeFromSuperview];
        
    }];
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        _imageView.image = [UIImage imageNamed:@"launch_image.jpg"];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.AdImageUrlStr]];
    }
    return _imageView;
}

-(void)tapImage:(UITapGestureRecognizer *)tap//单击
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    ActivityVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ActivityVC class])];
    vc.textType=self.textType;
    vc.url=self.url;
    vc.text=self.text;
    vc.navigationTitle=@"";
    [self.navigationController pushViewController:vc animated:YES];
    
    [self removeProgress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self checkAppVersion];
    
    [self setGoBackBtnStyle];
    
    self.theStationIsLovedOrNot=@"N";
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share_normal"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoteGoToDestination:) name:@"navigation" object:nil];
    
    [self getNetData];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    //地图界面的  设备大背景图
    [self.tabBarController.view addSubview:self.deviceSummaryView];
    [self.deviceSummaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tabBarController.view);
        self.deviceSummaryViewBottomConstraint = make.bottom.equalTo(self.tabBarController.view).offset(kCSHHiddenSummaryViewBottomConstraintConstant);
    }];
    
    self.searchBarContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBarContainer.layer.borderWidth = 0.5f;
    [self.searchBarContainer csh_setDefaultCornerRadius];
    [self.deviceSummaryBackgroundView csh_setDefaultCornerRadius];
    
    self.mapView.delegate = self;
    
    // 1 定位
    [self locateUserOnMapViewIfPossible];
    
    // 2 点击地图 把设备概括图收藏起来
    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMapViewGesture:)]];
    
    self.mapViewContainer.hidden = YES;
    
    NSArray<NSString *> *imageNames = @[@"progress001", @"progress002", @"progress003", @"progress004", @"progress005", @"progress006", @"progress007", @"progress008", @"progress009", @"progress010", @"progress011", @"progress012", @"progress013", @"progress014", @"progress015", @"progress016", @"progress017", @"progress018", @"progress019", @"progress020", @"progress021", @"progress022", @"progress023", @"progress024", @"progress025", @"progress026", @"progress027", @"progress028", @"progress029", @"progress030", @"progress031", @"progress032", @"progress033", @"progress034", @"progress035", @"progress036", @"progress037", @"progress038", @"progress039", @"progress040", @"progress041", @"progress042", @"progress043", @"progress044", @"progress045", @"progress046", @"progress047", @"progress048", @"progress049", @"progress050", @"progress051", @"progress052", @"progress053", @"progress054", @"progress055", @"progress056", @"progress057", @"progress058", @"progress059", @"progress060"];
    NSMutableArray<UIImage *> *images = [@[] mutableCopy];
    for (NSString *name in imageNames) {
        [images addObject:[UIImage imageNamed:name]];
    }
    //    self.loadingImageView.animationImages = images;
    
    
    CSHPublicModel *singler=[CSHPublicModel shareSingleton];
    self.loadingImageView.animationImages =singler.imagesArray ;
    self.loadingImageView.animationDuration = 2.0f;
    self.loadingImageView.animationRepeatCount = CGFLOAT_MAX;
    
    
    [self setWarningBtn];
    
    [self setCustomerService];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWarningBtnOpen) name:@"setWarningOpen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWarningBtnClose) name:@"setWarningClose" object:nil];
    
     [self getAdImage];
}
#pragma mark ---您的设备正在充电中 btn
-(void)setWarningBtn{
    
    self.btn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame=CGRectMake(10, 120, screenW-20, 50);
    [self.btn setTitle:@"您的爱车正在充电中！" forState:UIControlStateNormal];
    self.btn.backgroundColor=[UIColor colorWithRed:0.94 green:0.31 blue:0.31 alpha:1];
    self.btn.layer.cornerRadius=5;
    self.btn.layer.masksToBounds=YES;
    [self.btn addTarget:self action:@selector(pushToChargingVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    self.btn.hidden=YES;
}
-(void)pushToChargingVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHOnChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHOnChargingVC class])];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   
    vc.chargerNO=[defaults objectForKey:@"chargerNO"];
    vc.stationId=[defaults objectForKey:@"stationId"];
    vc.orderId=[defaults objectForKey:@"orderId"];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark --- 点击客服中心
-(void)setCustomerService{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(screenW-40-12, screenH-64-40-10, 40, 40);
    [btn addTarget:self action:@selector(kefuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}
-(void)kefuBtnClicked{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    ServiceCenterVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ServiceCenterVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *chargerNO=[defaults objectForKey:@"chargerNO"];
    if (chargerNO==nil) {
        self.btn.hidden=YES;
    }else{
        self.btn.hidden=NO;
    }
    
    if (self.selectDeviceID!=nil) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:self.selectDeviceID]!=nil) {
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
        }else{
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
        }
    }
    
    self.navigationController.navigationBarHidden = YES;
}

// 1 展示设备概括图
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //如果大头针存在的话
    if (self.selecteAnnotationView) {
        //updateImage  调用的是CSHDeviceAnnotationView里面的方法
        [self.selecteAnnotationView updateImage];
        [self showDeviceSummaryViewWithDevice:self.selecteAnnotationView.device];
    }
    
    if (self.shouldZoomToUserLocation) {
        self.loadingImageView.hidden = NO;
        [self.loadingImageView startAnimating];
    }
}

// 2 收藏设备概括图
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideDeviceSummaryViewAnimated:NO Completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击左下角的location的button 显示到当前位置 定位

- (IBAction)locateButton:(UIButton *)sender {
    if (self.mapView.userLocation.location) {
        [self centerToCoordinate:self.mapView.userLocation.location.coordinate zoom:YES];
    }
    [self locateUserOnMapViewIfPossible];
}
#pragma mark - 点击右上角列表按钮：push到充电桩列表的界面
- (IBAction)chargingStationsButton:(UIButton *)sender {
    
    //push到列表界面 正向传值
    //这里传NO,表示隐藏搜索记录列表，显示设备列表
    [self showChargingStationsViewControllerBeginEditing:NO];
    
    //收起设备列表
    [self hideDeviceSummaryViewAnimated:NO Completion:nil];
    self.selecteAnnotationView = nil;
}

#pragma mark - 点击正上方 TextFieldButton： push到查询界面
- (IBAction)handleTextFieldButton:(UIButton *)sender {
    [self showChargingStationsViewControllerBeginEditing:YES];
    //传的是NO，并没有hideDeviceSummary，只是设置了MASConstraint
    [self hideDeviceSummaryViewAnimated:NO Completion:nil];
    self.selecteAnnotationView = nil;
}

#pragma mark - 点击---设备概括图  push到详情页面

//正向传值 传device

- (IBAction)handleTapOnSummaryViewGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self showDeviceDetail];
    
}
-(void)showDeviceDetail
{
    [self showDeviceDetailViewControllerWithDevice:self.selecteAnnotationView.device];
    
}

#pragma mark - 点击 开始导航 响应的方法 

- (IBAction)handleTapOnNavigationViewGesture:(UITapGestureRecognizer *)sender {
//    NSLog(@"navigation");
    //TODO: navigation
//    NSLog(@"_latitude:%lf",_latitude);
//    NSLog(@"_longitude:%lf",_longitude);
    
    [self goToDestination];
    
    
}
-(void)NoteGoToDestination:(NSNotification *)notifation{
    NSString *lat=notifation.userInfo[@"latitude"] ;
    NSString *lon=notifation.userInfo[@"longitude"] ;
    
    [self startNavigateWithLatitude:lat.doubleValue andLongitude:lon.doubleValue];
}
-(void)goToDestination{
    
    [self startNavigateWithLatitude:_latitude andLongitude:_longitude];
}
#pragma mark - 传入经纬度 开始导航
-(void)startNavigateWithLatitude:(double)latitude andLongitude:(double)longitude
{
    //1，当前item
    MKMapItem *currentItem = [MKMapItem mapItemForCurrentLocation];
    
    //金鑫国际
    //    double latitude = 30.489306+0.005;
    //    double longitude = 114.420874+0.005;
    
    //优网科技
//    double latitude = 30.489306;
//    double longitude = 114.420874;
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
    
    //2，目的地item
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    
    //反地理编码
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error!=nil||placemarks.count==0) {
            return ;
        }
        
        toItem.name=placemarks.firstObject.name;
        [MKMapItem openMapsWithItems:@[currentItem,toItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }];
}

//添加点击手势  预约   待续
- (IBAction)handleTapOnBookingViewGesture:(UITapGestureRecognizer *)sender {
    //TODO: booking
    NSLog(@"预约");
}
#pragma mark --- 地图添加的点击手势  隐藏设备概括图
- (void)handleTapOnMapViewGesture:(UITapGestureRecognizer *)tapGesture {
    self.selecteAnnotationView = nil;
    [self hideDeviceSummaryViewAnimated:YES Completion:nil];
}

#pragma mark - 添加大头针的方法 -------二
                /****************************/
                /****      添加大头针     ****/
                /***************************/
//功能：地图上添加大头针显示设备
// 368 行自己调用[self addAnno..];
//用处：在地图的协议方法里面调用，
- (void)addAnnotationsForDevices:(NSArray<CSHDevice *> *)devices {
    
    //这里是用枚举法遍历数组 数组指定了元素类型
    [devices enumerateObjectsUsingBlock:^(CSHDevice * _Nonnull device, NSUInteger index, BOOL * _Nonnull stop) {
        
        CSHDeviceAnnotation *annotation = [[CSHDeviceAnnotation alloc] initWithDevice:device];
        [self.mapView addAnnotation:annotation];
        
#pragma mark - 结束动画二
        [self.loadingImageView stopAnimating];
        self.loadingImageView.hidden = YES;
        
    }];
}

#pragma mark - navigate to view controllers
//push到充电桩列表 正向传值  （点击搜索的textfield的时候调用）
- (void)showChargingStationsViewControllerBeginEditing:(BOOL)shouldBeginEditing {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSHChargingStationsViewController *chargingStationsViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingStationsViewController class])];
    
    //正向传值 1,location  2,shouldBeginEditing
    chargingStationsViewController.location = self.mapView.userLocation.location;
    chargingStationsViewController.shouldBeginEditing = shouldBeginEditing;
    //此处的delegate是逆向传值的时候建立代理关系，应该还有一个方法的
    //方法在List.h里面，方法的实现在这个界面，是对应pop的返回作用
    chargingStationsViewController.delegate = self;
    [self.navigationController pushViewController:chargingStationsViewController animated:YES];
}

//点击设备概要图响应的方法 跳转到详情页面
//正向传值 传的是选中的device和userLocation（用作关键字搜索的时候与自己最近的距离排序）
- (void)showDeviceDetailViewControllerWithDevice:(CSHDevice *)device {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CSHChargingStationVC *chargingStationViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingStationVC class])];
    
    //这里的device不是传进来的device？？
    //这里是正向传值 把当前选中的device和自己的location传给 详情界面
//    chargingStationViewController.device = self.selecteAnnotationView.device;
    chargingStationViewController.stationId=[NSString stringWithFormat:@"%@",self.selecteAnnotationView.device.deviceId];
    
    chargingStationViewController.location = self.mapView.userLocation.location;
    chargingStationViewController.latitude=[NSString stringWithFormat:@"%f",_latitude];
    chargingStationViewController.longitude=[NSString stringWithFormat:@"%f",_longitude];
    
    [self.navigationController pushViewController:chargingStationViewController animated:YES];
}

#pragma mark - location feature
//viewDidLoad 里面调用的方法  定位
- (void)locateUserOnMapViewIfPossible {
    
    self.shouldZoomToUserLocation = YES;//初始化为YES
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusRestricted:
            NSLog(@"没有定位权限");
            break;
            
        case kCLAuthorizationStatusDenied: {
            NSLog(@"没有定位权限");
            break;
        }
            
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"定位权限 ** request");
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
            
        default: {
            if ([CLLocationManager locationServicesEnabled]) {
                
                
                
                // self.mapView.showsUserLocation=YES;
                [self.mapView setShowsUserLocation:YES];
                
            } else {
                NSLog(@"定位没有打开");
            }
        }
            break;
    }
}
        /*         在地图显示到传入坐标的位置      */

//1，点击地图左下角定位按钮 调用
//2,定位完成的时候调用
//3,点击大头针的时候调用
- (void)centerToCoordinate:(CLLocationCoordinate2D)coordinate zoom:(BOOL)zoom {
    MKCoordinateSpan span = zoom ? MKCoordinateSpanMake(0.02, 0.02) : self.mapView.region.span;
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:mapRegion animated:YES];
    
    if (self.shouldZoomToUserLocation) {
        self.shouldZoomToUserLocation = NO;
    }
}

#pragma mark - CLLocationManagerDelegate
//定位  CLLocationManager的协议方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied: {
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒绝");
            } else {
                NSLog(@"定位关闭，不可用");
            }
            
            break;
        }
            
            
        default: {
            [self.mapView setShowsUserLocation:YES];
            break;
        }
    }
}

#pragma mark - 展开设备概括图
//
//传入device 并且赋值

//1，点击大头针的时候调用
//2,viewDidAppear 里面调用 ？？第一次DidAppear中selecteAnnotationView一直没有初始化啊！


- (CGFloat)autoWidthString:(NSString *)string withLabel:(UILabel *)label andFontSize:(NSUInteger )fontSize{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    
    return size.width;
}
-(void)configWithDevice:(CSHDevice *)device{
    self.deviceSummaryViewBottomConstraint.offset = 0;
    self.deviceSummaryView.alpha = 1;
    [self.deviceSummaryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tabBarController.view).offset(0);
    }];
    //把概括总图放到最上层 并设置相关控件的内的内容
    [UIView animateWithDuration:0.3 animations:^{
        [self.deviceSummaryView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        //放到最上面，能把四个tabBar盖住
        [self.tabBarController.view bringSubviewToFront:self.deviceSummaryView];
    }];
    
    // configure device
    //1
    self.summaryTitleLabel.text = device.name;
    //2
    //根据计算结果重新设置UILabel的尺寸
    //    [self.operatorNameLab setFrame:CGRectMake(CGRectGetMaxX(self.summaryTitleLabel.frame), CGRectGetMinY(self.summaryTitleLabel.frame),[self autoWidthString:device.operatorName withLabel:self.operatorNameLab andFontSize:15]+20.00, 21)];
    
    self.operatorNameLab.text=[NSString stringWithFormat:@"%@ ",device.operatorName];
    self.operatorNameLab.layer.borderWidth=1;
    self.operatorNameLab.layer.borderColor=themeCorlor.CGColor;
    self.operatorNameLab.textColor=themeCorlor;
    self.operatorNameLab.layer.cornerRadius=3;
    self.operatorNameLab.layer.masksToBounds=YES;
    
    
    
    self.deviceChargingInfoLabel.text=[NSString stringWithFormat:@"共%@个电桩 %@个空闲",device.totalCount,device.idleCount];
    
    //lab3 赋值
    self.onlineChargingLabel.text=[NSString stringWithFormat:@"%@",device.payType];
    //lab2 赋值
    self.privateInfoLabel.text=[NSString stringWithFormat:@"%@",device.stype];
    
    //地址
    self.deviceAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",device.province,device.city,device.district,device.address];
    
    self.deviceParkingInfoLabel.text=[NSString stringWithFormat:@"%@",device.atype];
    //lab1 赋值
    [self.chargingRuleButton setTitle:device.ctype forState:UIControlStateNormal];
    
    
    CLLocationDistance distance = [self.mapView.userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:device.coordinatePoint.latitude longitude:device.coordinatePoint.longitude]];
    
#pragma mark --- 计算定位于device的distance
    self.distanceLabel.text = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];
    
    
    self.deviceFeatureView.hidden = !device.isCertified;
    self.deviceChargingInfoView.hidden = !device.isCertified;
    
    self.uncertificatedWarningView.hidden = device.isCertified;
    self.deviceChargingUncertificatedWarningView.hidden = device.isCertified;
    
    
    self.lightUpLabel.text=@"评论";
    //    self.lightUpLabel.textColor = !device.isCertified ? [UIColor blackColor] : [UIColor lightGrayColor];
    //1.单击手势
    UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDeviceDetail)];
    //设置点击次数
    tapOne.numberOfTapsRequired=1;//默认1
    //设置手指个数
    tapOne.numberOfTouchesRequired=1;//默认1
    [self.lightUpLabel addGestureRecognizer:tapOne];
}

- (void)showDeviceSummaryViewWithDevice:(CSHDevice *)device {
    
    NSString *api=nil;
    
    if ([NSUserDefaults csh_isLogin]==NO) {//如果没登录
        api=[NSString stringWithFormat:@"/api/stations/%@",device.deviceId];
    }else{//登录
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *accountId=[defaults objectForKey:@"userid"];
        
        api=[NSString stringWithFormat:@"/api/stations/%@?accountId=%@",device.deviceId,accountId];
    }
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *collected=[NSString stringWithFormat:@"%@",responseObject[@"collected"]];
        if ([collected isEqualToString:@"N"]) {//用户没有收藏
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"N";
        }else{
            [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"Y";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error：%@",error);
    }];
    
    [self configWithDevice:device];
}

static const CGFloat kCSHHiddenSummaryViewBottomConstraintConstant = 300;

#pragma mark - 收起设备概括图

//1， viewWillDisappear 里面调用的方法
//2，push到stations的时候调用了 2次（输入框+右上角图标）
//3，点击地图的时候 收起
//4，点击大头针时候调用（然后又收起）
- (void)hideDeviceSummaryViewAnimated:(BOOL)animated Completion:(void (^)(void))completion {
    //设置 MASConstraint
    self.deviceSummaryViewBottomConstraint.offset = kCSHHiddenSummaryViewBottomConstraintConstant;
    
    if (animated) {//传YES，就hideDeviceSummaryView
        [UIView animateWithDuration:0.3 animations:^{
            self.deviceSummaryView.alpha = 0;
            [self.deviceSummaryView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
}

#pragma mark - CSHChargingStationsViewControllerDelegate

// 逆向传值对应的delegate的对应的方法
//从stations界面pop返回到首页
- (void)chargingStationsViewControllerDidStop {
    
    [self.navigationController popViewControllerAnimated:YES];
}

            /****************************/
            /****      添加大头针     ****/
            /***************************/

//拉取网络数据，解析成为带device的数组传进来
#pragma mark - 添加大头针的方法 ------- 一

//地图 系统的协议方法  当地图获取到用户位置时调用
//1，在地图上显示大头针（需传入装有device的数组）
//2，定位到当前位置
//3, loadingImageView 在viewDidLoad中开始的，在定位成功后stop并且hidden
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //如果定位到了用户
    // viewDidLoad中，shouldZoomToUserLocation初始化为YES
    if (self.shouldZoomToUserLocation) {
        
        CSHUserLocation *single=[CSHUserLocation shareSingleton];
        single.location=self.mapView.userLocation.location;
        
  
        
#pragma mark - 结束动画一 这里改成地图成功加载大头针之后结束
//        [self.loadingImageView stopAnimating];
//        self.loadingImageView.hidden = YES;
        
        //viewDidLoad中，hidden初始化为了YES
        if (self.mapViewContainer.hidden) {

            self.mapViewContainer.hidden = NO;
            
            //TODO: remove
            //地图上添加大头针显示设备 传入的是数组
            [self addAnnotationsForDevices:self.dataArray];
        }
        //在地图显示到传入坐标的位置 （此处即是定位）
        [self centerToCoordinate:userLocation.location.coordinate zoom:YES];
    }
}
#pragma mark - MKMapViewDelegate
//大头针复用
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (![annotation isKindOfClass:[CSHDeviceAnnotation class]]) {
        return nil;//如果不是CSHDeviceAnnotation类的话就返回nil
    }
    
    CSHDeviceAnnotationView *annotationView = (CSHDeviceAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([CSHDeviceAnnotationView class])];
    if (!annotationView) {
        annotationView = [[CSHDeviceAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([CSHDeviceAnnotationView class])];
    }
    //updateImage 这里调用的是CSHDeviceAnnotationView自己的方法
    //每次生成大头针的时候 更新大头针的颜色 红 白 蓝
    
    //主线程里面更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [annotationView updateImage];
    });
    
    
    return annotationView;
}

#pragma mark - MKMapViewDelegate
#pragma mark ---- 大头针的点击事件
//MKAnnotationView 的点击事件
//1,展开设备概括图
//2，地图聚焦到当前位置
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    //如果点击的大头针不是充电桩的大头针（其他的）
    if (![view.annotation isKindOfClass:[CSHDeviceAnnotation class]] && ![view isKindOfClass:[CSHDeviceAnnotationView class]]) {
        return;
    }
    
    //找到大头针所对应的device
    CSHDevice *device = ((CSHDeviceAnnotation *)view.annotation).device;
    
    self.selectDeviceID=[NSString stringWithFormat:@"%@",device.deviceId];
    
#warning 收藏问题
#pragma mark - 收藏 五角星的颜色问题
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:self.selectDeviceID]!=nil) {
//        [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
//    }else{
//        [self.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
//    }
    
    
    _latitude=device.coordinatePoint.latitude;
    _longitude=device.coordinatePoint.longitude;
    
    if (self.selecteAnnotationView) {
        
        __weak typeof(self) weakSelf = self;
        
        [self hideDeviceSummaryViewAnimated:YES Completion:^{
            [weakSelf showDeviceSummaryViewWithDevice:device];
        }];
    } else {
        //展开设备详情图
        [self showDeviceSummaryViewWithDevice:device];
    }
    self.selecteAnnotationView = (CSHDeviceAnnotationView *)view;
   // CSHDeviceAnnotationView 继承自MKAnnotationView，带有device的属性
    [self centerToCoordinate:view.annotation.coordinate zoom:NO];
    
//    self.selecteAnnotationView = nil;
    
    
//    UIView *blackBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
//    blackBg.tag=130;
////    blackBg.backgroundColor=[UIColor blackColor];
//    [[UIApplication sharedApplication].keyWindow addSubview:blackBg];
//    
//    //点击手势
//    UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
//    //设置点击次数
//    tapOne.numberOfTapsRequired=1;//默认1
//    //设置手指个数
//    tapOne.numberOfTouchesRequired=1;//默认1
//    [blackBg addGestureRecognizer:tapOne];
    

}

-(void)tapOne:(UITapGestureRecognizer *)tap//单击
{
    self.selecteAnnotationView = nil;
    [self hideDeviceSummaryViewAnimated:YES Completion:nil];
    
    //相对于某一个视图 获取手势点击的位置
    CGPoint point=[tap locationInView:tap.view];
    //tap.view  通过这个属性我们可以获得添加此手势的视图
    NSLog(@"%@---%@",tap.view,NSStringFromCGPoint(point));
    
    UIView *c=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:130];
    [c removeFromSuperview];
}


#pragma mark - getters and setters
//属性 locationManager懒加载
//用来判断是否有定位权限
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}

@end
