//
//  CSHPublicModel.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHPublicModel : NSObject

@property(nonatomic,copy)NSString *imageUrlStr;
@property(nonatomic,strong)NSMutableArray<UIImage *> *imagesArray;

+(instancetype)shareSingleton;

@end
