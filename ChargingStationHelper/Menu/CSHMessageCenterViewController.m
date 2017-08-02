//
//  CSHMessageCenterViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHMessageCenterViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"

#import "MJRefresh.h"

@interface CSHMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIImageView *imageV;//空白页面

@property(nonatomic,assign)NSInteger page;
@end

@implementation CSHMessageCenterViewController
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
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
    
    
    
    self.title = @"消息中心";
    
    [self setGoBackBtnStyle];
    
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64) style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.table.backgroundColor=bginitialGray;
    [self.view addSubview:self.table];
    
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
    
    self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 180, 180)];
    self.imageV.center=CGPointMake(screenW/2, screenH/2-64);
    [self.view addSubview:self.imageV];
}
-(void)loadNetDataWithPage:(NSInteger)page{
    
    NSString *api=@"/api/getnotify/read";
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
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tempArray=responseObject[@"items"];
        if (tempArray.count>0) {
            
            for (NSDictionary *tempDic in tempArray) {
                MessageModel *model=[[MessageModel alloc]init];
                model.message_id=tempDic[@"id"];
                model.title=tempDic[@"title"];
                model.time=tempDic[@"time"];
                model.content=tempDic[@"content"];
                model.ifRead=tempDic[@"ifRead"];
                [self.dataArray addObject:model];
            }
        }
        if (tempArray.count>0) {
            self.imageV.image=nil;//空白图片
        }else{
            self.imageV.image=[UIImage imageNamed:@"noContent"];
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark --- table的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"ActivityTableCell";
    
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
      cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    MessageModel *model=self.dataArray[indexPath.row];
    cell.model=model;
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=self.dataArray[indexPath.row];
    CGRect framea=[model.title boundingRectWithSize:CGSizeMake(screenW-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGRect frameb=[model.content boundingRectWithSize:CGSizeMake(screenW-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    
    
    return 30+framea.size.height+frameb.size.height+20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
