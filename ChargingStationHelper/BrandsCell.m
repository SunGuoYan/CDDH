//
//  BrandsCell.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/2.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "BrandsCell.h"

@implementation BrandsCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        _lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _lab.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_lab];
    }
    return self;
}
@end
