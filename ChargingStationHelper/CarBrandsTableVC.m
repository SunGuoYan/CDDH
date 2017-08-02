//
//  CarBrandsTableVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 17/1/5.
//  Copyright © 2017年 com.iycharge. All rights reserved.
//

#import "CarBrandsTableVC.h"
#import "CSHCarBrandTableViewCell.h"
@interface CarBrandsTableVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrayC;
    NSArray *arrayE;
}
@end

@implementation CarBrandsTableVC
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
    
    [self setGoBackBtnStyle];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    arrayC = [NSArray arrayWithObjects:@"比亚迪",@"大众",@"奔驰",@"康迪",@"江淮",@"荣威",@"力帆",@"别克",@"奥迪",@"长安",@"北汽",@"丰田",@"东风",@"奇瑞",@"华泰",@"吉利",@"众泰",@"腾势",@"知豆",@"其他",nil];
    
    arrayE = [NSArray arrayWithObjects:@"icon_byd",@"大众",@"奔驰",@"康迪",@"icon_jac",@"荣威",@"力帆",@"别克",@"奥迪",@"icon_chana",@"icon_baw",@"丰田",@"东风",@"奇瑞",@"华泰",@"吉利",@"众泰",@"icon_denza",@"icon_zd",@"其他",nil];
    
    NSArray *carIconArray=@[@"icon_baw",@"icon_bmw",@"icon_byd",@"icon_chana",
                        @"icon_chevrolet",@"icon_denza",@"icon_jac",@"icon_roewe",
                            @"icon_tesla",@"icon_venucia",@"icon_zd"];
    NSArray *carNameArray=@[@"北汽",@"宝马",@"比亚迪",@"长安",
                            @"雪佛兰",@"腾势",@"江淮",@"荣威",
                            @"特斯拉",@"启辰",@"知豆"];
    
    
   
    self.navigationItem.title=@"支持车型";
  //  [self.tableView registerNib:[UINib nibWithNibName:@"CSHCarBrandTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CSHCarBrandTableViewCell class]) ];
    //[self.tableView registerNib:[UINib nibWithNibName:@"CSHCarBrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSHCarBrandTableViewCell"];
    [self.tableView registerClass:[CSHCarBrandTableViewCell class] forCellReuseIdentifier:@"AAAAA"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID=@"AAAAA";
    
    CSHCarBrandTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CSHCarBrandTableViewCell" owner:self options:nil] firstObject];
        
    }
    
   // CSHCarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHCarBrandTableViewCell class]) forIndexPath:indexPath];
    NSString *name=self.dataArray[indexPath.row];
    NSInteger index=[arrayC indexOfObject:name];
    
    
    cell.brandLabel.text=name;
    cell.logoImageView.image=[UIImage imageNamed:arrayE[index]];
    /*
    static NSString *cellID=@"carBrandsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *name=self.dataArray[indexPath.row];
    NSInteger index=[arrayC indexOfObject:name];
    cell.imageView.image=[UIImage imageNamed:arrayE[index]];
    cell.textLabel.text=name;
     */
    
    return cell;
}



@end
