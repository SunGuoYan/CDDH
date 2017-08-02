//
//  GuidelineVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/12.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "GuidelineVC.h"

@interface GuidelineVC ()

@end

@implementation GuidelineVC


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
    
    self.title = @"操作指引";
    
    [self setGoBackBtnStyle];
    
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    scroll.contentSize=CGSizeMake(screenW, screenW*2565/750);
    scroll.showsVerticalScrollIndicator=NO
    ;
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenW*2565/750)];
    imageV.image=[[UIImage imageNamed:@"operationGuide"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [scroll addSubview:imageV];
    [self.view addSubview:scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
