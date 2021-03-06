//
//  CSHChargingStationTableViewCell.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/4/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHChargingStationTableViewCell.h"
#import "UIColor+CSH.h"
#import "CSHDevice.h"
#import <CoreLocation/CoreLocation.h>

@interface CSHChargingStationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//对外开放
@property (weak, nonatomic) IBOutlet UILabel *attributeLabel;

//已联网
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

//预约按钮
@property (weak, nonatomic) IBOutlet UIButton *bookingButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//公共站 驻地站
@property (weak, nonatomic) IBOutlet UIView *attributeLabelContainer;
//亨通光电  运营商
@property (weak, nonatomic) IBOutlet UIView *statusLabelContainer;

@end

@implementation CSHChargingStationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bookingButton.hidden=YES;
    
    self.bookingButton.radius=4;
    
    self.bookingButton.backgroundColor = [UIColor csh_activeColor];
    
    //公共站
    [self.attributeLabel setTextColor:themeBlue];
    
    self.attributeLabelContainer.radius=3;
    [self.attributeLabelContainer setBorderWithColor:themeBlue andWidth:1.0f];
    
    
    
    //运营商
    /*
     [UIColor colorWithRed:0.35 green:0.85 blue:0.47 alpha:1]
     */
    [self.statusLabel setTextColor:themeCorlor];
    self.statusLabelContainer.layer.borderColor = themeCorlor.CGColor;
    self.statusLabelContainer.layer.borderWidth = 1.0f;
    self.statusLabelContainer.layer.cornerRadius=3;
    self.statusLabelContainer.layer.masksToBounds=YES;
    
    
    self.nameLabel.text = @"东亚望京中心";
    self.attributeLabel.text = @"对外开放";
    self.statusLabel.text = @"亨通光电";
    self.addressLabel.text = @"朝阳区广顺南大街望京园401号";
    self.detailLabel.text = @"共3个电桩 2个空闲";
    self.distanceLabel.text = @"17.2km";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//对cell的赋值  device为请求回来的，location为自己经纬度
- (void)configureWithDevice:(CSHDevice *)device userLocation:(CLLocation *)location {
    
    self.nameLabel.text = device.name;
    
    self.attributeLabel.text = device.stype;
    self.statusLabel.text=device.operatorName;
    
    self.detailLabel.text = [NSString stringWithFormat:@"共%@个电桩    %@个空闲",device.totalCount,device.idleCount];
    
//    self.statusLabel.text = device.isCertified ? @"已验证" : @"未认证";
    self.addressLabel.text = device.address;
    
    //属性 共多少个电桩 空多少个
//    self.detailLabel.attributedText = [self detailAttributedStringWithCount:device.count];
//    self.bookingButton.enabled = device.isOnline;
    
    //CLLocation * 自带计算长度的方法
    CLLocationDistance distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:device.coordinatePoint.latitude longitude:device.coordinatePoint.longitude]];
    
    self.distanceLabel.text = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];
}

- (NSAttributedString *)detailAttributedStringWithCount:(NSNumber *)count {
    NSMutableAttributedString *detailAttributedString = [[NSMutableAttributedString alloc] initWithString:@"共" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Neue" size:13.0f]}];
    
    [detailAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:count.stringValue attributes:@{NSForegroundColorAttributeName: [UIColor csh_brandColor],NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Neue" size:13.0f]}]];
    
    [detailAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"个电桩" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Neue" size:13.0f]}]];
    
    return [detailAttributedString copy];
}

#pragma mark - cell上面的  预约 响应事件
- (IBAction)handleNavigationButton:(UIButton *)sender {
    [self.delegate chargingStationTableViewCellNavigationButtonTapped:self];
}

- (IBAction)handleLikeButton:(UIButton *)sender {
}

@end
