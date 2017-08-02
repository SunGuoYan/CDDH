//
//  LeadViewController.m
//  UITableView联系人作业
//
//  Created by qianfeng on 16/3/11.
//  Copyright (c) 2016年 SunGuoYan. All rights reserved.
//

#import "LeadViewController.h"



@interface LeadViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatLoadScroll];

    
}
-(void)creatLoadScroll
{
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets=NO;
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    for (int i=0; i<4; i++) {
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(i*W, 0, W, H)];
        imageV.image=[UIImage imageNamed:[NSString stringWithFormat:@"lead_%d",i+1]];
        if (i==3) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];

            button.frame=CGRectMake(170, 550, screenW/2, 100);
            button.center=CGPointMake(screenW/2, screenH-50);
//            button.backgroundColor=[UIColor greenColor];
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
            imageV.userInteractionEnabled=YES;
            [imageV addSubview:button];
        }
        [scroll addSubview:imageV];
    }
    scroll.pagingEnabled=YES;
    scroll.delegate=self;
    scroll.contentSize=CGSizeMake(W*4, H);
    [self.view addSubview:scroll];
    
    UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, screenH-50+10, W, 20)];
    page.numberOfPages=4;
    
    
    page.pageIndicatorTintColor=[UIColor lightGrayColor];
    page.currentPageIndicatorTintColor=[UIColor grayColor];//移动的
    page.tag=100;
    [self.view addSubview:page];
}
//page
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat W=self.view.frame.size.width;
    UIPageControl *page=(UIPageControl *)[self.view viewWithTag:100];
    page.currentPage=scrollView.contentOffset.x/W;
}
-(void)buttonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMainVC" object:nil];

}

//保存tabBarde 下标
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setInteger:tabBarController.selectedIndex forKey:@"index"];
    [user synchronize];
}
@end
