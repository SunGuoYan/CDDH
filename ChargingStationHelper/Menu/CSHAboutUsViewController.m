//
//  CSHAboutUsViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHAboutUsViewController.h"

@interface CSHAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *contactUsButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,copy)NSString *textType;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *url;
@end

@implementation CSHAboutUsViewController

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
    self.view.backgroundColor=bginitialGray;
    self.wechatButton.hidden=YES;
    self.weiboButton.hidden=YES;
    self.contactUsButton.hidden=YES;
    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    _webView.scrollView.bounces=NO;
    [_webView sizeToFit];
    
    [self setGoBackBtnStyle];
    
    self.title = @"关于我们";
    
    [self.appIconImageView csh_setCornerRadius:12.0f];
    [self.wechatButton csh_setDefaultCornerRadius];
    [self.weiboButton csh_setDefaultCornerRadius];
    [self.contactUsButton csh_setDefaultCornerRadius];
    
    //关于我们的h5
    [self checkFourInterface];
}
-(void)checkFourInterface{
    
    NSString *api=@"/api/contents/checklog";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"classification":@"ABOUT"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tempArray=responseObject;
        if (tempArray.count>0) {
            NSDictionary *tempDic=[tempArray  firstObject];
            
            NSString *classification=[NSString stringWithFormat:@"%@",tempDic[@"responseObject"]];
                self.text=tempDic[@"text"];
                self.url=tempDic[@"url"];
                self.textType=tempDic[@"textType"];
                
                [self gotoShowWith:self.text andUrl:self.url andTextType:self.textType];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)gotoShowWith:(NSString *)text andUrl:(NSString *)url andTextType:(NSString *)textType{
    if ([self.textType isEqualToString:@"TEXT"]) {
        [_webView loadHTMLString:self.text baseURL:nil];
    }else if ([self.textType isEqualToString:@"URL"]){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else if ([self.textType isEqualToString:@"IMAGE"]){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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
