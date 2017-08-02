//
//  CSHChargingHistoryViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//


#import "CSHChargingHistoryViewController.h"
#import "chargingHistoryCell.h"
#import "chargeHistoryModel.h"

#import "MJRefresh.h"

@interface CSHChargingHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *imageV;//空白页面
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger page;

@end

@implementation CSHChargingHistoryViewController

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}


-(void)setGoBackBtnStyle{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  setGoBackBtnStyle];
    self.title = @"充电记录";
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    //    self.table.bounces=NO;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.showsVerticalScrollIndicator=NO;
    self.table.showsHorizontalScrollIndicator=NO;
    
    self.table.backgroundColor=bginitialGray;
    [self.view addSubview:self.table];
    
    self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 180, 180)];
    self.imageV.center=CGPointMake(screenW/2, screenH/2-64);
    [self.view addSubview:self.imageV];
    
    self.page=0;
    [self loadNetDataWithPage:self.page];
    
    self.table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=0;
        [self.dataArray removeAllObjects];
        [self loadNetDataWithPage:self.page];
    }];
    
    self.table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page+=1;
        [self loadNetDataWithPage:self.page];
    }];
    
}
-(void)loadNetDataWithPage:(NSInteger)page{
    NSString *api=@"/api/account/orders";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"page":[NSString stringWithFormat:@"%ld",self.page],@"size":@"20"};
    
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
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array=responseObject[@"items"];
        
        if (array.count!=0) {
            for (NSDictionary *tempDic in array) {
                
                chargeHistoryModel *model=[[chargeHistoryModel alloc]init];
                model.stationName=tempDic[@"charger"][@"stationName"];
                model.chargeName=tempDic[@"charger"][@"chargeName"];
                model.chargeNo=tempDic[@"charger"][@"chargeNo"];
                model.chargeTime=tempDic[@"scharginTime"];
                model.money=tempDic[@"money"];
                model.ChargeStatus=tempDic[@"sstatus"];
                model.startAt=tempDic[@"startAt"];
                
                [self.dataArray addObject:model];
            }
        }
        
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.table.mj_header isRefreshing]) {
                [self.table.mj_header endRefreshing];
            }
            if ([self.table.mj_footer isRefreshing]) {
                [self.table.mj_footer endRefreshing];
            }
            
            [self.table reloadData];
        });
        
        if (self.dataArray.count>0) {
            self.imageV.image=nil;//空白图片
        }else{
            self.imageV.image=[UIImage imageNamed:@"noContent"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
              NSLog(@"error：%@",error);
        
    }];
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
    NSString *cellID=@"chargingHistoryCellID";
    chargingHistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"chargingHistoryCell" owner:self options:nil] firstObject];
       
    }
    cell.spendMoneyLab.textColor=[UIColor colorWithRed:0 green:0.71 blue:0.69 alpha:1];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    chargeHistoryModel *model=self.dataArray[indexPath.row];
    
    //1 充点电
    cell.chargingPlaceLab.text=model.stationName;
    //2 电桩号
    cell.stationNOLab.text=model.chargeName;
    
//    double time=model.chargeTime.doubleValue;
    
    /*
    NSString *timeStr=nil;
    
    NSInteger hour=time/3600;
    NSInteger minute=(time-hour*3600)/60;
    NSInteger second=time-hour*3600-minute*60;
    
    if (hour>0) {
        timeStr=[NSString stringWithFormat:@"%ld小时%ld分%ld秒",hour,minute,second];
    }else if (minute>0){
        timeStr=[NSString stringWithFormat:@"%ld分%ld秒",minute,second];
    }else if (second>0){
        timeStr=[NSString stringWithFormat:@"%ld秒",second];
    }
     */
    
    //3 充电时长
    cell.timeLongLab.text=model.chargeTime;
    //4 充电状态
    cell.chargeState.text=model.ChargeStatus;
    //5 充电时间
    cell.creatAtLab.text=[NSString stringWithFormat:@"%@",model.startAt];
    
    //6 消耗金额
    cell.spendMoneyLab.text=[NSString stringWithFormat:@"消耗金额：%@元",model.money];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
