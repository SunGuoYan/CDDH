//
//  SubCell.h
//  CommentsDemo
//
//  Created by SunGuoYan on 16/10/25.
//  Copyright © 2016年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reviewModel.h"
@interface SubCell : UITableViewCell
@property(nonatomic,strong)UILabel *subName;
@property(nonatomic,strong)UILabel *subComments;

@property(nonatomic,copy)NSString *commentsText;


@end
