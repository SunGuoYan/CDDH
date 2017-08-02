//
//  CSHTimelineViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//


#import "CSHTimelineViewController.h"
#import "ActivityTableCell.h"
#import "ActivityModel.h"
#import "MJRefresh.h"
#import "ActivityVC.h"
@interface CSHTimelineViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIImageView *loadingImageV;

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;


@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)UIImageView *imageV;//空白页面
@end

@implementation CSHTimelineViewController
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)loadNetDataWithPage:(NSInteger )page{
    NSString *api=@"/api/contents/check";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    //“START”  APP启动广告
    //“REGISTER”  APP注册协议  空的
    //“ACTIVITY”  APP活动   空的
    //“QUESTION”  常见问题   空的
    NSDictionary *para=@{@"classification":@"ACTIVITY",@"page":[NSString stringWithFormat:@"%ld",page],@"size":@"20"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //分页
        NSArray *tempArr=responseObject[@"items"];
        //未分页
//        NSArray *tempArr=responseObject;
        if (tempArr.count>0) {
            for (NSDictionary *tempDic in tempArr) {
                ActivityModel *model=[[ActivityModel alloc]init];
                model.title=tempDic[@"title"];
                model.imageUrl=tempDic[@"image"];
                model.releasedAt=tempDic[@"releasedAt"];
                model.validAt=tempDic[@"validAt"];
                model.textType=tempDic[@"textType"];
                model.url=tempDic[@"url"];
                model.text=tempDic[@"text"];
                model.releasedAt=tempDic[@"releasedAt"];
                
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
            self.imageV.image=[UIImage imageNamed:@"pleaseWait"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64-48) style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
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
#pragma mark --- table的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"ActivityTableCell";
    ActivityTableCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ActivityTableCell" owner:self options:nil] firstObject];
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ActivityModel *model=self.dataArray[indexPath.row];
    NSString *releasedAt=[NSString stringWithFormat:@"%@",model.releasedAt];
//    cell.laba.text=model.releasedAt;
    NSURL *url=[NSURL URLWithString:model.imageUrl];
    [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cddh"]];
    
    cell.labc.text=model.title;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
//    NSString *releasedAt=tempDic[@"releasedAt"];
//    NSString *validAt=tempDic[@"validAt"];
    
    //设置世界格式 不允许有不一样的
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *releasedAtD=[formatter dateFromString:model.releasedAt];
    NSDate *validAtD=[formatter dateFromString:model.validAt];
    
    //表示当前时间 注意：格林时间模式
    NSDate * date1 = [NSDate date];
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date1];
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [date1 dateByAddingTimeInterval:offset];
   
    
    NSTimeInterval a=  [localDate timeIntervalSinceDate:validAtD];
    
    NSString *releasedAt_Str=[NSString stringWithFormat:@"%@",model.releasedAt];
    NSArray *components=[releasedAt_Str componentsSeparatedByString:@"00:00:00"];
    cell.laba.text=[components firstObject];
    cell.labb.hidden=YES;
    if (a<0) {
        cell.imageVb.image=[UIImage imageNamed:@"activity_on"];
//        cell.labb.text=@"活动中";
    }else{
        cell.imageVb.image=[UIImage imageNamed:@"activity_end"];
//        cell.labb.text=@"已结束";
    }
    
    return cell;
}
#pragma mark --- table的三个方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
#pragma mark --- cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityModel *model=self.dataArray[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    ActivityVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ActivityVC class])];
    vc.textType=model.textType;
    vc.url=model.url;
    vc.text=model.text;
    vc.navigationTitle=@"活动详情";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)originalCodeOfAbandon{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64-49)];
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    
    self.loadingImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 96*8/13)];
    self.loadingImageV.center=CGPointMake(screenW/2, screenH/2-64);
    [self.view addSubview:self.loadingImageV];
    
    NSString *found_url=@"http://120.52.12.203:8100/app/discovery/html/discovery.html";
    
    
    
    CSHPublicModel *singler=[CSHPublicModel shareSingleton];
    self.loadingImageV.animationImages =singler.imagesArray ;
    self.loadingImageV.animationDuration = 2.0f;
    self.loadingImageV.animationRepeatCount = CGFLOAT_MAX;
    
    //开始等待加载符
    self.loadingImageV.hidden = NO;
    [self.loadingImageV startAnimating];
    
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:found_url]]];
    
    
    /****/
    //结束等待加载符
    self.loadingImageV.hidden=YES;
    self.webView.hidden=YES;
}


//UIWebView的几个协议函数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    NSLog(@"webViewDidFinishLoad");
    self.loadingImageV.hidden = YES;
    [self.loadingImageV stopAnimating];

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"didFailLoadWithError");
    self.loadingImageV.hidden = YES;
    [self.loadingImageV stopAnimating];
    [MBProgressHUD showError:@"加载失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
