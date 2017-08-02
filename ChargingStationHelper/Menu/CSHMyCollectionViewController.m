//
//  CSHMyCollectionViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHMyCollectionViewController.h"

#import "collectionCell.h"
#import "collectionModel.h"

#import <CoreLocation/CoreLocation.h>
#import "CSHUserLocation.h"

#import "CSHChargingStationVC.h"

#import "MJRefresh.h"

@class CLLocation;
@interface CSHMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)UIImageView *noCollectionImageV;

@end

@implementation CSHMyCollectionViewController

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)getUserFavoriteStation{
    NSString *api=@"/api/account/favorites";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头一
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array=[NSArray arrayWithObjects:responseObject, nil];
        if (array.count>0) {
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *tempDic in responseObject) {
                
                NSDictionary *stationDic=tempDic[@"station"];
                
                collectionModel *model=[[collectionModel alloc]init];
                model.stationName=stationDic[@"name"];
                model.stationType=stationDic[@"stype"];
                model.stationLocation=stationDic[@"location"];
                model.operatorStr=stationDic[@"operator"][@"name"];
                model.stationtotalCount=[NSString stringWithFormat:@"%@",stationDic[@"totalCount"]];
                model.stationlongitude=[NSString stringWithFormat:@"%@",stationDic[@"longitude"]];
                model.stationlatitude=[NSString stringWithFormat:@"%@",stationDic[@"latitude"]];
                
                model.stationId=[NSString stringWithFormat:@"%@",stationDic[@"id"]];
                
//
                [self.dataArray insertObject:model atIndex:0];
            }
        }
        if (self.dataArray.count>0) {
            self.noCollectionImageV.image=nil;
        }else{
            self.noCollectionImageV.image=[UIImage imageNamed:@"noContent"];
        }
        
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.table.mj_header isRefreshing]) {
                [self.table.mj_header endRefreshing];
            }
            
//            if ([self.table.mj_footer isRefreshing]) {
//                [self.table.mj_footer endRefreshing];
//            }
            
            [self.table reloadData];
        });
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.table reloadData];
//        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserFavoriteStation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGoBackBtnStyle];

    self.title = @"我的收藏";
    
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.showsVerticalScrollIndicator=NO;
    self.table.showsHorizontalScrollIndicator=NO;
    
    self.table.backgroundColor=bginitialGray;
    [self.view addSubview:self.table];
    
    
    
    self.page=0;
//    [self loadNetDataWithPage:self.page];
    
    self.table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=0;
        [self.dataArray removeAllObjects];
        
        [self getUserFavoriteStation];
//        [self loadNetDataWithPage:self.page];
    }];
    
//    self.table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.page+=1;
//        [self loadNetDataWithPage:self.page];
//    }];
    
    self.noCollectionImageV=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 180, 180)];
    self.noCollectionImageV.center=CGPointMake(screenW/2, screenH/2-64);
    [self.view addSubview:self.noCollectionImageV];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID=@"collectionCellID";
    collectionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"collectionCell" owner:self options:nil] firstObject];

    }
    collectionModel *model=self.dataArray[indexPath.row];
    cell.nameLab.text=model.stationName;
    cell.addressLab.text=model.stationLocation;
    //公共站
    
    CGSize size=[model.stationType sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [cell.publicStationLab setFrame:CGRectMake(CGRectGetMinX(cell.publicStationLab.frame), CGRectGetMinY(cell.publicStationLab.frame), size.width+20, size.height+10)];
//    cell.publicStationLab.frame=CGRectMake(CGRectGetMinX(cell.publicStationLab.frame), CGRectGetMinY(cell.publicStationLab.frame), size.width+20, size.height+10);
    
    cell.publicStationLab.text=[NSString stringWithFormat:@"%@ ",model.stationType];
    cell.publicStationLab.textColor=themeCorlor;
    cell.publicStationLab.layer.cornerRadius=3;//倒角
    cell.publicStationLab.layer.masksToBounds=YES;
    cell.publicStationLab.layer.borderWidth=1;
    cell.publicStationLab.layer.borderColor=themeCorlor.CGColor;
    cell.publicStationLab.adjustsFontSizeToFitWidth=YES;
    //运营商
    cell.companyNameLab.text=[NSString stringWithFormat:@"%@ ",model.operatorStr];
    cell.companyNameLab.layer.borderWidth=1;
    cell.companyNameLab.layer.borderColor=themeCorlor.CGColor;
    cell.companyNameLab.layer.cornerRadius=3;
    cell.companyNameLab.layer.masksToBounds=YES;
    cell.companyNameLab.textColor=themeCorlor;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.bookingBtn.hidden=YES;
    
    cell.numberLab.text=model.stationtotalCount;
    
    
    CSHUserLocation *single=[CSHUserLocation shareSingleton];
    CLLocation *userLocation=  single.location;
    
    CLLocationDistance distance = [userLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:[model.stationlatitude doubleValue] longitude:[model.stationlongitude doubleValue]]];
    
    cell.distanceLab.text = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSHChargingStationVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingStationVC class])];
    
    collectionModel *model=self.dataArray[indexPath.row];
    
    vc.stationId =[NSString stringWithFormat:@"%@",model.stationId];

    CSHUserLocation *single=[CSHUserLocation shareSingleton];
    vc.location = single.location;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
