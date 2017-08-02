//
//  CSHChargingRuleVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/6.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHChargingRuleVC.h"
#import "PriceCell.h"
#import "PriceModel.h"
@interface CSHChargingRuleVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *table;
@end

@implementation CSHChargingRuleVC
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
    self.title=@"计费规则";
    
    [self  setGoBackBtnStyle];
    
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.table];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"PriceCell";
    PriceCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PriceCell" owner:self options:nil] firstObject];
    }
    PriceModel *model=self.dataArray[indexPath.row];
    
    cell.laba.text=[NSString stringWithFormat:@"%@-%@",model.startAt,model.endAt];
    cell.labb.text=[NSString stringWithFormat:@"%@",model.price];
    cell.labc.text=[NSString stringWithFormat:@"%@",model.fee];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 50)];
    UILabel *laba=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW/3, 50)];
    laba.text=@"时  段";
    laba.font = [UIFont fontWithName:@"Helvetica" size:13];
    laba.textAlignment=NSTextAlignmentCenter;
    laba.textColor=[UIColor lightGrayColor];
    [bg addSubview:laba];
    
    UILabel *labb=[[UILabel alloc]initWithFrame:CGRectMake(screenW/3, 0, screenW/3, 50)];
    labb.text=@"电费（元/度）";
    labb.font = [UIFont fontWithName:@"Helvetica" size:13];
    labb.textAlignment=NSTextAlignmentCenter;
    labb.textColor=[UIColor lightGrayColor];
    [bg addSubview:labb];
    
    UILabel *labc=[[UILabel alloc]initWithFrame:CGRectMake(screenW*2/3, 0, screenW/3, 50)];
    labc.text=@"服务费（元/度）";
    labc.font = [UIFont fontWithName:@"Helvetica" size:13];
    labc.textAlignment=NSTextAlignmentCenter;
    labc.textColor=[UIColor lightGrayColor];
    [bg addSubview:labc];
    return bg;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}













-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
//    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
