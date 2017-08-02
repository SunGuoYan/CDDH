//
//  CSHDeviceAnnotationView.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/10/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHDeviceAnnotationView.h"
#import "CSHDeviceAnnotation.h"
#import "CSHDevice.h"

@interface CSHDeviceAnnotationView ()

@property (nonatomic, strong) UIImageView *animationImageView;

@end

@implementation CSHDeviceAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self addSubview:self.animationImageView];  //3-1
        [self layoutIfNeeded];
        
//        [self updateImage];
    }
    return self;
}
//点击大头针MKAnnotationView的时候会调用的方法
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
//        self.image = nil;  //3-4
        
//        self.animationImageView.hidden = NO;       //3-2
//        self.animationImageView.animationImages = [self animatedImages];//调用自己的方法 动态图
//        [self.animationImageView startAnimating];//开启动画
        
    } else {
        [self updateImage];
        
//        [self.animationImageView stopAnimating];   //3-3
//        self.animationImageView.hidden = YES;
        
    }
}

//设置animationImageView的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationImageView.frame = CGRectMake(-2, -10, CGRectGetWidth(self.bounds) + 4, CGRectGetHeight(self.bounds) + 4);
}
/*  以上均是重写父类的方法  */

//自己写的方法 返回图片数组 UIImageView播放的时候需要的图片源
- (NSArray<UIImage *>*)animatedImages {
    if (![self.annotation isKindOfClass:[CSHDeviceAnnotation class]]) {
        return nil;
    }
    
    //拿到大头针所对应的device
    CSHDevice *device = ((CSHDeviceAnnotation *)self.annotation).device;
    
    NSString *imageNameString = @"green_";
    if (device.isOnline) {
        imageNameString = @"green_";
    } else if (device.isCertified) {
        imageNameString = @"green_";
    }
    
    NSMutableArray *animatedImages = [NSMutableArray new];
    for (NSInteger i = 1; i <= 20; i++) {
        if (i < 6) {
            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageNameString, @(i).stringValue]]];
        } else if (i<11){
            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageNameString, @(11-i).stringValue]]];
        }else if(i<16){//1-5
            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageNameString, @(i-10).stringValue]]];
        }else if (i<21){//5-1
            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageNameString, @(21-i).stringValue]]];
        }
    }
    
    
//    NSString *imageNameString = @"white_";
//    if (device.isOnline) {
//        imageNameString = @"red_";
//    } else if (device.isCertified) {
//        imageNameString = @"blue_";
//    }
//    
//    NSMutableArray *animatedImages = [NSMutableArray new];
//    for (NSInteger i = 0; i <= 60; i++) {
//        if (i < 10) {
//            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@0%@", imageNameString, @(i).stringValue]]];
//        } else {
//            [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageNameString, @(i).stringValue]]];
//        }
//    }
    
    return [animatedImages copy];
}
//

//为annotationView设置图片
//self.image 和 self.bounds  当前类继承自MKAnnotationView，父类的属性
//根据device的不同状态将annotationView设置成 红 蓝 白色
- (void)updateImage {
    
    if (![self.annotation isKindOfClass:[CSHDeviceAnnotation class]]) {
        return;//如果不是CSHDeviceAnnotation类的话就返回nil
    }
    
    CSHDevice *device = ((CSHDeviceAnnotation *)self.annotation).device;
    double rate =(device.idleCount.doubleValue)/(device.totalCount.doubleValue);
    NSLog(@"%f",rate);
    //真正多的时候是根据这个rate的范围来确认图片的颜色
    
    //主线程里面更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (device.idleCount.doubleValue>0) {
            self.image = [UIImage imageNamed:@"green_5"];
        }else{
            self.image = [UIImage imageNamed:@"red"];
        }
        
        self.bounds = CGRectMake(0, 0, 67/2, 92/2);
    });
    
    
    
//    if (device.isOnline) {
//        self.image = [UIImage imageNamed:@"green_5"];
//    } else if (device.isCertified) {
//        self.image = [UIImage imageNamed:@"green_5"];
//    } else {
//        self.image = [UIImage imageNamed:@"green_1"];
//    }
    
    
}
//懒加载 用于播放动画
//重写了属性animationImageView的getter方法
- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.hidden = YES;
        _animationImageView.animationDuration = 3.0;
        _animationImageView.animationRepeatCount = CGFLOAT_MAX;
    }
    return _animationImageView;
}

//重写了属性device的getter方法
//返回annotation对应的device
- (CSHDevice *)device {
    if (![self.annotation isKindOfClass:[CSHDeviceAnnotation class]]) {
        return nil;//如果当前annotation不是device的annotation，就返回nil
    }
    //是的话，就返回annotation对应的device
    //这里的self.annotation是id任意类型，准守MKAnnotation协议即可
    return ((CSHDeviceAnnotation *)self.annotation).device;
}

@end
