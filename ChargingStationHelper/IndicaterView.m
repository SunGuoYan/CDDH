//
//  IndicaterView.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/8.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "IndicaterView.h"

@implementation IndicaterView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *grayBackground=[[UIView alloc]initWithFrame:frame];
        grayBackground.userInteractionEnabled=YES;
        grayBackground.backgroundColor=[UIColor whiteColor];
//        grayBackground.backgroundColor=[UIColor grayColor];
//        grayBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:grayBackground];
        
        _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 96*8/13)];
        _imageV.center=CGPointMake(screenW/2, screenH/2-64);
        //_imageV.image=[UIImage imageNamed:@"progress001"];
        [grayBackground addSubview:_imageV ];
        
        
        CSHPublicModel *singler=[CSHPublicModel shareSingleton];
        _imageV.animationImages =singler.imagesArray ;
        _imageV.animationDuration = 2.0f;
        _imageV.animationRepeatCount = CGFLOAT_MAX;
        
        //开始等待加载符
      //  _imageV.hidden = NO;
        [_imageV startAnimating];
    }
    return self;
}

@end
