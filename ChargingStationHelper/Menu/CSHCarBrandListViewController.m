//
//  CSHCarBrandListViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/18/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHCarBrandListViewController.h"
#import "CSHCarBrandTableViewCell.h"
#import "CSHCarSeriesViewController.h"

@interface CSHCarBrandListViewController () <CSHCarSeriesViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//车品牌name
@property (nonatomic, copy) NSString *selectedBrand;
//车品牌imageStr
@property (nonatomic, copy) NSString *selectedBrandImageStr;


@property(nonatomic,strong)NSMutableArray *carIconArray;
@property(nonatomic,strong)NSMutableArray *carNameArray;

@property(nonatomic,strong)NSMutableArray *seriesArray;//车系 二维数组
@end

@implementation CSHCarBrandListViewController

-(NSMutableArray *)seriesArray{
    if (_seriesArray==nil) {
        _seriesArray=[[NSMutableArray alloc]init];
    }
    return _seriesArray;
}
-(NSMutableArray *)carIconArray{
    if (_carIconArray==nil) {
        _carIconArray=[[NSMutableArray alloc]init];
    }
    return _carIconArray;
}
-(NSMutableArray *)carNameArray{
    if (_carNameArray==nil) {
        _carNameArray=[[NSMutableArray alloc]init];
    }
    return _carNameArray;
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
    
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *carIconArray=@[@"icon_baw",@"icon_bmw",@"icon_byd",@"icon_chana",@"icon_chevrolet",@"icon_denza",@"icon_jac",@"icon_roewe",@"icon_tesla",@"icon_venucia",@"icon_zd"];
    NSArray *carNameArray=@[@"北汽",@"宝马",@"比亚迪",@"长安",@"雪佛兰",@"腾势",@"江淮",@"荣威",@"特斯拉",@"启辰",@"知豆"];
    
    self.carIconArray=[NSMutableArray arrayWithArray:carIconArray];
    self.carNameArray=[NSMutableArray arrayWithArray:carNameArray];
    
    //车系
    //北汽
    NSArray *array1=@[@"北汽E150EV",@"北汽EV160",@"北汽EV200",@"ES210(绅宝EV)",@"eu260",@"ex200",];
    //宝马
    NSArray *array2=@[@"530Le",@"740Li hybrid",@"Active Hybrid 5",@"Active Hybrid 3",@"i8",@"X6 Hybrid"];
    //比亚迪
    NSArray *array3=@[@"秦",@"e6",@"F3DM",@"唐",@"腾势",@"秦EV300"];
    //长安
    NSArray *array4=@[@"长安逸动"];
    //雪佛兰
    NSArray *array5=@[@"xuefulan 1",@"xuefulan 2",@"xuefulan 3"];
    //腾势
    NSArray *array6=@[@"腾势"];
    //江淮
    NSArray *array7=@[@"iev4",@"iev5",@"iev6s"];
    //荣威
    NSArray *array8=@[@"荣威750",@"荣威E50",@"荣威e550",@"荣威e950"];
    //特斯拉
    NSArray *array9=@[@"特斯拉",@"特斯拉",@"特斯拉"];
    //启辰
    NSArray *array10=@[@"启辰"];
    //知豆
    NSArray *array11=@[@"知豆",@"知豆"];
    
    [self.seriesArray addObject:array1];
    [self.seriesArray addObject:array2];
    [self.seriesArray addObject:array3];
    [self.seriesArray addObject:array4];
    [self.seriesArray addObject:array5];
    [self.seriesArray addObject:array6];
    [self.seriesArray addObject:array7];
    [self.seriesArray addObject:array8];
    [self.seriesArray addObject:array9];
    [self.seriesArray addObject:array10];
    [self.seriesArray addObject:array11];
    
    
    self.title = @"请选择";
    
    [self setGoBackBtnStyle];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carIconArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSHCarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CSHCarBrandTableViewCell class]) forIndexPath:indexPath];
    cell.logoImageView.image=[UIImage imageNamed:self.carIconArray[indexPath.row]];
    cell.brandLabel.text = self.carNameArray[indexPath.row];
    
    return cell;
}

#pragma mark ---- cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSHCarBrandTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedBrand = self.carNameArray[indexPath.row];
    self.selectedBrandImageStr=self.carIconArray[indexPath.row];
//    self.selectedBrand = cell.brandLabel.text;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    CSHCarSeriesViewController *carSeriesViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHCarSeriesViewController class])];
    carSeriesViewController.delegate = self;
    //TODO: change to real data
    carSeriesViewController.brand=self.carNameArray[indexPath.row];
    carSeriesViewController.series=self.seriesArray[indexPath.row];
    
    [self.navigationController pushViewController:carSeriesViewController animated:YES];
}

#pragma mark - CSHCarSeriesViewControllerDelegate

//实现series里面的方法，接受delegate传过来的series
//brand再一次启动delegate 把brand和serie传个 DrierCertificate
- (void)carSeriesViewControllerDidStopWithSeries:(NSString *)series {
    [self.delegate carBrandListViewControllerDidStopWithBrandName:self.selectedBrand andBrandImageStr:self.selectedBrandImageStr andSeries:series];
//    [self.delegate carBrandListViewControllerDidStopWithBrand:self.selectedBrand series:series];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
