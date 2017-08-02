//
//  CSHPreferenceTableViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/18/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHPreferenceTableViewController.h"
#import "CSHCarBrandListViewController.h"

@interface CSHPreferenceTableViewController () <CSHCarBrandListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *homeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyAddressTextField;

@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;

@property(nonatomic,copy)NSString *carBrand;


@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation CSHPreferenceTableViewController
-(void)setGoBackBtnStyle{
    
//    [self.navigationItem setHidesBackButton:YES];
    
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
    self.title=@"偏好设置";
    
    self.commitBtn.radius=4;
    
    self.commitBtn.backgroundColor=themeCorlor;
    
    [self setGoBackBtnStyle];
    
    [self checkPreferance];
    
    
}
-(void)checkPreferance{
    NSString *api=@"/api/account/checkPerfrence";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    
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
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.carBrand=responseObject[@"carBrand"];
        
        self.seriesLabel.text=responseObject[@"carBrand"];
        self.companyAddressTextField.text=responseObject[@"compnayAddress"];
        self.homeAddressTextField.text=responseObject[@"homeAddress"];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error：%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - response to behavior

- (IBAction)confirmButton:(UIButton *)sender {
    
    if (self.carBrand==nil) {
        [MBProgressHUD showError:@"请选择汽车品牌！"];
        return;
    }
    [self addPreferance];
}
-(void)addPreferance{
    NSString *api=@"/api/account/addPrefrence";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"carBrand":self.carBrand,@"homeAddress":self.homeAddressTextField.text,@"compnayAddress":self.companyAddressTextField.text};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
//    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation.responseString);//success
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        if ([responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"提交成功！"];
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);//success
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        if ([responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"提交成功！"];
            return ;
        }
        
        [MBProgressHUD showError:@"网络错误！"];
        NSLog(@"error：%@",error);
        
    }];
    
}

#pragma mark --- cell的点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        CSHCarBrandListViewController *brandListViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHCarBrandListViewController class])];
        brandListViewController.delegate = self;
        [self.navigationController pushViewController:brandListViewController animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CSHCarBrandListViewControllerDelegate

-(void)carBrandListViewControllerDidStopWithBrandName:(NSString *)brandName andBrandImageStr:(NSString *)brandImageStr andSeries:(NSString *)series{
    [self.navigationController popToViewController:self animated:YES];
    self.carLogoImageView.image = [UIImage imageNamed:brandImageStr];
    self.seriesLabel.text = series;
    
    self.carBrand=[NSString stringWithFormat:@"%@%@",brandName,series];
}
//- (void)carBrandListViewControllerDidStopWithBrand:(NSString *)brand series:(NSString *)series {
//    [self.navigationController popToViewController:self animated:YES];
//    
//    //TODO: use true data
//    self.carLogoImageView.image = [UIImage imageNamed:@"icon_tesla"];
//    self.seriesLabel.text = series;
//}

@end
