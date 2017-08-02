//
//  CSHChargingStationsViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHChargingStationsViewController.h"

#import "CSHChargingStationTableViewCell.h"
#import "CSHKeywordTableViewCell.h"
#import "CSHChargingStationViewController.h"
#import "CSHNetworkingManager+API.h"
#import "CSHDevice.h"
#import "UIColor+CSH.h"
#import "NSUserDefaults+CSH.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "CSHChargingStationVC.h"


@interface CSHChargingStationsViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CSHChargingStationTableViewCellDelegate>
{
     BOOL  isIdle;//switch 空闲电桩
     BOOL isSuitable;//switch 适合我的
}
//输入关键字的table 1
@property (weak, nonatomic) IBOutlet UITableView *keywordTableView;

//输入关键字的table 底部的清空搜索记录的button
@property (weak, nonatomic) IBOutlet UIButton *keywordTableViewFooterButton;


//设备列表的table 2
@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarContainer;

@property(nonatomic,strong)UIImageView *imageV;//空白图片

//热门搜索的背景条
@property (weak, nonatomic) IBOutlet UIView *limitationContainer; // filter limitation

//输入框的背景条
@property (weak, nonatomic) IBOutlet UIView *textFieldView; // search text view
@property (weak, nonatomic) IBOutlet UITextField *textField;

//地图按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;

//热门搜索的按钮
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

//热门搜索 指示图片
@property (weak, nonatomic) IBOutlet UIImageView *filterIndicatorImageView;

//switch按钮一
@property (weak, nonatomic) IBOutlet UISwitch *idleSwitch;
//switch按钮一
@property (weak, nonatomic) IBOutlet UISwitch *recommendSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterContainerHeightConstraint;

//整个界面的灰色背景
@property (weak, nonatomic) IBOutlet UIView *filterBackgroundView;


//设置 筛选条件的 两个switch 是否展开
@property (assign, nonatomic) BOOL isFilterShown;


#pragma mark - 原来的，设备列表table的数据源

@property (strong, nonatomic) NSMutableArray<CSHDevice *> *devices;
@property (strong, nonatomic) CSHNetworkingManager *manager;

#pragma mark - 自己写的，设备列表table的数据源
@property(strong,nonatomic)NSMutableArray *dataArray;

@end

@implementation CSHChargingStationsViewController

static NSString *const kCSHNoCachedKeywordTitle = @"暂无搜索历史";
static NSString *const kCSHClearCachedKeywordTitle = @"清空搜索历史";

#pragma mark - life cycle
-(NSMutableArray *)dataArray
{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

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
    
    isIdle=NO;
    isSuitable=NO;
    
    self.devices=[[NSMutableArray alloc]init];
    
    self.textField.delegate = self;
    
    self.navigationBarContainer.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    
    self.textFieldView.radius=4;
    [self.textFieldView setBorderWithColor:[UIColor lightGrayColor] andWidth:1];
    
//    self.textFieldView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.textFieldView.layer.masksToBounds = YES;
    
    self.rightBarButton.layer.cornerRadius = 4.0f;
    self.rightBarButton.layer.masksToBounds = YES;
    
    self.deviceTableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.deviceTableView.delegate = self;
    self.deviceTableView.dataSource = self;
#pragma mark - 如果传的 YES 进来，键盘弹起，编辑模式 hidden=no 展开搜索记录列表 盖住设备列表
    
#pragma mark - 如果传的 NO 进来，hidden=YES 隐藏搜索记录列表 设备列表显示出来
    self.keywordTableView.hidden = !self.shouldBeginEditing;
    
    //如果是设备列表，通过传进来的location获取网络数据，赋值给self.dataArray
    if (self.shouldBeginEditing==NO) {
        [self loadData];
//        [self requestNetDataWithLocation:self.location];
    }
    
    //设置FooterButton按钮的标题
    NSString *keywordTableViewFooterButtonTitle = kCSHNoCachedKeywordTitle;//无记录
    //装有搜索记录的数组
    NSArray <NSString *> *keywords = [NSUserDefaults csh_cachedKeywords];
    
    //如果搜索记录个数大于0，
    if (keywords && keywords.count > 0) {
        keywordTableViewFooterButtonTitle = kCSHClearCachedKeywordTitle;//清除记录
    }
    [self.keywordTableViewFooterButton setTitle:keywordTableViewFooterButtonTitle forState:UIControlStateNormal];
    self.keywordTableView.delegate = self;
    self.keywordTableView.dataSource = self;
    
    self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.imageV.center=CGPointMake(screenW/2, (screenH-64)/2);
//    self.imageV.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.imageV];
}
#pragma mark -- 设备列表的网络数据请求

-(void)requestNetDataWithLocation:(CLLocation *)location{
    
    //设置url和参数
    NSString *urlStr=@"http://192.168.3.245:8100/oauth/token";
    //这里传进来的的location要作为para传到服务器
    NSDictionary *para=@{@"grant_type":@"password",@"phone":@"13657229663",@"password":@"tom"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_operation.requestSerializer setValue:@"Basic eW91ZXRvbmctYW5kcm9pZDpzZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //此处请求回来的应该是个经过距离排序后的数组，遍历
        for (CSHDevice *device in responseObject) {
            
            [self.dataArray addObject:device];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //如果传的yes进来，键盘弹起，编辑模式
    if (self.shouldBeginEditing) {
        [self.textField becomeFirstResponder];//键盘弹起
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击右上角 button 按钮
- (IBAction)handleRightBarButton:(UIButton *)sender {
    //如果是输入状态 ->搜索button
    if (self.textField.isFirstResponder) {
        [self searchDevices];// search 展示搜索结果
//        [self searchDevices];
        //
        if (self.devices.count>0) {
            [self.devices removeAllObjects];
        }
    } else {
        //如果不是输入状态，返回地图 （地图button)
        
        //delegate的传值，在首页中中实现的 pop 就是返回功能
        [self.delegate chargingStationsViewControllerDidStop];
    }
}

- (void)searchDevices {
    
    [self loadData];
    
    //如果输入不为空
    if (![self.textField.text isEqualToString:@""]) {
        //存入table的数组
        [NSUserDefaults csh_addKeywords:self.textField.text];
    }
    
    //如果输入框是第一响应者，就放弃（收起键盘）
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
#pragma mark - 点击键盘上的 前往（确认，搜索）等，开始搜索的时候，把搜索记录的列表 hidden
    if (!self.keywordTableView.hidden) {
        self.keywordTableView.hidden = YES;
    }
}

#pragma mark - 点击 筛选条件 的灰色横条 展开或关系两个button
- (IBAction)handleFilterButton:(UIButton *)sender {
    self.isFilterShown = !self.isFilterShown;
}
#pragma mark - 点击 灰色横条其他地方 收起横条
- (IBAction)handleTapOnFilterBackgroundViewGesture:(UITapGestureRecognizer *)sender {
    self.isFilterShown = NO;
}
#pragma mark - 点击 空闲电桩的 switch
- (IBAction)handleIdleSwitch:(UISwitch *)sender {
    isIdle=!isIdle;
    [self.devices removeAllObjects];
    [self getAllStations];
}

#pragma mark - 点击 推荐的 switch
- (IBAction)handleRecommendedSwitch:(UISwitch *)sender {
//    [self loadData];
}

#pragma mark - 点击热门搜索的 四个按钮

- (IBAction)handleKeywordSearchButton:(UIButton *)sender {
    self.textField.text = sender.currentTitle;
    [self searchDevices];
}
#pragma mark - 点击清除搜做记录的button（切换成了暂无搜索历史
- (IBAction)handleKeywordTableViewFooterButton:(UIButton *)sender {
    if ([NSUserDefaults csh_cachedKeywords].count > 0) {
        [NSUserDefaults csh_clearKeywords];
    }
    [self.keywordTableView reloadData];
    [sender setTitle:kCSHNoCachedKeywordTitle forState:UIControlStateNormal];
}

#pragma mark - （设备列表的）数据源
/*  不用原代码的请求方式 自己用AFN请求 */
//输入关键字之后，点击搜索 加载数据 刷新deviceTableView
- (void)loadData {
    
    [self getAllStations];
}

-(void)getAllStations{
    
    NSString *api=@"/api/devices/search";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"longitude":@(self.location.coordinate.longitude),@"latitude":@(self.location.coordinate.latitude),@"search":self.textField.text,@"idleonly":@(isIdle)};
    
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
            //这里array成了一个二维数组，直接遍历responseObject
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
                
                device.name=tempDic[@"name"];
                device.paymentMethod=CSHDevicePaymentMethodOther;
                device.address=[NSString stringWithFormat:@"%@%@%@%@",tempDic[@"province"],tempDic[@"city"],tempDic[@"district"],tempDic[@"address"]];
                
                device.operatorName=tempDic[@"operatorName"];
                device.stype=tempDic[@"stype"];
                device.totalCount=[NSString stringWithFormat:@"%@",tempDic[@"totalCount"]];
                device.idleCount=[NSString stringWithFormat:@"%@",tempDic[@"idleCount"]];
                
                [self.devices addObject:device];
                
            }
            
            // 输入 dispatch GCD once 第一个提示
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                <#code to be executed once#>
//            });
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.deviceTableView reloadData];
        });
        if (self.devices.count>0) {
            self.imageV.image=nil;
        }else{
            self.imageV.image=[UIImage imageNamed:@"noSearch"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



#pragma mark - navigation

- (void)startNavigation {
    //
}

#pragma mark - table的三个代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //如果是设备列表
    if (tableView == self.deviceTableView) {
        
        return self.devices.count;
        
    } else {//否则是搜索记录列表 返回数组的个数

        NSArray *keywords = [NSUserDefaults csh_cachedKeywords];
        return keywords ? keywords.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.deviceTableView) {
        //1，如果是设备列表的table
        CSHChargingStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHChargingStationTableViewCell class]) forIndexPath:indexPath];
        
            [cell configureWithDevice:self.devices[indexPath.row] userLocation:self.location];
        //
        cell.delegate = self;
        
        return cell;
    } else {
        
        //2，如果是关键字搜索记录的table
        CSHKeywordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHKeywordTableViewCell class]) forIndexPath:indexPath];
        cell.keywordLabel.text = [NSUserDefaults csh_cachedKeywords][indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark - cell 的点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.deviceTableView) {

        //如果是设备列表，跳转到详情
        //跳转到详情的时候需要传参  电站的id
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSHChargingStationVC *chargingStationViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingStationVC class])];
        
        CSHDevice *model=self.devices[indexPath.row];
        
        chargingStationViewController.stationId =[NSString stringWithFormat:@"%@",model.deviceId];
        chargingStationViewController.location = self.location;
        
        
        [self.navigationController pushViewController:chargingStationViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        //如果是搜索记录的列表，跳转到设备列表
        self.textField.text = [NSUserDefaults csh_cachedKeywords][indexPath.row];
        [self searchDevices];
    }
}

#pragma mark - CSHChargingStationTableViewCellDelegate

//
- (void)chargingStationTableViewCellNavigationButtonTapped:(CSHChargingStationTableViewCell *)cell {
    [self startNavigation];
}

#pragma mark - TextField Delegate
//开始编辑
//当搜索框是输入状态的时候（键盘弹起），右上角按钮图片为 搜索

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.rightBarButton setBackgroundImage:[UIImage imageNamed:@"search-search-bar-button"] forState:UIControlStateNormal];
    self.textFieldView.layer.borderColor = [UIColor csh_brandColor].CGColor;
}
//结束编辑
//不是搜索状态的时候(键盘收起)，右上角按钮图片为 地图
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.rightBarButton setBackgroundImage:[UIImage imageNamed:@"search-map-bar-button"] forState:UIControlStateNormal];
    self.textFieldView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
#pragma mark - 点击键盘上的 确认（前往）等时候开始搜索
//输入框结束的时候也开始搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchDevices];
    //
    if (self.devices.count>0) {
        [self.devices removeAllObjects];
    }
    return YES;
}

#pragma mark - setters & getters
//懒加载
//关键字搜索之后，点击确认开始搜索
- (CSHNetworkingManager *)manager {
    if (!_manager) {
        _manager = [CSHNetworkingManager new];
    }
    return _manager;
}

//这个方法写在这里没人调用
- (void)setIsFilterShown:(BOOL)isFilterShown {
    if (isFilterShown == _isFilterShown) {
        return;
    }
    
    
    self.filterContainerHeightConstraint.constant = isFilterShown ? 121.0f : 40.0f;
    self.filterIndicatorImageView.transform = isFilterShown ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    self.filterBackgroundView.alpha = isFilterShown ? 1.0f : 0.0f;
    }];
    
    _isFilterShown = isFilterShown;
}

@end
