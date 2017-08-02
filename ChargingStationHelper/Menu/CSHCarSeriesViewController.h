//
//  CSHCarSeriesTableViewController.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/18/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSHCarSeriesViewControllerDelegate <NSObject>

- (void)carSeriesViewControllerDidStopWithSeries:(NSString *)series;

@end

@interface CSHCarSeriesViewController : UITableViewController

//这两个属性用于正向传值
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSArray<NSString *> *series;

@property (nonatomic, weak) id <CSHCarSeriesViewControllerDelegate> delegate;

@end
