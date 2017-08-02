//
//  ServiceCenterVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/29.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ServiceCenterVC.h"
#import "FeedBackCell.h"
#import "CSHFeedbackViewController.h"
#import "QuestionModel.h"
#import "QuestionCell.h"
#import "MJRefresh.h"
#import "ActivityVC.h"
#import "FeedBackModel.h"
#import "CSHLoginViewController.h"
@interface ServiceCenterVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIColor *blueGreen;
}
@property(nonatomic,strong)UITableView *table1;
@property(nonatomic,strong)NSMutableArray *dataArray1;

@property(nonatomic,strong)UITableView *table2;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)UIScrollView *scroll;



//小滑条
//@property (weak, nonatomic) IBOutlet UIView *slider;

@property(nonatomic,strong)UIView *slider;

@property (weak, nonatomic) IBOutlet UIImageView *iocna;
@property (weak, nonatomic) IBOutlet UIImageView *iconb;


@property(nonatomic,assign)NSInteger table1page;
@property(nonatomic,assign)NSInteger table2page;
@property(nonatomic,copy)NSString *rightSlider;

@end

@implementation ServiceCenterVC
-(NSMutableArray *)dataArray1{
    if (_dataArray1==nil) {
        _dataArray1=[[NSMutableArray alloc]init];
    }
    return  _dataArray1;
}
-(NSMutableArray *)dataArray2{
    if (_dataArray2==nil) {
        _dataArray2=[[NSMutableArray alloc]init];
    }
    return  _dataArray2;
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
-(void)loadNetDataWithPage:(NSInteger)page{
    NSString *api=@"/api/contents/check";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"classification":@"QUESTION",@"page":[NSString stringWithFormat:@"%ld",page],@"size":@"20"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tempArr=responseObject[@"items"];
        
        for (NSDictionary *tempDic in tempArr) {
            QuestionModel *model=[[QuestionModel alloc]init];
            model.title=tempDic[@"title"];
            
            model.textType=[NSString stringWithFormat:@"%@",tempDic[@"textType"]];
            model.urlStr=tempDic[@"url"];
            model.text=tempDic[@"text"];
            [self.dataArray1 insertObject:model atIndex:0];
        }
        
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.table1.mj_header isRefreshing]) {
                [self.table1.mj_header endRefreshing];
            }
            if ([self.table1.mj_footer isRefreshing]) {
                [self.table1.mj_footer endRefreshing];
            }
            
            [self.table1 reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"客服中心";
    
    self.slider=[[UIView alloc]initWithFrame:CGRectMake(0, 50, screenW/2, 2)];
    blueGreen=[UIColor colorWithRed:0 green:0.72 blue:0.94 alpha:1];
    self.slider.backgroundColor=blueGreen;
    [self.view addSubview:self.slider];
    [self setGoBackBtnStyle];
    
    CGFloat scrollH=screenH-64-50-5;
    self.scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 55, screenW, scrollH)];
    self.scroll.backgroundColor=bginitialGray;
    self.scroll.pagingEnabled=YES;
    self.scroll.bounces=NO;
    self.scroll.delegate=self;
    self.scroll.contentSize=CGSizeMake(screenW*2, scrollH);
    self.scroll.showsVerticalScrollIndicator=NO;
    self.scroll.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.scroll];
    
    self.table1=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, scrollH) style:UITableViewStylePlain];
    self.table1.delegate=self;
    self.table1.dataSource=self;
//    self.table1.bounces=NO;
    self.table1.backgroundColor=bginitialGray;
    self.table1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table1.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.scroll addSubview:self.table1];
    
    self.table1page=0;
    [self loadNetDataWithPage:self.table1page];
    
    self.table1.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.table1page=0;
        [self.dataArray1 removeAllObjects];
        [self loadNetDataWithPage:self.table1page];
    }];
    
    self.table1.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.table1page+=1;
        [self loadNetDataWithPage:self.table1page];
    }];
    
    self.table2=[[UITableView alloc]initWithFrame:CGRectMake(screenW, 0, screenW, scrollH-44) style:UITableViewStyleGrouped];
    self.table2.delegate=self;
    self.table2.dataSource=self;
    self.table2.backgroundColor=bginitialGray;
    self.table2.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table2.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.scroll addSubview:self.table2];
    
    self.table2page=0;
    [self loadQuestionDataWithPage:self.table2page];
    
    //table2的刷新
    self.table2.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.table2page=0;
        [self.dataArray2 removeAllObjects];
        [self loadQuestionDataWithPage:self.table2page];
    }];
    
    self.table2.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.table2page+=1;
        [self loadQuestionDataWithPage:self.table2page];
    }];
    
    
    //新建立反馈
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(screenW, scrollH-44, screenW, 44)];
    bg.backgroundColor=[UIColor whiteColor];
    [self.scroll addSubview:bg];
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(screenW/2-50-20+15, 12, 20, 20)];
    imageV.image=[UIImage imageNamed:@"newFB"];
    [bg addSubview:imageV];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(screenW/2-50+15, 0, 100, 44);
    [btn setTitle:@"新建反馈" forState:UIControlStateNormal];
    [btn setTitleColor:blueGreen forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    
    //客服
    UIButton *btna=[UIButton buttonWithType:UIButtonTypeCustom];
    btna.frame=CGRectMake(screenW-50, scrollH-44-50, 30, 30);
    [btna setBackgroundImage:[UIImage imageNamed:@"KEFU-1"] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(btnaclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
}
-(void)loadQuestionDataWithPage:(NSInteger)page{
    NSString *api=@"/api/feedBacks/check";
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
        NSArray *items=responseObject[@"items"];
        if (items.count>0) {
            
            NSMutableArray *solvedArray=[[NSMutableArray alloc]init];
            NSMutableArray *suspendingArray=[[NSMutableArray alloc]init];
            for (NSDictionary *tempDic in items)
            {
                FeedBackModel *model=[[FeedBackModel alloc]init];
                NSString *status=[NSString stringWithFormat:@"%@",tempDic[@"status"]];
                if ([status isEqualToString:@"SOLVED"]||[status isEqualToString:@"CLOSED"]) {
                    
                    model.status=[NSString stringWithFormat:@"%@",tempDic[@"status"]];
                    model.content=[NSString stringWithFormat:@"%@",tempDic[@"content"]];
                    NSArray *auditLogListArray=tempDic[@"auditLogList"];
                    NSDictionary *contentDic=[auditLogListArray lastObject];
                    model.replay=contentDic[@"content"];
                    
                    [solvedArray addObject:model];
                    
                }else if ([status isEqualToString:@"CONFIRM"]||[status isEqualToString:@"SUSPENDING"]||[status isEqualToString:@"HANDLING"]){
                    model.status=[NSString stringWithFormat:@"%@",tempDic[@"status"]];
                    model.content=[NSString stringWithFormat:@"%@",tempDic[@"content"]];
                    
                    [suspendingArray addObject:model];
                }
            }
            
            [self.dataArray2 addObject:solvedArray];
            [self.dataArray2 addObject:suspendingArray];
            
        }
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.table2.mj_header isRefreshing]) {
                [self.table2.mj_header endRefreshing];
            }
            if ([self.table2.mj_footer isRefreshing]) {
                [self.table2.mj_footer endRefreshing];
            }
            
            [self.table2 reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];}
#pragma mark --- 点击常见问题
- (IBAction)question:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.center=CGPointMake(screenW/4, 50+1);
        self.scroll.contentOffset=CGPointMake(0, 0);
    }];
    self.iocna.image=[UIImage imageNamed:@"FQAH"];
    self.iconb.image=[UIImage imageNamed:@"feedBack"];
}
#pragma mark --- 点击我的反馈
- (IBAction)feedBack:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.center=CGPointMake(screenW*3/4, 50+1);
        self.scroll.contentOffset=CGPointMake(screenW, 0);
    }];
    self.iocna.image=[UIImage imageNamed:@"FQA"];
    self.iconb.image=[UIImage imageNamed:@"feedBackH"];
}

#pragma mark --- 点击拨打客服
-(void)btnaclicked{
    //1,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否要拨打客服电话？\n0512-63957614" preferredStyle:UIAlertControllerStyleAlert];
    //2
    UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0512-63957614"]];
    }];
    [alertController addAction:defaultActiona];
    [alertController addAction:defaultActionb];
    //3
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:alertController animated: YES completion: nil];
}


#pragma mark --- 点击新建反馈
-(void)btnclicked{
    if ([NSUserDefaults csh_isLogin]==NO) {
        
        [self showLoginViewController];
        return;
    }
    CSHFeedbackViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHFeedbackViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- table的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.table1) {
        return 1;
    }else if (tableView==self.table2){//
        return self.dataArray2.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.table1) {
        return self.dataArray1.count;
    }else if (tableView==self.table2){//
        return [self.dataArray2[section] count];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.table1) {
        static NSString *cellID=@"QuestionCell";
        QuestionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"QuestionCell" owner:self options:nil] firstObject];
        }
        QuestionModel *model=self.dataArray1[indexPath.row];
        cell.laba.radius=15;
        
        cell.laba.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.labb.text=model.title;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView==self.table2){
        
        NSString *cellID=@"FeedBackCell";
        QuestionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"QuestionCell" owner:self options:nil] firstObject];
        }
        FeedBackModel *model=self.dataArray2[indexPath.section][indexPath.row];
        cell.laba.radius=15;
        cell.laba.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.labb.text=model.content;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
#pragma mark --- cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.table1) {
        QuestionModel *model=self.dataArray1[indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        ActivityVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ActivityVC class])];
        vc.textType=model.textType;
        vc.url=model.urlStr;
        vc.text=model.text;
        vc.navigationTitle=@"常见问题";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tableView==self.table2){
//        if (indexPath.section==0) {
            FeedBackModel *model=self.dataArray2[indexPath.section][indexPath.row];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
            ActivityVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ActivityVC class])];
            vc.textType=@"TEXT";
            vc.text=model.replay;
            vc.content=model.content;
            
            vc.navigationTitle=@"我的反馈";
            [self.navigationController pushViewController:vc animated:YES];
//        }
        
    }
}
#pragma mark --- table的代理方法
//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==self.table2) {
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 50)];
        bg.backgroundColor=[UIColor whiteColor];
        UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        head.textAlignment=NSTextAlignmentCenter;
        head.textColor=blueGreen;
        if (section==0) {
            head.text=@"已处理";
        }else if (section==1){
            head.text=@"未处理";
        }
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 49, screenW, 1)];
        line.backgroundColor=bginitialGray;
        [bg addSubview:line];
        [bg addSubview:head];
        
        return bg;
        
    }
    return nil;
}
//footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView==self.table2) {
        
        if ([self.dataArray2[section] count]==0) {
            UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 70)];
            bg.backgroundColor=[UIColor whiteColor];
            UILabel *foot=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW, 50)];
            foot.textAlignment=NSTextAlignmentCenter;
            foot.textColor=blueGreen;
            if (section==0) {
                foot.text=@"暂无已处理";
            }else if (section==1){
                foot.text=@"暂无未处理";
            }
            [bg addSubview:foot];
            
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 50, screenW, 20)];
            line.backgroundColor=bginitialGray;
            [bg addSubview:line];
            
            return bg;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView ==self.table2) {
        return 50;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView ==self.table2) {
        if ([self.dataArray2[section] count]==0) {
            return 70;
        }
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
#pragma mark ---scrollView 的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.scroll) {
        [UIView animateWithDuration:0.3 animations:^{
            self.slider.center=CGPointMake(scrollView.contentOffset.x/2+screenW/4, 50+1);
        }];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scroll) {
        self.slider.center=CGPointMake(scrollView.contentOffset.x/2+screenW/4, 50+1);
    }
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
