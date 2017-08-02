//
//  MessageCell.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/14.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _laba=[[UILabel alloc]init];
        _labb=[[UILabel alloc]init];
        _labc=[[UILabel alloc]init];
        
        _line=[[UIView alloc]init];
        
        [self.contentView addSubview:_laba];
        [self.contentView addSubview:_labb];
        [self.contentView addSubview:_labc];
        
        [self.contentView addSubview:_line];
    }
    return self;
}
-(void)setModel:(MessageModel *)model{
    
    _model=model;
    //1,title
    _laba.font = [UIFont fontWithName:@"Helvetica" size:15];
    _laba.numberOfLines=0;
    _laba.text=model.title;
    
    CGRect framea=[model.title boundingRectWithSize:CGSizeMake(screenW-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _laba.frame=CGRectMake(10, 10, screenW-20, framea.size.height);
    
    //2,time
    _labb.font=[UIFont fontWithName:@"Helvetica" size:12];
    _labb.frame=CGRectMake(10, CGRectGetMaxY(_laba.frame), screenW-20, 30);
    _labb.text=model.time;
    
    //3,content
    _labc.font=[UIFont fontWithName:@"Helvetica" size:12];
    _labc.numberOfLines=0;
    CGRect frameb=[model.content boundingRectWithSize:CGSizeMake(screenW-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _labc.frame=CGRectMake(10, CGRectGetMaxY(_labb.frame), screenW-20, frameb.size.height);
    _labc.text=model.content;
    
    _line.backgroundColor=initialGray;
    _line.frame=CGRectMake(0, CGRectGetMaxY(_labc.frame)+5, screenW, 1);
    
}

@end
