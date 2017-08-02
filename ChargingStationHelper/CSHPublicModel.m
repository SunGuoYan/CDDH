//
//  CSHPublicModel.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHPublicModel.h"

@implementation CSHPublicModel
+(instancetype)shareSingleton{
    static CSHPublicModel *single = nil;
    if (single==nil) {
        single=[[CSHPublicModel alloc]init];
        NSArray<NSString *> *imageNames = @[@"progress001", @"progress002", @"progress003", @"progress004", @"progress005", @"progress006", @"progress007", @"progress008", @"progress009", @"progress010", @"progress011", @"progress012", @"progress013", @"progress014", @"progress015", @"progress016", @"progress017", @"progress018", @"progress019", @"progress020", @"progress021", @"progress022", @"progress023", @"progress024", @"progress025", @"progress026", @"progress027", @"progress028", @"progress029", @"progress030", @"progress031", @"progress032", @"progress033", @"progress034", @"progress035", @"progress036", @"progress037", @"progress038", @"progress039", @"progress040", @"progress041", @"progress042", @"progress043", @"progress044", @"progress045", @"progress046", @"progress047", @"progress048", @"progress049", @"progress050", @"progress051", @"progress052", @"progress053", @"progress054", @"progress055", @"progress056", @"progress057", @"progress058", @"progress059", @"progress060"];
        NSMutableArray<UIImage *> *images = [@[] mutableCopy];
        for (NSString *name in imageNames) {
            [images addObject:[UIImage imageNamed:name]];
        }
        single.imagesArray=images;
    }
    return single;
}


@end
