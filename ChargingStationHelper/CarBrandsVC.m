//
//  CarBrandsVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 17/1/5.
//  Copyright © 2017年 com.iycharge. All rights reserved.
//

#import "CarBrandsVC.h"
#import "CSHCarBrandTableViewCell.h"
#import "SupportCarCell.h"
@interface CarBrandsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrayC;
    NSArray *arrayE;
}
@property (weak, nonatomic) IBOutlet UITableView *table;



@end

@implementation CarBrandsVC

-(void)setGoBackBtnStyle{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"支持车型";
    [self setGoBackBtnStyle];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    //特斯拉 @"宝马", 新增加
    arrayC=@[@"比亚迪",@"大众",@"奔驰",@"康迪",
             @"江淮",@"荣威",@"力帆",@"别克",
             @"奥迪",@"长安",@"北汽",@"丰田",
             @"东风",@"奇瑞",@"华泰",@"吉利",
             @"众泰",@"腾势",@"知豆",@"特斯拉",
             @"宝马",@"其他"];
    arrayE=@[@"icon_byd",@"icon_dz",@"icon_bc",@"icon_kd",
            @"icon_jac",@"icon_roewe",@"icon_lf",@"icon_bk",
            @"icon_ad",@"icon_chana",@"icon_baw",@"icon_ft",
            @"icon_df",@"icon_qr",@"icon_ht",@"icon_jl",
            @"icon_zt",@"icon_denza",@"icon_zd",@"icon_tesla",
            @"icon_bmw",@"其他"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID=@"SupportCarCell";
    
    SupportCarCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SupportCarCell" owner:self options:nil] firstObject];
    }
    
    // CSHCarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHCarBrandTableViewCell class]) forIndexPath:indexPath];
    NSString *name=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    NSInteger index=[arrayC indexOfObject:name];
    if (index>30) {
        index=21;
    }
    
    cell.laba.text=name;
    cell.imageV.image=[UIImage imageNamed:arrayE[index]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
