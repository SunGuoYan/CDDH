//
//  CSHSettingsViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHSettingsViewController.h"
#import "CSHFeedbackViewController.h"
#import "CSHAboutUsViewController.h"

#import "ServiceCenterVC.h"

@interface CSHSettingsViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>
//注销登录 button
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

//更新
@property(strong,nonatomic)NSString *appLink;
@property(nonatomic,copy)NSString *tip;
@end

@implementation CSHSettingsViewController

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
    self.title = @"设置";
    
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    
    //先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    self.versionLab.text=[NSString stringWithFormat:@"Build Ver_%@",currentVersion];
    
    
    [self setGoBackBtnStyle];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}
#pragma mark ---点击 退出登录按钮
- (IBAction)exitBtnClicked:(UIButton *)sender {
    
    //警告框
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",  nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    alert.tag=271;
    [alert show];
}
//协议函数 响应事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==270) {//检测版本更新
        if (buttonIndex==1) { //ok
            NSString *urlStr=self.appLink;
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
        }else if (buttonIndex==0){//cancel
            if ([self.tip isEqualToString:@"下次再说"]) {
                
            }else if ([self.tip isEqualToString:@"退出"]) {
                exit(0);
            }
        }
    }else if (alertView.tag==271){//退出按钮
        
        if (buttonIndex==1) { //ok
            [self backOut];
        }else if (buttonIndex==0){//cancel
            
        }
    }
    
}
-(void)backOut{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_token"];//作为退出的标志
    [defaults removeObjectForKey:@"accountId"];
    [defaults removeObjectForKey:@"userPhone"];
    [defaults removeObjectForKey:@"userName"];
    [defaults removeObjectForKey:@"userImage"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"accountId"]==nil) {
        self.exitBtn.hidden=YES;
    }else{
        self.exitBtn.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark --- cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //客服中心
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
        ServiceCenterVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ServiceCenterVC class])];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //关于我们
    if (indexPath.section == 0 && indexPath.row == 1) {
        CSHAboutUsViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHAboutUsViewController class])];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    //当前版本
    if (indexPath.section == 1 && indexPath.row == 0) {
        //苹果审核不允许检测版本
//        [self checkAppVersion];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)checkAppVersion{
    NSString *api=@"/api/app/update";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"appType":@(0)};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //先获取当前工程项目版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        
        NSString *serviceVersion=responseObject[@"version"];
        
        self.appLink=[NSString stringWithFormat:@"%@",responseObject[@"appLink"]];
        
        NSString * updateDescr=responseObject[@"updateDescr"];
        NSString * forceUpdate=responseObject[@"forceUpdate"];
        
        NSLog(@"%@---%@---%@",currentVersion,serviceVersion,self.appLink);
        
        NSComparisonResult result=[currentVersion compare:serviceVersion];
        //NSOrderedAscending  实际上线的时候改成ascending
        if (result==NSOrderedAscending) {
            if ([forceUpdate isEqualToString:@"false"]) {//不是强制更新
                self.tip=@"下次再说";
            }else{
                self.tip=@"退出";
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本" message:updateDescr preferredStyle:UIAlertControllerStyleAlert];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            //行间距
            paragraphStyle.lineSpacing = 5.0;
            
            NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSParagraphStyleAttributeName : paragraphStyle};
            NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:updateDescr];
            [attributedTitle addAttributes:attributes range:NSMakeRange(0, updateDescr.length)];
            [alertController setValue:attributedTitle forKey:@"attributedMessage"];//attributedTitle\attributedMessage
            //end ---

            UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:self.tip style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self.tip isEqualToString:@"下次再说"]) {
                    
                }else if ([self.tip isEqualToString:@"退出"]) {
                    exit(0);
                }
            }];
            UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlStr=self.appLink;
                NSLog(@"appLink:%@",self.appLink);
                NSURL *url = [NSURL URLWithString:urlStr];
                [[UIApplication sharedApplication] openURL:url];
                
//                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:defaultActiona];
            [alertController addAction:defaultActionb];
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:alertController animated: YES completion: nil];
            
            
        }else{
            [MBProgressHUD showError:@"当前已是最新版本！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
    
    
}


@end
