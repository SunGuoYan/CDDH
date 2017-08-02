//
//  IWAreaPickerView.h
//  IWanna
//
//  Created by Mini on 16/9/12.
//  Copyright © 2016年 huangshaobin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IWAreaPickerViewConfirmBlock)(NSString *provinceStr,NSString *cityStr,NSString *districtStr);
typedef void(^IWAreaPickerViewCancleBlock)();

@interface IWAreaPickerView : UIView

@property (nonatomic,copy) NSDictionary *areaDict;
//确认回调
@property (nonatomic,copy) IWAreaPickerViewConfirmBlock areaPickerViewConfirmBlock;
//失败回调
@property (nonatomic,copy) IWAreaPickerViewCancleBlock areaPickerViewCancleBlock;

@end
