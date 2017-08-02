//
//  CSHChargingStationViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/14/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHChargingStationViewController.h"
#import "CSHChargingStationDetailTableViewCell.h"
#import "CSHDevice.h"
#import "UIColor+CSH.h"
#import "CSHChargingStationCommentTableViewCell.h"
#import "CSHChargingStationPhotoCollectionViewCell.h"

#import "CSHCharger.h"
#import "ChargingListCell.h"
#import "CSHPublicModel.h"

#import "UIImageView+WebCache.h"

#import "CSHChargerDetailVC.h"


@interface CSHChargingStationViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

// device info views


//
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageV;

@property (weak, nonatomic) IBOutlet UILabel *operationNameLab;

//1-3
@property (weak, nonatomic) IBOutlet UILabel *ctypeLab;
@property (weak, nonatomic) IBOutlet UILabel *stypeLab;
@property (weak, nonatomic) IBOutlet UILabel *paytype;


@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *totalCountLab;
@property (weak, nonatomic) IBOutlet UILabel *idleCountLab;
//电站名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *deviceFeatureView;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//设备信息概要图
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *sliderView;

//三个按钮
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
//三个屏宽的背景图
@property (weak, nonatomic) IBOutlet UIView *containerView;

//三个屏宽的背景图 的宽高设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;

//scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//小滑条的x值得设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderViewCenterXConstraint;

//table-collection-table
@property (weak, nonatomic) IBOutlet UITableView *chargesListTable;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//table-collection-table的数据源
@property(strong,nonatomic)NSMutableArray *chargerListDataArray;
@property(strong,nonatomic)NSMutableArray *imageListDataArray;
@property(strong,nonatomic)NSMutableArray *commentListDataArray;

@end

@implementation CSHChargingStationViewController

-(NSMutableArray *)commentListDataArray{
    if (_commentListDataArray==nil) {
        _commentListDataArray=[[NSMutableArray alloc]init];
    }
    return _commentListDataArray;
}
-(NSMutableArray *)imageListDataArray{
    if (_imageListDataArray==nil) {
        _imageListDataArray=[[NSMutableArray alloc]init];
    }
    return _imageListDataArray;
}
-(NSMutableArray *)chargerListDataArray{
    if (_chargerListDataArray==nil) {
        _chargerListDataArray=[[NSMutableArray alloc]init];
    }
    return _chargerListDataArray;
}

//查询电站详情
-(void)getOneStation{
    NSString  *api=[NSString stringWithFormat:@"/api/stations/%@",self.stationId];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempDic=responseObject;
        if (tempDic!=nil) {
            CSHDevice *device=[CSHDevice new];
            
            CSHCoordinatePoint *coordinate = [CSHCoordinatePoint new];
            NSNumber *lon=tempDic[@"longitude"];
            NSNumber *lat=tempDic[@"latitude"];
            coordinate.longitude=lon.doubleValue;
            coordinate.latitude=lat.doubleValue;
            
            device.coordinatePoint=coordinate;
            
            device.name=tempDic[@"name"];
            device.operatorName=tempDic[@"operator"][@"name"];
            
            device.totalCount=[NSString stringWithFormat:@"%@",tempDic[@"totalCount"]];
            device.idleCount=[NSString stringWithFormat:@"%@",tempDic[@"idleCount"]];
            
            device.stype=[NSString stringWithFormat:@"%@",tempDic[@"stype"]];
            device.atype=[NSString stringWithFormat:@"%@",tempDic[@"atype"]];
            device.ctype=[NSString stringWithFormat:@"%@",tempDic[@"ctype"]];
            device.payType=[NSString stringWithFormat:@"%@",tempDic[@"payType"]];
            device.address=tempDic[@"location"];
            
            device.priceStr=[NSString stringWithFormat:@"%@",tempDic[@"price"]];
            device.feeStr=[NSString stringWithFormat:@"%@",tempDic[@"fee"]];
            device.openTime=[NSString stringWithFormat:@"%@",tempDic[@"openTime"]];
            
            device.chargesDataArray=[[NSMutableArray alloc]init];
            
            //电桩的数组
            NSArray *tempArray=tempDic[@"chargers"];
            if (tempArray.count>0) {
                for (NSDictionary *chargerDic in tempArray) {
                    CSHCharger *model=[[CSHCharger alloc]init];
        
                    model.idStr=[NSString stringWithFormat:@"%@",chargerDic[@"id"]];//id
    
                    model.code=[NSString stringWithFormat:@"%@",chargerDic[@"code"]];//编号
                    model.name=chargerDic[@"name"];//名称
                    model.parkNo=[NSString stringWithFormat:@"%@",chargerDic[@"parkNo"]];//车位号
                    model.cif=chargerDic[@"cif"];//国标直流枪
                    model.cstatus=chargerDic[@"cstatus"];
                    
                    model.power=[NSString stringWithFormat:@"%@",chargerDic[@"power"]];//功率
                    
                    model.voltage=[NSString stringWithFormat:@"%@",chargerDic[@"voltage"]];//电压
                    model.type=[NSString stringWithFormat:@"%@",chargerDic[@"type"]];
                    
                    model.ctype=chargerDic[@"ctype"];
                     model.supportCars=chargerDic[@"supportCars"];
                    model.price=[NSString stringWithFormat:@"%@",chargerDic[@"price"]];
                    
                    [self.chargerListDataArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.chargesListTable reloadData];
                });
            }
            
            //图片urlStr的数组
            NSArray *tempImageArray=tempDic[@"images"];
            if (tempImageArray.count>0) {
                for (NSDictionary *tempImageDic in tempImageArray) {
                    CSHPublicModel *model=[[CSHPublicModel alloc]init];
                    model.imageUrlStr=tempImageDic[@"src"];
                    
                    [self.imageListDataArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
            [self configureWithDevice:device];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"error：%@",error);
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"电站详情";
    
    CSHPublicModel *singler=[CSHPublicModel shareSingleton];
    
    self.loadingImageV.animationImages =singler.imagesArray ;
    self.loadingImageV.animationDuration = 2.0f;
    self.loadingImageV.animationRepeatCount = CGFLOAT_MAX;
    
    self.view.backgroundColor=[UIColor yellowColor];
    
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];
    
    [self getOneStation];
    
    self.operationNameLab.textColor=themeCorlor;
    self.operationNameLab.layer.borderColor=themeCorlor.CGColor;
    self.operationNameLab.layer.borderWidth=1;
    
    
    //1,电站列表的table
    self.chargesListTable.delegate=self;
    self.chargesListTable.dataSource=self;
    self.chargesListTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    //3,评论的table
    self.tableView.delegate = self;
    self.tableView.backgroundColor=[UIColor purpleColor];
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 40);
    
    //2,图片collection
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.scrollView.bounces=NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 和 viewWillAppear 一样 控件加约束

- (void)viewWillLayoutSubviews {
    //三个屏宽的背景图 的宽高设置
    self.containerViewWidthConstraint.constant = kCSHScreenWidth * 3;
    self.containerViewHeightConstraint.constant = kCSHScreenHeight - 64.0f - CGRectGetHeight(self.headerView.bounds) - CGRectGetHeight(self.sliderView.bounds);

    [super viewWillLayoutSubviews];
}

//
#pragma mark - 点击三个切换按钮
//点击想详情按钮  设置scrollView的偏移量 切换界面
- (IBAction)handleDetailButton:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self updateTabView];
}
//点击照片按钮
- (IBAction)handlePhotoButton:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(kCSHScreenWidth, 0)];
    [self updateTabView];
}
//点击评论按钮
- (IBAction)handleCommentButton:(UIButton *)sender {
    [self.scrollView setContentOffset:CGPointMake(kCSHScreenWidth * 2, 0)];
    [self updateTabView];
}

#pragma mark - subview

//切换三个按钮的颜色
//改变小滑块的x值 移动滑块
- (void)updateTabView {
    //默认当前按钮是 详情按钮
    UIButton *currentButton = self.detailButton;
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    CGFloat sliderViewOffsetXUnit = (kCSHScreenWidth - 2) / 3;
    if (fabs(offsetX) < 5) {
        self.sliderViewCenterXConstraint.constant = 0;
    }
    if (fabs(offsetX - kCSHScreenWidth) < 5) {
        //切换到 照片按钮
        currentButton = self.photoButton;
        self.sliderViewCenterXConstraint.constant = sliderViewOffsetXUnit;
    }
    if (fabs(offsetX - kCSHScreenWidth * 2) < 5) {
        //切换到 评论按钮
        currentButton = self.commentButton;
        self.sliderViewCenterXConstraint.constant = sliderViewOffsetXUnit * 2;
    }
    
    [self.detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentButton setTitleColor:[UIColor csh_brandColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.sliderView.superview layoutIfNeeded];
                     }];
}

#pragma mark - 详情界面的赋值
- (void)configureWithDevice:(CSHDevice *)device {
//    
    self.titleLabel.text = device.name;
    self.deviceAddressLabel.text = device.address;
    
    //这个方法来计算定位的位置与电站的距离
    CLLocationDistance distance = [self.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:device.coordinatePoint.latitude longitude:device.coordinatePoint.longitude]];
    
    self.distanceLabel.text = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];
    
//    self.deviceFeatureView.hidden = !self.device.isCertified;
    
    self.operationNameLab.text=device.operatorName;
    self.ctypeLab.text=device.ctype;
    self.stypeLab.text=device.stype;
    self.paytype.text=device.payType;
    
    self.priceLab.text=[NSString stringWithFormat:@"%@元/度",device.priceStr];
    self.feeLab.text=[NSString stringWithFormat:@"%@元/小时",device.feeStr];
    self.openTimeLab.text=device.openTime;
    
    self.totalCountLab.text=device.totalCount;
    self.idleCountLab.text=device.idleCount;
    
    //界面赋值完成之后  stopAnimating
    self.loadingImageV.hidden = YES;
    [self.loadingImageV stopAnimating];
    
}

#pragma mark - ScrollView 的代理方法

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //table，collection，scrollView 三个
    if (scrollView != self.scrollView) {
        return;
    }
    //decelerate=NO，停止拖动的时候
    if (!decelerate) {
        [self updateTabView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    [self updateTabView];//停止减速的时候
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    [self updateTabView];//停止拖动的时候
}

#pragma mark - cell 的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.tableView) {
        
        return 2;
        
    }else if (tableView==self.chargesListTable){
        
        return self.chargerListDataArray.count;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //评论的table
    if (tableView==self.tableView) {
        CSHChargingStationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHChargingStationCommentTableViewCell class]) forIndexPath:indexPath];
        cell.userNameLab.text=@"阳光初夏";
        cell.userCommentTextLab.text=@"还不错";
        cell.userDateLab.text=@"2016.9.14 10:18";
        
        return cell;
    //电桩列表的table
    }else if (tableView==self.chargesListTable){
        static NSString *cellID=@"ChargingListCellID";
        ChargingListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ChargingListCell" owner:self options:nil] firstObject];
        }
        cell.numberLab.radius=20;
        
        cell.numberLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        CSHCharger *model=self.chargerListDataArray[indexPath.row];
        
        
        cell.laba.text=[NSString stringWithFormat:@"编 号：%@",model.idStr];
        cell.labb.text=[NSString stringWithFormat:@"名 称：%@",model.name];
        cell.labc.text=[NSString stringWithFormat:@"车位号：%@",model.parkNo];
        cell.labd.text=[NSString stringWithFormat:@"驻地站 %@（%@V）%@kW",model.cif,model.voltage,model.power];
        
        //type  AC 慢
        cell.labe.text=model.type;
        cell.labf.text=model.cstatus;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.chargesListTable) {
        return 80;
    }
    return 100;
}
#pragma mark --- cell 的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.chargesListTable) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSHChargerDetailVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargerDetailVC class])];
        CSHCharger *model=self.chargerListDataArray[indexPath.row];
      //  vc.chargerId=model.idStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - Collection 的三个方法
//图片 的collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSHChargingStationPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CSHChargingStationPhotoCollectionViewCell class]) forIndexPath:indexPath];
//        CSHImage *image = self.device.images[indexPath.row];
//        [cell.imageView sd_setImageWithURL:image.url];
    
    CSHPublicModel *model=self.imageListDataArray[indexPath.row];
    
    NSURL *url=[NSURL URLWithString:model.imageUrlStr];
    [cell.imageView sd_setImageWithURL:url];
    
    
    
    
    
    return cell;
}

@end
