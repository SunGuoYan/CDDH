//
//  ActivityVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/1.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ActivityVC.h"

@interface ActivityVC ()

@end

@implementation ActivityVC
-(void)setGoBackBtnStyle{
    
    [self setHidesBottomBarWhenPushed:YES];
    
//    [self.navigationItem setHidesBackButton:YES];
    
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
    [self setGoBackBtnStyle];
    self.title=self.navigationTitle;
    
    if ([self.navigationTitle isEqualToString:@"我的反馈"]) {
        UILabel *contentLab=[[UILabel alloc]init];
        CGRect frame=[self.content boundingRectWithSize:CGSizeMake(screenW-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        contentLab.font = [UIFont fontWithName:@"Helvetica" size:15];
//        contentLab.font=[UIFont boldSystemFontOfSize:15];
        contentLab.frame=CGRectMake(10, 10, screenW-20, frame.size.height);
        contentLab.text=[NSString stringWithFormat:@"反馈问题：%@",self.content];
        contentLab.numberOfLines=0;
        [self.view addSubview:contentLab];
        
        UIWebView * _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLab.frame)+10, screenW, screenH-64-CGRectGetMaxY(contentLab.frame))];
        _webView.scrollView.bounces=NO;
        [_webView sizeToFit];
        [self.view addSubview:_webView];
        
        if ([self.textType isEqualToString:@"TEXT"]) {
            [_webView loadHTMLString:self.text baseURL:nil];
        }else if ([self.textType isEqualToString:@"URL"]){
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }else if ([self.textType isEqualToString:@"IMAGE"]){
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
        
        return;
    }
    
    
    UIWebView * _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    _webView.scrollView.bounces=NO;
    [_webView sizeToFit];
    [self.view addSubview:_webView];
    
    
    //  http://
    NSMutableString *openUrl=[NSMutableString stringWithFormat:@"%@",self.url];
    if (![self.url hasPrefix:@"http"]) {
        [openUrl insertString:@"http://" atIndex:0];
    }
     
    
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
