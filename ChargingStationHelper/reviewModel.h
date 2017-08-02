//
//  reviewModel.h
//  CommentsDemo
//
//  Created by SunGuoYan on 16/10/24.
//  Copyright © 2016年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reviewModel : NSObject

@property(nonatomic,copy)NSString *avatarStr;//头像 str
@property(nonatomic,copy)NSString *nickname;//昵称
@property(nonatomic,copy)NSString *createdAt;//生成时间
@property(nonatomic,copy)NSString *reviewsStr;//评论内容

@property(nonatomic,strong)NSMutableArray *repliesDataArray;//管理员回复的内容

@end
