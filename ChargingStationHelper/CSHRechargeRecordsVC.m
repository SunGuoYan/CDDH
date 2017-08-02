//
//  CSHRechargeRecordsVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/7.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//



#import "CSHRechargeRecordsVC.h"
#import "RechargeRecordCell.h"
#import "RechargeRecordModel.h"

#import "MJRefresh.h"

@interface CSHRechargeRecordsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,assign)NSInteger page;
@end

@implementation CSHRechargeRecordsVC
-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)getRechargeRecords{
    NSString *api=@"/api/account/rechargeRecords";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"page":@"0",@"size":@"20"};
    
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
                
                RechargeRecordModel *model=[[RechargeRecordModel alloc]init];
                
                model.recordCreatedAt=tempDic[@"createdAt"];
                model.recordMoney=tempDic[@"money"];
                model.recordpaidFrom=tempDic[@"paidFrom"];
                model.recordstatus=tempDic[@"status"];
                
                [self.dataArray addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
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
    
    [self setGoBackBtnStyle];
    
    self.title=@"充值明细";
    self.view.backgroundColor=initialGray;

    //网络获取table的数据源
//    [self getRechargeRecords];
    
   
    self.table.backgroundColor=bginitialGray;
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
 
    self.table.showsVerticalScrollIndicator=NO;
    self.table.showsHorizontalScrollIndicator=NO;
    
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
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
//    self.table.mj_footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        self.page+=1;
//        [self loadNetDataWithPage:self.page];
//    }];
}

-(void)loadNetDataWithPage:(NSInteger)page{
    
    NSString *api=@"/api/account/rechargeRecords";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"page":[NSString stringWithFormat:@"%ld",page],@"size":@"20"};
    
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
                
                RechargeRecordModel *model=[[RechargeRecordModel alloc]init];
                
                model.recordCreatedAt=tempDic[@"updatedAt"];
                model.recordMoney=tempDic[@"money"];
                model.recordpaidFrom=tempDic[@"paidFrom"];
                model.recordstatus=tempDic[@"status"];
                
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
            self.imageV.image=nil;
        }else{
            self.imageV.image=[UIImage imageNamed:@"noContent"];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.table reloadData];
//        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        NSLog(@"error：%@",error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellllID";
    RechargeRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        
        cell=[[[NSBundle mainBundle]loadNibNamed:@"RechargeRecordCell" owner:self options:nil] firstObject];
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    RechargeRecordModel *model=self.dataArray[indexPath.row];
    cell.recordMoney.textColor=themeCorlor;
    cell.recordMoney.text=[NSString stringWithFormat:@"%@",model.recordMoney];
    cell.recordCreatedAt.text=[NSString stringWithFormat:@"%@",model.recordCreatedAt];
    
    cell.recordStatus.text=[NSString stringWithFormat:@"%@",model.recordstatus];
    cell.recordPaidFrom.text=[NSString stringWithFormat:@"%@",model.recordpaidFrom];
    cell.spaceLab.backgroundColor=initialGray;
    cell.contentView.backgroundColor=initialGray;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
