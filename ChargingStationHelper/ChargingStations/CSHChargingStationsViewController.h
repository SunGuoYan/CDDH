//
//  CSHChargingStationsViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//搜索界面 UIViewController上放两个table
#import <UIKit/UIKit.h>

@class CLLocation;

//这里有个协议 首页CSHMapViewController实现的方法，在此界面中右上角点击地图的时候调用，就是pop返回到首页
@protocol CSHChargingStationsViewControllerDelegate <NSObject>

- (void)chargingStationsViewControllerDidStop;

@end

@interface CSHChargingStationsViewController : UIViewController

@property (nonatomic, weak) id <CSHChargingStationsViewControllerDelegate> delegate;

//正向传值

//从map传过来的时候，请求设备列表的时候需要定位者的信息
@property (nonatomic, strong) CLLocation *location;
//从map传过来的时候，点击关键字搜索的？？？
@property (nonatomic, strong) NSString *keyword;

//点击首页textField 的button  正向传值传过来的 NO
//通过这个来判断弹出的 是stations列表 还是搜索界面
@property (nonatomic, assign) BOOL shouldBeginEditing; // should edit keywords

@end