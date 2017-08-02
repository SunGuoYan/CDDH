//
//  CSHChargerDetailVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHChargerDetailVC.h"

#import "StartChargingVC.h"
#import "CSHStartChargingVC.h"
#import "CSHChargingRuleVC.h"
#import "BrandsCell.h"
#import "PriceModel.h"
#import "PriceCell.h"
#import "CSHLoginViewController.h"
#import "GunCell.h"
#import "CarBrandsTableVC.h"
#import "CarBrandsVC.h"
#import "GunsModel.h"
#import "IndicaterView.h"
@interface CSHChargerDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *selectIndexPath;
    NSString *isFirst;
}
@property(nonatomic,strong)NSMutableArray *dataArray;//枪的数据源
@property(nonatomic,strong)NSMutableArray *dataArray2;//电价的数据源
@property(nonatomic,strong)NSMutableArray *dataArray3;//汽车品牌的数据源

@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UILabel *labb;

//枪的table
@property (weak, nonatomic) IBOutlet UITableView *table;


@end

@implementation CSHChargerDetailVC
#pragma mark --- 点击汽车品牌
- (IBAction)carBrandClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CarBrandsVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CarBrandsVC class])];
    vc.dataArray=self.dataArray3;
    [self.navigationController pushViewController:vc animated:YES];
    /*
    CarBrandsTableVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CarBrandsTableVC class])];
    vc.dataArray=self.dataArray3;
    [self.navigationController pushViewController:vc animated:YES];
     */
}
#pragma mark --- 点击计费规则
- (IBAction)rulesClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHChargingRuleVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargingRuleVC class])];
    vc.dataArray=self.dataArray2;
    [self.navigationController pushViewController:vc animated:YES];
}





-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)dataArray2{
    if (_dataArray2==nil) {
        _dataArray2=[[NSMutableArray alloc]init];
    }
    return _dataArray2;
}
-(NSMutableArray *)dataArray3{
    if (_dataArray3==nil) {
        _dataArray3=[[NSMutableArray alloc]init];
    }
    return _dataArray3;
}
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
    isFirst=@"0";
    //枪的table
    self.table.dataSource=self;
    self.table.delegate=self;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    self.startChargingBtn.userInteractionEnabled=NO;
    self.startChargingBtn.backgroundColor=[UIColor lightGrayColor];
   // self.startChargingBtn.backgroundColor=themeCorlor;
    
    self.startChargingBtn.radius=4;
    
    self.title=@"充电桩详情";
    
    [self setGoBackBtnStyle];
    
    //电桩详情的数据源
    [self getOneChargerDetail];
    
    IndicaterView *c=[[IndicaterView alloc]initWithFrame:self.view.bounds];
    c.tag=100;
    //也可以添加到keyWindow 上
    //    [[UIApplication sharedApplication].keyWindow addSubview:c];
    [self.view addSubview:c];
}
#pragma mark --- table的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *stationsTableID=@"GunCell";
    GunCell *cell=[tableView dequeueReusableCellWithIdentifier:stationsTableID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GunCell" owner:self options:nil] firstObject];
    }
    GunsModel *model=self.dataArray[indexPath.row];
    cell.laba.text=[NSString stringWithFormat:@"%@    %@  (%@)  %@",model.gunName,model.cif,model.voltage,model.power];
    
    if ([model.status isEqualToString:@"IDLE"]) {
        cell.labb.text=@"闲";
        cell.labb.backgroundColor=[UIColor colorWithRed:0.31 green:0.81 blue:0.44 alpha:1];
    }else if ([model.status isEqualToString:@"OFFLINE"]){
        cell.labb.text=@"离";
    }else if ([model.status isEqualToString:@"REPAIR"]){
        cell.labb.text=@"修";
    }else if ([model.status isEqualToString:@"CHARGING"]){
        cell.labb.text=@"充";
    }else if ([model.status isEqualToString:@"OCCUPIED"]){
        cell.labb.text=@"占";
    }
    //保证只默认选中第一个空闲的枪
    if ([isFirst isEqualToString:@"0"]) {
        if ([model.status isEqualToString:@"IDLE"]) {
            isFirst=@"1";
            selectIndexPath=indexPath;
            cell.imageV.image=[UIImage imageNamed:@"icon_pay_checked"];
            
            self.startChargingBtn.userInteractionEnabled=YES;
            self.startChargingBtn.backgroundColor=themeCorlor;
        }
    }
    /*
    //自定义cell选中时的背景
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    selectedBackgroundView.alpha = 0.8;
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 44)];
    lineLabel.backgroundColor = [UIColor redColor];
    [selectedBackgroundView addSubview:lineLabel];
    cell.selectedBackgroundView = selectedBackgroundView;
     */
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark --- cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath!=selectIndexPath) {
        GunCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        cell.imageV.image=[UIImage imageNamed:@"icon_pay_checked"];
        
        if (selectIndexPath!=nil) {
            GunCell *cell = [self.table cellForRowAtIndexPath:selectIndexPath];
            cell.imageV.image=[UIImage imageNamed:@"icon_pay_unchecked"];
        }
        selectIndexPath=indexPath;
    }
    
    GunsModel *model=self.dataArray[indexPath.row];
    
    if ([model.status isEqualToString:@"IDLE"]) {
        self.startChargingBtn.userInteractionEnabled=YES;
        self.startChargingBtn.backgroundColor=themeCorlor;
    }else{
        self.startChargingBtn.userInteractionEnabled=NO;
        self.startChargingBtn.backgroundColor=[UIColor lightGrayColor];
    }
}

-(void)getOneChargerDetail{
    NSString *api=nil;
    NSDictionary *para=nil;
    
    if (self.chargerQrcode!=nil) {//qrcode查询扫码 手动输入
        api=@"/api/chargers/qrcode";
        para=@{@"qrcode":self.chargerQrcode};
    }else{// code 首页进来的
       // http://180.97.90.76:8200/api/chargers/4402020030000011
        
        api=@"/api/chargers/code";
        para=@{@"code":self.chargerCode};
    }
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject!=nil) {
            
            IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
            [c removeFromSuperview];
            
            self.chargerCode=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
            
            //1.电枪模块
            NSArray *tempGunsArray=responseObject[@"guns"];
            if (tempGunsArray.count>0) {
                for (NSDictionary *GunsDic in tempGunsArray) {
                    GunsModel *model=[[GunsModel alloc]init];
                    model.gunNo=GunsDic[@"gunNo"];
                    model.gunName=GunsDic[@"gunName"];
                    model.cif=GunsDic[@"cif"];
                    model.voltage=GunsDic[@"voltage"];
                    model.power=GunsDic[@"power"];
                    
                    model.status=GunsDic[@"status"];
                    
                    [self.dataArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.table reloadData];
                });
            }
            
            
            //2.电价模块
            NSArray *tempArray=responseObject[@"priceTemplate"];
            if (tempArray.count>0) {
                for (NSDictionary *tempDic in tempArray) {
                    PriceModel *model=[[PriceModel alloc]init];
                    model.startAt=tempDic[@"startAt"];
                    model.endAt=tempDic[@"endAt"];
                    model.fee=tempDic[@"fee"];
                    model.price=tempDic[@"price"];
                    
                    [self.dataArray2 addObject:model];
                }
            }
            
            //电站
            NSDictionary *stationDic=responseObject[@"station"];
            
            self.chargerNameLab.text=stationDic[@"name"];
    
            //电桩
            self.chargerNumLab.text=responseObject[@"code"];
            self.chargerEndNameLab.text=responseObject[@"name"];
            self.chargerParkNumLab.text=responseObject[@"parkNo"];
            self.chargerConnectLab.text=responseObject[@"cif"];
            self.chargerTypeLab.text=responseObject[@"ctype"];
            self.chargerStateLab.text=responseObject[@"cstatus"];
            
            
            NSString *type=[NSString stringWithFormat:@"%@",responseObject[@"type"]];
            if ([type isEqualToString:@"DC"]) {
                self.laba.text=@"快";
                self.laba.backgroundColor=[UIColor colorWithRed:0.88 green:0.25 blue:0.31 alpha:1];
            }else{
                self.laba.text=@"慢";
                self.laba.backgroundColor=[UIColor colorWithRed:0.31 green:0.81 blue:0.44 alpha:1];
            }
            
            self.laba.radius=3;
            
            NSString *status=[NSString stringWithFormat:@"%@",responseObject[@"status"]];
            /*
             IDLE OFFLINE REPAIR CHARGING OCCUPIED
             */
            /*
             这里改成根据枪的状态判断
            if (![status isEqualToString:@"IDLE"]) {
                self.startChargingBtn.userInteractionEnabled=NO;
                self.startChargingBtn.backgroundColor=[UIColor lightGrayColor];
            }
             */
            
            if ([status isEqualToString:@"IDLE"]) {
                self.labb.text=@"闲";
            }else if ([status isEqualToString:@"OFFLINE"]){
                self.labb.text=@"离";
            }else if ([status isEqualToString:@"REPAIR"]){
                self.labb.text=@"修";
            }else if ([status isEqualToString:@"CHARGING"]){
                self.labb.text=@"充";
            }else if ([status isEqualToString:@"OCCUPIED"]){
                self.labb.text=@"占";
            }
            self.labb.layer.cornerRadius=3;
            self.labb.layer.masksToBounds=YES;
            self.labb.backgroundColor=[UIColor lightGrayColor];

            
            //3.支持品牌
            NSString *supportCars=responseObject[@"supportCars"];
            if (supportCars.length>0) {
                NSArray * array = [supportCars componentsSeparatedByString:@","];//将字符串整体作为分割条件 返回值为NSArray不可变数组
                self.dataArray3=[NSMutableArray arrayWithArray:array];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
        IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
        [c removeFromSuperview];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 点击立即充电 button
- (IBAction)StartChargingBtnClicked:(UIButton *)sender {
    if ([NSUserDefaults csh_isLogin]==NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要登录才可以进行此操作" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"a");
        }];
        UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self showLoginViewController];
        }];
        [alertController addAction:defaultActiona];
        [alertController addAction:defaultActionb];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
        
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CSHStartChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHStartChargingVC class])];
    //需要加上去
    GunsModel *model=self.dataArray[selectIndexPath.row];
    
   // vc.chargerId=self.chargerId;//桩的id
   // vc.chargerNO=self.chargerNumLab.text;//桩的code
    vc.chargerCode=self.chargerCode;
    vc.chargerConn=model.gunNo;
    
    vc.cif=model.cif;
    vc.voltage=model.voltage;
    vc.power=model.power;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//跳到登录界面
- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
