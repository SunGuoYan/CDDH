//
//  CSHCharger.h
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/13.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHCharger : NSObject
@property(nonatomic,copy)NSString *certified;
@property(nonatomic,copy)NSString *chargeIf;
@property(nonatomic,copy)NSString *cif;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *createdAt;
@property(nonatomic,copy)NSString *cstatus;
@property(nonatomic,copy)NSString *ctype;

@property(nonatomic,copy)NSString *descriptionStr;
@property(nonatomic,copy)NSString *idStr;

@property(nonatomic,copy)NSString *electricity;

@property(nonatomic,copy)NSString *manufacturer;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *onlined;
@property(nonatomic,copy)NSString *onorder;
@property(nonatomic,copy)NSString *parkNo;
@property(nonatomic,copy)NSString *power;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *priceTemplate;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *supportCars;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *updatedAt;
@property(nonatomic,copy)NSString *voltage;

@property(nonatomic,strong)NSMutableArray *gunsNameArray;
@property(nonatomic,strong)NSMutableArray *gunsStatuesArray;
@end
