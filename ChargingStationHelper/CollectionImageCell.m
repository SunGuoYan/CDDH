//
//  CollectionImageCell.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/15.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CollectionImageCell.h"

@implementation CollectionImageCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageV];
        
    }
    return self;
}
@end
