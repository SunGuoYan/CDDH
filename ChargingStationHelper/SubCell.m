//
//  SubCell.m
//  CommentsDemo
//
//  Created by SunGuoYan on 16/10/25.
//  Copyright © 2016年 SunGuoYan. All rights reserved.
//

#import "SubCell.h"

@implementation SubCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _subName=[[UILabel alloc]init];
        _subComments=[[UILabel alloc]init];
        _subComments.numberOfLines=0;
        
        [self.contentView addSubview:_subName];
        [self.contentView addSubview:_subComments];
        
    }
    return self;
}
-(void)setCommentsText:(NSString *)commentsText{
    _subName.frame=CGRectMake(30, 10, 100,15);
    _subName.text=@"管理员回复：";
    _subName.textAlignment=NSTextAlignmentRight;
    _subName.font=[UIFont boldSystemFontOfSize:12];
    
    CGFloat W=[UIScreen mainScreen].bounds.size.width;
    CGRect frame=[commentsText boundingRectWithSize:CGSizeMake(W-140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _subComments.frame=CGRectMake(130, 10, W-140, frame.size.height);
    _subComments.font=[UIFont boldSystemFontOfSize:12];
    _subComments.textColor=[UIColor grayColor];
    _subComments.text=commentsText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
