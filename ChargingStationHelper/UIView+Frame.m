//
//  UIView+Frame.m
//  Creator
//
//  Created by 邹吕 on 15/3/1.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

//setter getter
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;//取出来  frame
    frame.origin.x = x;//修改
    self.frame = frame;//还回去
}
- (CGFloat)x
{
    return self.frame.origin.x;
}


//setter getter
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

//setter getter
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}
//setter getter
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
//setter getter
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
//setter getter
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

//setter getter
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
//setter getter
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

//setter getter
-(void)setRadius:(CGFloat)radius{
    self.layer.cornerRadius=radius;
    self.layer.masksToBounds=YES;
}
-(CGFloat)radius{
    return self.layer.cornerRadius;
}
-(void)setBorderWithColor:(UIColor *)color andWidth:(CGFloat)width
{
    self.layer.borderColor=color.CGColor;
    self.layer.borderWidth=width;
}
@end
