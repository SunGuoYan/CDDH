//
//  CSHChargingStationTableViewCell.h
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//搜做结果对应的的list的cell
//搜做结果table对应的cell（带 预约 字样）
//他这里并没有用xib画cell，而是画在了storyboard上面
#import <UIKit/UIKit.h>

@class CSHChargingStationTableViewCell;
@class CSHDevice;
@class CLLocation;

@protocol CSHChargingStationTableViewCellDelegate <NSObject>

- (void)chargingStationTableViewCellNavigationButtonTapped:(CSHChargingStationTableViewCell *)cell;

@end

@interface CSHChargingStationTableViewCell : UITableViewCell

@property (nonatomic, weak) id <CSHChargingStationTableViewCellDelegate> delegate;

//cell的赋值，传入设备填充cell，
- (void)configureWithDevice:(CSHDevice *)device userLocation:(CLLocation *)location;

@end
