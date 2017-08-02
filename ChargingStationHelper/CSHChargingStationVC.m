//
//  CSHChargingStationVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/15.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHChargingStationVC.h"
#import "ShareVC.h"
#import "CollectionImageCell.h"
#import "CommentCell.h"
#import "ChargingListCell.h"
#import "CSHDevice.h"
#import "CSHCharger.h"
#import "CSHChargerDetailVC.h"
#import "CorrectInfoVC.h"
#import "IndicaterView.h"
#import "CSHLoginViewController.h"
#import "reviewModel.h"
#import "SubCell.h"
#import "MJRefresh.h"
#import "GunsModel.h"
#define spaceW 10
#define commonH 15
@interface CSHChargingStationVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UIView *_headerView;
}

@property(nonatomic,strong)UIView *headerContainerView;
@property(nonatomic,strong)UIScrollView *scrollView;


@property(nonatomic,strong) UILabel *infoaLab;
@property(nonatomic,strong) UILabel *infobLab;
@property(nonatomic,strong) UILabel *infocLab;
@property(nonatomic,strong) UILabel *infodLab;
@property(nonatomic,strong) UILabel *infoeLab;
@property(nonatomic,strong) UILabel *infofLab;
@property(nonatomic,strong) UILabel *infogLab;

@property(nonatomic,strong) UIImageView *imagea;
@property(nonatomic,strong) UIImageView *imageb;
@property(nonatomic,strong) UIImageView *imagec;

@property(nonatomic,strong) UILabel *linea;
@property(nonatomic,strong) UILabel *lineb;
@property(nonatomic,strong) UILabel *linec;
@property(nonatomic,strong) UILabel *lined;

//切换slider的button
@property(nonatomic,strong) UIButton *btna;
@property(nonatomic,strong) UIButton *btnb;
@property(nonatomic,strong) UIButton *btnc;

@property(nonatomic,strong) UILabel *sliderLab;
//1,table
@property(nonatomic,strong)UITableView *stationsTable;
@property(nonatomic,strong) UIButton *btnx;
@property(nonatomic,strong) UIButton *btny;
@property(nonatomic,strong) UIButton *btnz;

//2,collection
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong) UIButton *btncollection;
//3,table
@property(nonatomic,strong)UITableView *commentTable;

//当无图片无评论的时候的默认图片
@property(nonatomic,strong)UIImageView *collectionImage;
@property(nonatomic,strong)UIImageView *commentImage;

//table-collection-table的数据源
@property(strong,nonatomic)NSMutableArray *chargerListDataArray;
@property(strong,nonatomic)NSMutableArray *imageListDataArray;
@property(strong,nonatomic)NSMutableArray *commentListDataArray;

//图片的数据源（直接装Urlstring，不装model）
@property(strong,nonatomic)NSMutableArray *imageListStrArray;

@property(strong,nonatomic)UILabel *labelxx;//充电单价
@property(strong,nonatomic)UILabel *labelyy;//停车费
@property(strong,nonatomic)UILabel *labelzz;//营业时间
@property(strong,nonatomic)UILabel *labelmm;//充电桩
@property(strong,nonatomic)UILabel *labelnn;//充电枪
@property(strong,nonatomic)UILabel *labelmn;//空闲枪

@property(strong,nonatomic)UIButton *FavoriteBtn;

//给下个界面 电桩详情传值用的
@property(nonatomic,copy)NSString *stationNameStr;

@property(nonatomic,copy)NSString *theStationIsLovedOrNot;// Y N

@end

@implementation CSHChargingStationVC
-(NSMutableArray *)commentListDataArray{
    if (_commentListDataArray==nil) {
        _commentListDataArray=[[NSMutableArray alloc]init];
    }
    return _commentListDataArray;
}
-(NSMutableArray *)imageListDataArray{
    if (_imageListDataArray==nil) {
        _imageListDataArray=[[NSMutableArray alloc]init];
    }
    return _imageListDataArray;
}
-(NSMutableArray *)chargerListDataArray{
    if (_chargerListDataArray==nil) {
        _chargerListDataArray=[[NSMutableArray alloc]init];
    }
    return _chargerListDataArray;
}

-(NSMutableArray *)imageListStrArray{
    if (_imageListStrArray==nil) {
        _imageListStrArray=[[NSMutableArray alloc]init];
    }
    return _imageListStrArray;
}
#pragma mark ---table的头部视图
-(void)CreatStationsTableHeaderView{
    
    NSInteger textSize=15;  //文字大小
    NSInteger labelW=80;  //
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 145)];
    _headerView.backgroundColor=[UIColor whiteColor];
    //x  充电单价
    UIImageView *imagex=[[UIImageView alloc]initWithFrame:CGRectMake(spaceW, spaceW, commonH, commonH)];
    imagex.image=[UIImage imageNamed:@"jine"];
    [_headerView addSubview:imagex];
    
     UILabel *labelx=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagex.frame)+5, CGRectGetMinY(imagex.frame), labelW, commonH)];
    labelx.text=@"充电单价:";
    labelx.textColor=[UIColor lightGrayColor];
    labelx.textAlignment=NSTextAlignmentCenter;
    labelx.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    [_headerView addSubview:labelx];
    
    self.labelxx=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelx.frame)+spaceW, spaceW, screenW-spaceW-CGRectGetMaxX(labelx.frame), commonH)];
    self.labelxx.text=@"10元/度";
    self.labelxx.font=[UIFont fontWithName:@"Helvetica" size:textSize];
//    self.labelxx.textColor=[UIColor grayColor];
    [_headerView addSubview:self.labelxx];
    
    UILabel *linex=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(imagex.frame)+spaceW, screenW-10, 1)];
    linex.backgroundColor=initialGray;
    [_headerView addSubview:linex];
    
    //y  停 车 费
    UIImageView *imagey=[[UIImageView alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(linex.frame)+spaceW, commonH, commonH)];
    imagey.image=[UIImage imageNamed:@"tingche"];
    [_headerView addSubview:imagey];
    
    UILabel *labely=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagey.frame)+5, CGRectGetMinY(imagey.frame), labelW, commonH)];
    labely.text=@"停  车  费:";
    labely.textColor=[UIColor lightGrayColor];
    labely.textAlignment=NSTextAlignmentCenter;
    labely.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    
    [_headerView addSubview:labely];
    
    self.labelyy=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labely.frame)+spaceW, CGRectGetMinY(imagey.frame), screenW-spaceW-CGRectGetMaxX(labely.frame), commonH)];
    self.labelyy.text=@"免费";
    self.labelyy.font=[UIFont fontWithName:@"Helvetica" size:textSize];
//    self.labelyy.textColor=[UIColor grayColor];
    [_headerView addSubview:self.labelyy];
    
    UILabel *liney=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(imagey.frame)+spaceW, screenW-10, 1)];
    liney.backgroundColor=initialGray;
    [_headerView addSubview:liney];
    
    //z  营业时间
    UIImageView *imagez=[[UIImageView alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(liney.frame)+spaceW, commonH, commonH)];
    imagez.image=[UIImage imageNamed:@"time"];
    [_headerView addSubview:imagez];
    
    UILabel *labelz=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagez.frame)+5, CGRectGetMinY(imagez.frame), labelW, commonH)];
    labelz.text=@"营业时间:";
    labelz.textColor=[UIColor lightGrayColor];
    labelz.textAlignment=NSTextAlignmentCenter;
    labelz.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    [_headerView addSubview:labelz];
    
    self.labelzz=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelz.frame)+spaceW, CGRectGetMinY(imagez.frame), screenW-spaceW-CGRectGetMaxX(labelz.frame), commonH)];
    self.labelzz.text=@"周一至周日 00:00-24:00";
    self.labelzz.font=[UIFont fontWithName:@"Helvetica" size:textSize];
//    self.labelzz.textColor=[UIColor grayColor];
    [_headerView addSubview:self.labelzz];
    
    UILabel *linez=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(imagez.frame)+spaceW, screenW-10, 1)];
    linez.backgroundColor=initialGray;
    [_headerView addSubview:linez];
    
    //add
    UIImageView *imageNum=[[UIImageView alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(linez.frame)+spaceW, commonH, commonH)];
    imageNum.image=[UIImage imageNamed:@"chongdianzhuang"];
    [_headerView addSubview:imageNum];
    
    UILabel *labelm=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageNum.frame)+5, CGRectGetMaxY(linez.frame)+spaceW, 60, commonH)];
    labelm.text=@"充电桩:";
    labelm.textColor=[UIColor lightGrayColor];
    labelm.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    [_headerView addSubview:labelm];
    
    self.labelmm=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelm.frame)+5, CGRectGetMaxY(linez.frame)+spaceW, commonH, commonH)];
    self.labelmm.text=@"0";
    self.labelmm.textColor=themeCorlor;
    self.labelmm.font=[UIFont fontWithName:@"Helvetica" size:12];
    [_headerView addSubview:self.labelmm];
    
    UIImageView *imageV_gun=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.labelmm.frame)+spaceW, CGRectGetMaxY(linez.frame)+spaceW, commonH, commonH)];
    imageV_gun.image=[UIImage imageNamed:@"icon_gun"];
    [_headerView addSubview:imageV_gun];
    
    UILabel *labeln=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV_gun.frame)+5, CGRectGetMaxY(linez.frame)+spaceW, 60, commonH)];
    labeln.text=@"充电枪:";
    labeln.textAlignment=NSTextAlignmentCenter;
    labeln.textColor=[UIColor lightGrayColor];
    labeln.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    [_headerView addSubview:labeln];
    
    self.labelnn=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labeln.frame)+5, CGRectGetMaxY(linez.frame)+spaceW, commonH, commonH)];
    self.labelnn.text=@"0";
    self.labelnn.textColor=themeCorlor;
//    self.labelnn.textAlignment=NSTextAlignmentCenter;
    self.labelnn.font=[UIFont fontWithName:@"Helvetica" size:12];
    [_headerView addSubview:self.labelnn];
    
    UILabel *idleGunLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.labelnn.frame)+spaceW, CGRectGetMaxY(linez.frame)+spaceW, 60, commonH)];
    idleGunLab.text=@"空闲枪：";
    idleGunLab.textAlignment=NSTextAlignmentCenter;
    idleGunLab.textColor=[UIColor lightGrayColor];
    idleGunLab.font=[UIFont fontWithName:@"Helvetica" size:textSize];
    [_headerView addSubview:idleGunLab];
    
    self.labelmn=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(idleGunLab.frame)+5, CGRectGetMaxY(linez.frame)+spaceW, commonH, commonH)];
    self.labelmn.text=@"0";
    self.labelmn.textColor=themeCorlor;
    //    self.labelnn.textAlignment=NSTextAlignmentCenter;
    self.labelmn.font=[UIFont fontWithName:@"Helvetica" size:12];
    [_headerView addSubview:self.labelmn];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (CGFloat)autoWidthString:(NSString *)string withLabel:(UILabel *)label withFont:(NSInteger)font{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size.width;
}
#pragma mark --- 头部概要图 self.headerContainerView
-(void)CreatHeaderContainerViewAndSubView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"充电站详情";
    self.headerContainerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 130)];
    self.headerContainerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.headerContainerView];
    
    //a  电站名
    self.infoaLab=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, spaceW, 100, 20)];
    self.infoaLab.font=[UIFont fontWithName:@"Helvetica" size:18];
    [self.headerContainerView addSubview:self.infoaLab];
    
    
    //b  运营商
    self.infobLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.infoaLab.frame)+spaceW, spaceW, 80, 20)];
    self.infobLab.font=[UIFont fontWithName:@"Helvetica" size:15];
    self.infobLab.textAlignment=NSTextAlignmentCenter;
    self.infobLab.layer.cornerRadius=3;
    self.infobLab.layer.masksToBounds=YES;
    [self.headerContainerView addSubview:self.infobLab];
    //c  地址
    self.infocLab=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(self.infoaLab.frame)+3, screenW-80-spaceW*2, 30)];
    self.infocLab.font=[UIFont fontWithName:@"Helvetica" size:12];
    self.infocLab.numberOfLines=0;
    self.infocLab.textColor=[UIColor lightGrayColor];
    [self.headerContainerView addSubview:self.infocLab];
    
    //d 距离
    self.infodLab=[[UILabel alloc]initWithFrame:CGRectMake(screenW-60, CGRectGetMinY(self.infocLab.frame), 60, 20)];
    self.infodLab.textAlignment=NSTextAlignmentCenter;
    self.infodLab.textColor=[UIColor lightGrayColor];
    self.infodLab.font=[UIFont fontWithName:@"Helvetica" size:12];
    [self.headerContainerView addSubview:self.infodLab];
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(screenW-60-20, CGRectGetMinY(self.infodLab.frame), 20, 20)];
    imageV.image=[UIImage imageNamed:@"distance-location-icon"];
    [self.headerContainerView addSubview:imageV];
    
    CGFloat W= (screenW-20*3-spaceW*7)/3;
    CGFloat Y=CGRectGetMaxY(self.infocLab.frame)+spaceW;
    
    //imagea
    CGFloat imageaW=15;
    self.imagea=[[UIImageView alloc]initWithFrame:CGRectMake(spaceW, Y, imageaW, imageaW)];
    self.imagea.image=[UIImage imageNamed:@"kuaichongmanchong"];
    [self.headerContainerView addSubview:self.imagea];
    //e   快充&慢充
    self.infoeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imagea.frame)+4, Y, W, imageaW)];
    self.infoeLab.textColor=[UIColor lightGrayColor];
    self.infoeLab.font=[UIFont fontWithName:@"Helvetica" size:13];
    [self.headerContainerView addSubview:self.infoeLab];
    
    
    //imageb
    self.imageb=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.infoeLab.frame)+spaceW, Y, imageaW, imageaW)];
    self.imageb.image=[UIImage imageNamed:@"gonggongzhan"];
    [self.headerContainerView addSubview:self.imageb];
    //f  驻地站
    self.infofLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageb.frame)+4, Y, W, imageaW)];
    self.infofLab.textColor=[UIColor lightGrayColor];
    self.infofLab.font=[UIFont fontWithName:@"Helvetica" size:13];
    [self.headerContainerView addSubview:self.infofLab];
    
    
    //imagec  X +spaceW
    self.imagec=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.infofLab.frame), Y, imageaW, imageaW)];
    self.imagec.image=[UIImage imageNamed:@"qitazhifu"];
    [self.headerContainerView addSubview:self.imagec];
    
    //g 其他支付
    self.infogLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imagec.frame)+4, Y, screenW-CGRectGetMaxX(self.imagec.frame)-spaceW, imageaW)];
    self.infogLab.textColor=[UIColor lightGrayColor];
    self.infogLab.font=[UIFont fontWithName:@"Helvetica" size:12];
    [self.headerContainerView addSubview:self.infogLab];
    
    //liena
    self.linea=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(self.infogLab.frame)+spaceW, screenW-spaceW*2, 1)];
    self.linea.backgroundColor=initialGray;
    [self.headerContainerView addSubview:self.linea];
    
    //btna  详情 button
    CGFloat btnY=CGRectGetMaxY(self.linea.frame)+spaceW;
    CGFloat btnW=(screenW-4)/3;
    CGFloat btnH=20;
    self.btna=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btna.frame=CGRectMake(spaceW, btnY, btnW, btnH);
    [self.btna setTitle:@"详情" forState:UIControlStateNormal];
    [self.btna addTarget:self action:@selector(btnaClicked) forControlEvents:UIControlEventTouchUpInside];
    self.btna.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    [self.headerContainerView addSubview:self.btna];
    //lienb
    self.lineb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btna.frame), btnY+2, 1, btnH-4)];
    self.lineb.backgroundColor=initialGray;
    [self.headerContainerView addSubview:self.lineb];
    
    //btnb   图片 button
    self.btnb=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnb.frame=CGRectMake(CGRectGetMaxX(self.lineb.frame), btnY, btnW, btnH);
    [self.btnb setTitle:@"实景" forState:UIControlStateNormal];
    [self.btnb addTarget:self action:@selector(btnbClicked) forControlEvents:UIControlEventTouchUpInside];
    self.btnb.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    [self.headerContainerView addSubview:self.btnb];
    //lienc
    self.linec=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btnb.frame), btnY+2, 1, btnH-4)];
    self.linec.backgroundColor=initialGray;
    [self.headerContainerView addSubview:self.linec];
    
    //btnc   评论 button
    self.btnc=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnc.frame=CGRectMake(CGRectGetMaxX(self.linec.frame), btnY, btnW, btnH);
    [self.btnc setTitle:@"评论" forState:UIControlStateNormal];
    [self.btnc addTarget:self action:@selector(btncClicked) forControlEvents:UIControlEventTouchUpInside];
    self.btnc.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    [self.headerContainerView addSubview:self.btnc];
    //liend
    self.lined=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(self.btna.frame)+spaceW, screenW-spaceW*2, 1)];
    self.lined.backgroundColor=initialGray;
    [self.headerContainerView addSubview:self.lined];
    
    //slider  滑块
    //+CGRectGetWidth(self.btna.frame)/6
    self.sliderLab=[[UILabel alloc]initWithFrame:CGRectMake(spaceW, CGRectGetMaxY(self.btna.frame)+2, CGRectGetWidth(self.btna.frame), 2)];
    
    [self.headerContainerView addSubview:self.sliderLab];
}

-(void)initialWitnTextAndCorlor{
    self.infoaLab.text=@"东湖景园";
    self.infobLab.text=@"亨通光电";
    self.infobLab.textColor=themeCorlor;
    self.infobLab.layer.borderColor=themeCorlor.CGColor;
    self.infobLab.layer.borderWidth=1;
    
    self.infocLab.text=@"武汉市洪山区东湖景园小区A栋";
    self.infodLab.text=@"11.2Km";
    self.infoeLab.text=@"快充&慢充";
    self.infofLab.text=@"公共站";
    self.infogLab.text=@"App&刷卡充电";
    
    self.sliderLab.backgroundColor=themeCorlor;
    
    [self.btna setTitleColor:themeCorlor forState:UIControlStateNormal];
    [self.btnb setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnc setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
-(void)CreatFourScroll{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerContainerView.frame), screenW, screenH-CGRectGetMaxY(self.headerContainerView.frame))];
    
    [self.view addSubview:self.scrollView];
    CGFloat scrollH=self.scrollView.frame.size.height;
    
    //scroll
    self.scrollView.contentSize=CGSizeMake(screenW*3, scrollH);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.backgroundColor=[UIColor whiteColor];
    self.scrollView.delegate=self;
    self.scrollView.bounces=NO;
    
    
#pragma mark --- 1,tableView
    self.stationsTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, scrollH-64-50)];
    self.stationsTable.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    self.stationsTable.backgroundColor=[UIColor whiteColor];
    self.stationsTable.delegate=self;
    self.stationsTable.dataSource=self;
    self.stationsTable.bounces=NO;
    self.stationsTable.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.stationsTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.scrollView addSubview:self.stationsTable];
    
    //1
    self.btnx=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnx.frame=CGRectMake(0+10, CGRectGetMaxY(self.stationsTable.frame), screenW-20, 50-6);
    self.btnx.backgroundColor=themeBlue;
    
    self.btnx.radius=4;
    
    [self.btnx setTitle:@"导航" forState:UIControlStateNormal];
    self.btnx.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:20];
    
    [self.btnx addTarget:self action:@selector(btnxClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.btnx];
    
    //2
    self.btny.hidden=YES;
    
    self.btny=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btny.frame=CGRectMake(screenW/3, CGRectGetMaxY(self.stationsTable.frame), screenW/3, 50);
//    self.btny.backgroundColor=[UIColor greenColor];
    self.btny.backgroundColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    
    [self.btny setTitle:@"纠错" forState:UIControlStateNormal];
    [self.btny addTarget:self action:@selector(btnyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.btny];
    
    //3
    self.btnz.hidden=YES;
    self.btnz=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnz.frame=CGRectMake(screenW/3*2, CGRectGetMaxY(self.stationsTable.frame), screenW/3, 50);
    self.btnz.backgroundColor=[UIColor lightGrayColor];
    [self.btnz setTitle:@"我要预约" forState:UIControlStateNormal];
    [self.btnz addTarget:self action:@selector(btnzClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.btnz];
    
    [self.btny removeFromSuperview];
    [self.btnz removeFromSuperview];
    
    
#pragma mark --- 2,collectionView
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    CGFloat itemW=(screenW-30)/2;
    
    flow.itemSize=CGSizeMake(itemW, itemW*2/3);
    flow.minimumInteritemSpacing=10;
    flow.minimumLineSpacing=10;
    flow.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(screenW, 0, screenW, scrollH-64) collectionViewLayout:flow];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.bounces=NO;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:self.collectionView];
    
    //无图形时的默认图形
    self.collectionImage=[[UIImageView alloc]initWithFrame:CGRectMake(screenW, 0, (scrollH-64)/2, (scrollH-64)/2)];
    self.collectionImage.center=CGPointMake(screenW/2+screenW, (scrollH-64)/2-20);
    [self.scrollView addSubview:self.collectionImage];
    
    
    //去掉了上传图片的button collectionView的高度要变
    self.btncollection=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btncollection.backgroundColor=[UIColor purpleColor];
    self.btncollection.frame=CGRectMake(CGRectGetMinX(self.collectionView.frame), CGRectGetMaxY(self.collectionView.frame), screenW, 50);
    [self.btncollection setTitle:@"上传图片" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.btncollection];
    self.btncollection.hidden=YES;
    
    [self.collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
    
#pragma mark --- 3,tableView
    
    self.commentTable=[[UITableView alloc]initWithFrame:CGRectMake(screenW*2, 0, screenW, scrollH-64) style:UITableViewStyleGrouped];
//    self.commentTable=[[UITableView alloc]initWithFrame:CGRectMake(screenW*2, 0, screenW, screenW)];
    self.commentTable.backgroundColor=[UIColor whiteColor];
    self.commentTable.delegate=self;
    self.commentTable.dataSource=self;
//    self.commentTable.bounces=NO;
    self.commentTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.commentTable.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);
    self.commentTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.scrollView addSubview:self.commentTable];
    
    self.commentTable.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.page=0;
        [self.commentListDataArray removeAllObjects];
        [self getOneStationComments];
    }];
    
    self.commentImage=[[UIImageView alloc]initWithFrame:CGRectMake(screenW*2, 0, (scrollH-64)/2, (scrollH-64)/2)];
    self.commentImage.center=CGPointMake(screenW/2+screenW*2, (scrollH-64)/2-20);
    [self.scrollView addSubview:self.commentImage];
}
#pragma mark --- 点击导航
-(void)btnxClicked{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigation" object:nil userInfo:@{@"latitude":self.latitude,@"longitude":self.longitude}];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigation" object:nil];
    
}
-(void)btnyClick{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Charging" bundle:nil];
    CorrectInfoVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CorrectInfoVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}
//我要预约
-(void)btnzClicked{
}
#pragma mark --- 评论的数据源
-(void)getOneStationComments{
    NSString *api=@"/api/stations/check";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"stationId":self.stationId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"accountId"]!=nil) {
        //如果登陆
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *token=[defaults objectForKey:@"access_token"];
        NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
        [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    }
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tempArray=responseObject;
        if (tempArray.count>0) {
            
            for (NSDictionary *tempDic in tempArray) {
                
                reviewModel *model=[[reviewModel alloc]init];
                
                NSDictionary *account=tempDic[@"account"];
                NSString *avatar=[NSString stringWithFormat:@"%@",account[@"avatar"]];
                if ([avatar isEqualToString:@"<null>"]) {
                    avatar=@"cddh";
                }
                model.avatarStr=avatar;
                
                NSString *nickname=[NSString stringWithFormat:@"%@",account[@"nickname"]];
//                if ([nickname isEqualToString:@"<null>"]) {
//                    nickname=@"用户";
//                }
                model.nickname=nickname;
                model.createdAt=tempDic[@"createdAt"];
                model.reviewsStr=tempDic[@"content"];
                
                model.repliesDataArray=[[NSMutableArray alloc]init];
                
                NSArray *repliesArray=tempDic[@"replies"];
                for (NSDictionary *repliesDic in repliesArray) {
                    NSString *content=repliesDic[@"content"];
                    [model.repliesDataArray addObject:content];
                }
                [self.commentListDataArray addObject:model];
            }
        }else{
            self.commentImage.image=[UIImage imageNamed:@"NoComments"];
        }
        
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.commentTable.mj_header isRefreshing]) {
                [self.commentTable.mj_header endRefreshing];
            }
            
            [self.commentTable reloadData];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"a");
    }];
}
#pragma mark ---电站详情(数据源)
-(void)getOneStation{
    NSString *api=nil;
    
    if ([NSUserDefaults csh_isLogin]==NO) {//如果没登录
        api=[NSString stringWithFormat:@"/api/stations/%@",self.stationId];
    }else{//登录
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *accountId=[defaults objectForKey:@"userid"];
        
        api=[NSString stringWithFormat:@"/api/stations/%@?accountId=%@",self.stationId,accountId];
    }
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempDic=responseObject;
        if (tempDic!=nil) {
            
            IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
            [c removeFromSuperview];
            
            CSHDevice *device=[CSHDevice new];
            
            //获得电站的经纬度
            CSHCoordinatePoint *coordinate = [CSHCoordinatePoint new];
            NSNumber *lon=tempDic[@"longitude"];
            NSNumber *lat=tempDic[@"latitude"];
            coordinate.longitude=lon.doubleValue;
            coordinate.latitude=lat.doubleValue;
            device.coordinatePoint=coordinate;
            
            //如果是从list列表进来的详情页（另一种是从设备概要图进来的）
            if(self.latitude==nil){
                self.latitude=[NSString stringWithFormat:@"%@",tempDic[@"latitude"]];
                self.longitude=[NSString stringWithFormat:@"%@",tempDic[@"longitude"]];
            }
            
            device.name=tempDic[@"name"];
            device.operatorName=tempDic[@"operator"][@"name"];
            
            device.totalCount=[NSString stringWithFormat:@"%@",tempDic[@"totalCount"]];
            device.totalGuns=[NSString stringWithFormat:@"%@",tempDic[@"totalGuns"]];
            device.totalIdelCung=[NSString stringWithFormat:@"%@",tempDic[@"totalIdelCung"]];
            
            NSString *collected=[NSString stringWithFormat:@"%@",responseObject[@"collected"]];
            if ([collected isEqualToString:@"N"]) {//用户没有收藏
                [self.FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
                self.theStationIsLovedOrNot=@"N";
            }else{
                [self.FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
                self.theStationIsLovedOrNot=@"Y";
            }
            
//           paymentMethod : "OTHER"
            device.stype=[NSString stringWithFormat:@"%@",tempDic[@"stype"]];//
            device.atype=[NSString stringWithFormat:@"%@",tempDic[@"atype"]];
            device.ctype=[NSString stringWithFormat:@"%@",tempDic[@"ctype"]];//
            device.payType=[NSString stringWithFormat:@"%@",tempDic[@"payType"]];//
            device.address=tempDic[@"location"];
            
            device.priceStr=[NSString stringWithFormat:@"%@",tempDic[@"price"]];
            device.feeStr=[NSString stringWithFormat:@"%@",tempDic[@"fee"]];
            device.openTime=[NSString stringWithFormat:@"%@",tempDic[@"openTime"]];
            
            device.chargesDataArray=[[NSMutableArray alloc]init];
#pragma mark ---电桩的数组(数据源)
            NSArray *tempArray=tempDic[@"chargers"];
            if (tempArray.count>0) {
                for (NSDictionary *chargerDic in tempArray) {
                    CSHCharger *model=[[CSHCharger alloc]init];
                    
                    model.idStr=[NSString stringWithFormat:@"%@",chargerDic[@"id"]];//id
                    model.code=[NSString stringWithFormat:@"%@",chargerDic[@"code"]];//编号
                    model.name=chargerDic[@"name"];//名称
                    model.parkNo=[NSString stringWithFormat:@"%@",chargerDic[@"parkNo"]];//车位号
                    model.cif=[NSString stringWithFormat:@"%@",chargerDic[@"cif"]];//国标直流枪
                    model.cstatus=chargerDic[@"cstatus"];
                    
                    model.power=[NSString stringWithFormat:@"%@",chargerDic[@"power"]];//功率
                    model.voltage=[NSString stringWithFormat:@"%@",chargerDic[@"voltage"]];//电压
                    model.type=[NSString stringWithFormat:@"%@",chargerDic[@"type"]];
                    
                    model.ctype=[NSString stringWithFormat:@"%@",chargerDic[@"ctype"]];
                    model.supportCars=[NSString stringWithFormat:@"%@",chargerDic[@"supportCars"]];
                    model.price=[NSString stringWithFormat:@"%@",chargerDic[@"price"]];
                    
                    //电枪的集合
                    model.gunsNameArray=[[NSMutableArray alloc]init];
                    model.gunsStatuesArray=[[NSMutableArray alloc]init];
                    
                    NSArray *gunArray=chargerDic[@"guns"];
                
                    for (NSDictionary *gunTempDic in gunArray) {
                        /*
                        GunsModel *gunModel=[[GunsModel alloc] init];
                        gunModel.gunName=gunTempDic[@"gunName"];
                        gunModel.status=gunTempDic[@"status"];
                        [model.gunsArray addObject:gunModel];
                        */
                        
                        [model.gunsNameArray addObject:gunTempDic[@"gunName"]];
                        NSString *status=gunTempDic[@"cstatus"];
                        /*
                        if ([status isEqualToString:@"IDLE"]) {
                            status=@"闲";
                        }else if ([status isEqualToString:@"OFFLINE"]){
                            status=@"离";
                        }else if ([status isEqualToString:@"REPAIR"]){
                            status=@"修";
                        }else if ([status isEqualToString:@"CHARGING"]){
                            status=@"充";
                        }else if ([status isEqualToString:@"OCCUPIED"]){
                            status=@"占";
                        }
                         */
                        
                        [model.gunsStatuesArray addObject:status];
                    }
                    
                    [self.chargerListDataArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.stationsTable reloadData];
                });
            }
            
#pragma mark ---图片的数组（数据源）
            NSArray *tempImageArray=tempDic[@"images"];
            if (tempImageArray.count>0) {
                for (NSDictionary *tempImageDic in tempImageArray) {
                    CSHPublicModel *model=[[CSHPublicModel alloc]init];
                    model.imageUrlStr=tempImageDic[@"src"];
                    
                    [self.imageListDataArray addObject:model];
                    [self.imageListStrArray addObject:model.imageUrlStr];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }else{
                self.collectionImage.image=[UIImage imageNamed:@"NoImages"];
            }
            
#pragma mark ---图片的数组（数据源）(接口缺少此字段)
            
#pragma mark ---评论的数组（数据源）  //单独的接口
            
            [self configureWithDevice:device];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
        [c removeFromSuperview];
        [MBProgressHUD showError:@"加载失败"];
    }];
}
#pragma mark - 详情界面的赋值
- (void)configureWithDevice:(CSHDevice *)device {
    self.stationNameStr=device.name;
    //
    self.infoaLab.text = device.name;
#pragma mark --- 电站名的重新设置frame
    [self.infoaLab setFrame:CGRectMake(spaceW, spaceW, [self autoWidthString:device.name withLabel:self.infoaLab withFont:18]+5, 20)];
    
    self.infocLab.text = device.address;
    
    //这个方法来计算定位的位置与电站的距离
    CLLocationDistance distance = [self.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:device.coordinatePoint.latitude longitude:device.coordinatePoint.longitude]];
    
    self.infodLab.text = distance > 1000 ? [NSString stringWithFormat:@"%.1f km", distance / 1000.0f] : [NSString stringWithFormat:@"%.1f m", distance];
    
    self.infobLab.text=device.operatorName;
#pragma mark --- 电站名的重新设置frame
    [self.infobLab setFrame:CGRectMake(CGRectGetMaxX(self.infoaLab.frame)+spaceW, spaceW, [self autoWidthString:device.operatorName withLabel:self.infobLab withFont:18], 20)];

    
    self.infoeLab.text=device.ctype;
    self.infofLab.text=device.stype;
    CGFloat fW=[self autoWidthString:device.stype withLabel:self.infofLab withFont:15];
    [self.infofLab setFrame:CGRectMake(screenW/2-fW/2, CGRectGetMaxY(self.infocLab.frame)+10, fW, 15)];
    [self.imageb setFrame:CGRectMake(screenW/2-fW/2-15-4, CGRectGetMaxY(self.infocLab.frame)+spaceW, 15, 15)];
    
    
    self.infogLab.text=device.payType;
    CGFloat gW=[self autoWidthString:device.payType withLabel:self.infogLab withFont:13];
    [self.infogLab setFrame:CGRectMake(screenW-gW, CGRectGetMaxY(self.infocLab.frame)+10, gW, 15)];
    
    [self.imagec setFrame:CGRectMake(screenW-gW-15-4, CGRectGetMaxY(self.infocLab.frame)+spaceW, 15, 15)];
    
    //充电单价
    self.labelxx.text=[NSString stringWithFormat:@"%@",device.priceStr];
    //停车费
    self.labelyy.text=[NSString stringWithFormat:@"%@",device.feeStr];
    //营业时间
    self.labelzz.text=device.openTime;
    //电桩数量
    self.labelmm.text=device.totalCount;
    //总电枪
    self.labelnn.text=device.totalGuns;
    //空闲电枪
    self.labelmn.text=device.totalIdelCung;
    
}

-(void)CreatFavoriteAndShareBtn{
    //收藏
    self.FavoriteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.FavoriteBtn.frame=CGRectMake(30, 30, 20, 20);
    [self.FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
    [self.FavoriteBtn addTarget:self action:@selector(FavoriteBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *FavoriteBtnItem=[[UIBarButtonItem alloc]initWithCustomView:self.FavoriteBtn];
    
    //间距
    UIButton *spaceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    spaceBtn.frame=CGRectMake(30, 30, 6, 10);
    UIBarButtonItem *spaceBtnItem=[[UIBarButtonItem alloc]initWithCustomView:spaceBtn];
    
    //分享
    UIButton *ShareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ShareBtn.frame=CGRectMake(30, 30, 20, 20);
    [ShareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share_normal"] forState:UIControlStateNormal];
    [ShareBtn addTarget:self action:@selector(ShareBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ShareBtnItem=[[UIBarButtonItem alloc]initWithCustomView:ShareBtn];
    self.navigationItem.rightBarButtonItems=@[ShareBtnItem,spaceBtnItem,FavoriteBtnItem];
}
- (void)showLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    CSHLoginViewController *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHLoginViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}
//警告框协议函数 响应事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==260){// 收藏的弹出框
        if (buttonIndex==1) { //ok
            
            [self showLoginViewController];
            
        }else if (buttonIndex==0){//cancel
            
        }
    }
    
}
#pragma mark ---- 点击右上角收藏
-(void)FavoriteBtnClcik{
    
    if ([NSUserDefaults csh_isLogin]==NO) {
        
        [self showLoginViewController];
        return;
    }
    if ([self.theStationIsLovedOrNot isEqualToString:@"N"]) {
        [self addFavoriteStation];
    }else{
        [self cancelFavoriteStation];
    }
    self.FavoriteBtn.selected=!self.FavoriteBtn.selected;
}
#pragma mark --- 点击右上角分享按钮
-(void)ShareBtnClcik{
    
    ShareVC *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ShareVC class])];
    viewController.stationId=self.stationId;
    viewController.longitude=self.longitude.doubleValue;
    viewController.latitude=self.latitude.doubleValue;
    
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)addFavoriteStation{
    NSString *api=@"/api/account/like";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"objectId":self.stationId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation PUT:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([operation.responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"收藏成功"];
            [self.FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_press"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"Y";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self judgeTokenWith:operation];
    }];
}
-(void)cancelFavoriteStation{
    NSString *api=@"/api/account/like";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"objectId":self.stationId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation DELETE:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"取消收藏成功"];
            [self.FavoriteBtn setBackgroundImage:[UIImage imageNamed:@"icon_favs_normal"] forState:UIControlStateNormal];
            self.theStationIsLovedOrNot=@"N";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self judgeTokenWith:operation];
    }];
}
-(void)judgeTokenWith:(AFHTTPRequestOperation *)operation{
    NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
    NSData *jsonData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSString *message=dic[@"error"];
    
    if ([message isEqualToString:@"invalid_token"]) {
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"access_token"];//作为退出的标志
        [defaults removeObjectForKey:@"accountId"];
        [defaults removeObjectForKey:@"userPhone"];
        [defaults removeObjectForKey:@"userName"];
        [defaults removeObjectForKey:@"userImage"];
        [defaults synchronize];
        
        //1,
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号已过期，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"a");
        }];
        UIAlertAction *defaultActionb = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self showLoginViewController];
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:defaultActiona];
        [alertController addAction:defaultActionb];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
    }
    /*
     (lldb) po operation.response.statusCode
     401
     (lldb) po operation.responseString
     {"error":"invalid_token","error_description":"Cannot convert access token to JSON"}
     */
    
    
}
-(void)setGoBackBtnStyle{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [self setGoBackBtnStyle];
    
    self.theStationIsLovedOrNot=@"N";
    
    [super viewDidLoad];
    
    [self CreatFavoriteAndShareBtn];
    
    
    [self CreatHeaderContainerViewAndSubView];
    
    [self CreatStationsTableHeaderView];
    
    [self initialWitnTextAndCorlor];
    
    
    [self CreatFourScroll];
    
    [self getOneStationComments];
    
    [self getOneStation];
    
    IndicaterView *c=[[IndicaterView alloc]initWithFrame:self.view.bounds];
    c.tag=100;
    //也可以添加到keyWindow 上
//    [[UIApplication sharedApplication].keyWindow addSubview:c];
    [self.view addSubview:c];
}

#pragma mark --- 点击三个按钮切换界面
-(void)btnaClicked{
    [self stateWithBtn:self.btna];
}
-(void)btnbClicked{
    [self stateWithBtn:self.btnb];
}
-(void)btncClicked{
    [self stateWithBtn:self.btnc];
}
-(void)stateWithBtn:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
    
        self.btna.titleLabel.textColor=[UIColor lightGrayColor];
        self.btnb.titleLabel.textColor=[UIColor lightGrayColor];
        self.btnc.titleLabel.textColor=[UIColor lightGrayColor];
        
        NSInteger num=0;
        if (sender==self.btna) {
            num=0;
            [self.btna setTitleColor:themeCorlor forState:UIControlStateNormal];
            
        }else if (sender==self.btnb) {
            num=1;
           [self.btnb setTitleColor:themeCorlor forState:UIControlStateNormal];
        }else if (sender==self.btnc){
            num=2;
            [self.btnc setTitleColor:themeCorlor forState:UIControlStateNormal];
        }
        self.scrollView.contentOffset=CGPointMake(screenW*num, 0);
        
        self.sliderLab.center=CGPointMake(sender.center.x, self.sliderLab.center.y);
    }];
}

#pragma mark --- scroll 的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        if (self.scrollView.contentOffset.x==0) {

            [self stateWithBtn:self.btna];
            self.btna.titleLabel.textColor=themeCorlor;
            
        }else if (self.scrollView.contentOffset.x==screenW){

            [self stateWithBtn:self.btnb];
            self.btnb.titleLabel.textColor=themeCorlor;
        }else if (self.scrollView.contentOffset.x==screenW*2){

            [self stateWithBtn:self.btnc];
            self.btnc.titleLabel.textColor=themeCorlor;
        }
    }else if (scrollView.tag==110){//相册的scroll
        UIPageControl *page=(UIPageControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:111];
//        UIPageControl *page=(UIPageControl *)[self.view viewWithTag:111];
        page.currentPage=scrollView.contentOffset.x/screenW;
    }
}


#pragma mark --- table 的三个方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==self.stationsTable) {
        return 1;
    }else if (tableView==self.commentTable){
        return self.commentListDataArray.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.stationsTable) {
        
        return self.chargerListDataArray.count;

    }else if (tableView==self.commentTable){
        reviewModel *model=self.commentListDataArray[section];
        return model.repliesDataArray.count;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.stationsTable) {//电桩列表
        
       static NSString *stationsTableID=@"ChargingListCell";
        ChargingListCell *cell=[tableView dequeueReusableCellWithIdentifier:stationsTableID];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ChargingListCell" owner:self options:nil] firstObject];
        }
    
        cell.numberLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        CSHCharger *model=self.chargerListDataArray[indexPath.row];
        
        //1
        cell.laba.text=[NSString stringWithFormat:@"编    号：%@",model.code];
        NSMutableAttributedString *attrStra = [[NSMutableAttributedString alloc] initWithString:cell.laba.text];
        //attrStr添加文字颜色
        [attrStra addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:NSMakeRange(0, 7)];
        cell.laba.attributedText = attrStra;
        
        
        //2
        cell.labb.text=[NSString stringWithFormat:@"名    称：%@",model.name];
        NSMutableAttributedString *attrStrb = [[NSMutableAttributedString alloc] initWithString:cell.labb.text];
        //attrStr添加文字颜色
        [attrStrb addAttribute:NSForegroundColorAttributeName
                         value:[UIColor lightGrayColor]
                         range:NSMakeRange(0, 7)];
        cell.labb.attributedText = attrStrb;
        /*
        //1
        cell.labc.text=[NSString stringWithFormat:@"车位号：%@",model.parkNo];
        NSMutableAttributedString *attrStrc = [[NSMutableAttributedString alloc] initWithString:cell.labc.text];
        //attrStr添加文字颜色
        [attrStrc addAttribute:NSForegroundColorAttributeName
                         value:[UIColor lightGrayColor]
                         range:NSMakeRange(0, 4)];
        cell.labc.attributedText = attrStrc;
        
        cell.labd.text=[NSString stringWithFormat:@"%@（%@）%@",model.cif,model.voltage,model.power];
         */
        
        //type  AC 慢
        cell.labe.text=model.type;
        
        if ([model.type isEqualToString:@"DC"]) {
            cell.labe.text=@"快";
            cell.labe.backgroundColor=[UIColor colorWithRed:0.88 green:0.25 blue:0.31 alpha:1];
        }else{
            cell.labe.text=@"慢";
            cell.labe.backgroundColor=[UIColor colorWithRed:0.31 green:0.81 blue:0.44 alpha:1];
        }
        cell.labe.layer.cornerRadius=3;
        cell.labe.layer.masksToBounds=YES;
        
        cell.qiangA.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[0],model.gunsStatuesArray[0]];
        
        switch (model.gunsNameArray.count) {
            case 1:
                cell.qiangB.hidden=YES;
                cell.qiangC.hidden=YES;
                cell.qiangD.hidden=YES;
                break;
            case 2:
                cell.qiangB.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[1],model.gunsStatuesArray[1]];
                cell.qiangC.hidden=YES;
                cell.qiangD.hidden=YES;
                break;
            case 3:
                cell.qiangB.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[1],model.gunsStatuesArray[1]];
                cell.qiangC.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[2],model.gunsStatuesArray[2]];
                cell.qiangD.hidden=YES;
                break;
            case 4:
                cell.qiangB.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[1],model.gunsStatuesArray[1]];
                cell.qiangC.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[2],model.gunsStatuesArray[2]];
                cell.qiangD.text=[NSString stringWithFormat:@"%@:%@",model.gunsNameArray[3],model.gunsStatuesArray[3]];
                break;
                
            default:
                break;
        }
        
        //cell.labf.text=model.cstatus;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView==self.commentTable){//评论的table
        
        static NSString *cellID=@"cellID";//静态变量，只分配一次内存空间
        SubCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {//设置cell为Default样式时，subtitle无法显示，需要设置为subtitle样式
            cell=[[SubCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        
        reviewModel *model=self.commentListDataArray[indexPath.section];
        cell.commentsText=model.repliesDataArray[indexPath.row];
        cell.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
       
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.stationsTable) {
        CSHCharger *model=self.chargerListDataArray[indexPath.row];
        //目前只做4个电枪
        if (model.gunsNameArray.count<3) {
            return 60+15;
        }else if (model.gunsNameArray.count<5){
            return 60+15+15;
        }
        
    }else if (tableView==self.commentTable){
        
        reviewModel *model=self.commentListDataArray[indexPath.section];
        NSString *commentsText=model.repliesDataArray[indexPath.row];
        CGFloat W=[UIScreen mainScreen].bounds.size.width;
        CGRect frame=[commentsText boundingRectWithSize:CGSizeMake(W-140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        return frame.size.height+10+5;
    }
    return 44;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.stationsTable) {
        return 145;
    }else if (tableView==self.commentTable){
        CGFloat W=[UIScreen mainScreen].bounds.size.width;
        reviewModel *model=self.commentListDataArray[section];
        CGRect frame=[model.reviewsStr boundingRectWithSize:CGSizeMake(W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return 50+frame.size.height+1;
    }
    return 0;
    
}
//#pragma mark----设置分组尾部标题的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //设置 return 0 无效 仍会有高度
    
    
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.stationsTable) {
   
        return _headerView;
    }else if (tableView==self.commentTable){
        
        CGFloat W=[UIScreen mainScreen].bounds.size.width;
        //
        reviewModel *model=self.commentListDataArray[section];
        
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
        bg.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 0, W-20, 1)];
        line.backgroundColor=[UIColor lightGrayColor];
        [bg addSubview:line];
        
        //1 用户头像
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.avatarStr] placeholderImage:[UIImage imageNamed:@"cddh"]];
        [bg addSubview:imageV];
        
        //2 用户nickname
        UILabel *nickLab=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, W-50, 10)];
        nickLab.text=model.nickname;
        nickLab.font=[UIFont boldSystemFontOfSize:12];
        [bg addSubview:nickLab];
        
        //3 用户评论时间
        UILabel *createdAt=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, W-50, 10)];
        createdAt.text=model.createdAt;
        createdAt.font=[UIFont boldSystemFontOfSize:12];
        createdAt.textColor=[UIColor grayColor];
        [bg addSubview:createdAt];
        
        //4 用户评论内容
        CGRect frame=[model.reviewsStr boundingRectWithSize:CGSizeMake(W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        
        UILabel *reviewsLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, W-20, frame.size.height)];
        reviewsLab.font=[UIFont boldSystemFontOfSize:15];
        reviewsLab.numberOfLines=0;
        reviewsLab.textColor=[UIColor grayColor];
        reviewsLab.text=model.reviewsStr;
        [bg addSubview:reviewsLab];
        
        
        return bg;
    }
    return nil;
}
#pragma mark --- cell 的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.stationsTable) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSHChargerDetailVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargerDetailVC class])];
        CSHCharger *model=self.chargerListDataArray[indexPath.row];
        vc.chargerCode=model.code;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark --- collection 的三个方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageListDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionImageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    CSHPublicModel *model=self.imageListDataArray[indexPath.row];
    
    NSURL *url=[NSURL URLWithString:model.imageUrlStr];

    [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cddh"]];
    
    return cell;
    
}
#pragma mark --- collection 的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld-%ld",indexPath.section,indexPath.row);
    
        UIView *blackBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        blackBg.tag=100;
        blackBg.backgroundColor=[UIColor blackColor];
        [[UIApplication sharedApplication].keyWindow addSubview:blackBg];
    
    
        NSInteger count=self.imageListStrArray.count;
        
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        scrollView.contentSize=CGSizeMake(screenW*count, screenW);
        scrollView.contentOffset=CGPointMake(screenW*indexPath.row, 0);
        scrollView.bounces=NO;
        scrollView.pagingEnabled=YES;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.tag=110;
        scrollView.delegate=self;
        [blackBg addSubview:scrollView];
        
        for (int i=0; i<count; i++) {
//            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(i*screenW, screenH/2-screenW/2, screenW, screenW)];
            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(i*screenW, 0, screenW, screenH)];
            NSURL *url=[NSURL URLWithString:self.imageListStrArray[i]];
            [imageV sd_setImageWithURL:url];
            
            [imageV setContentMode:UIViewContentModeScaleAspectFit];
            [scrollView addSubview:imageV];
            
            //捏合手势
            UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
            pinch.delegate=self;
            imageV.userInteractionEnabled=YES;
            [imageV addGestureRecognizer:pinch];
            
            //移动手势
//            UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//            [imageV addGestureRecognizer:pan];
            
        }
        
        UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame)-40,screenW , 40)];
        page.numberOfPages=count;
        //当前页 0开始
        //    page.hidesForSinglePage=YES;
        //    page.currentPage=2;
        page.tag=111;
        page.currentPage=indexPath.row;
        page.pageIndicatorTintColor=[UIColor grayColor];
        page.currentPageIndicatorTintColor=[UIColor whiteColor];
        [blackBg addSubview:page];
        
        
        //点击手势
        UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
        //设置点击次数
        tapOne.numberOfTapsRequired=1;//默认1
        //设置手指个数
        tapOne.numberOfTouchesRequired=1;//默认1
        [blackBg addGestureRecognizer:tapOne];
 
}
-(void)tapOne:(UITapGestureRecognizer *)tap//单击
{
    
    //相对于某一个视图 获取手势点击的位置
    CGPoint point=[tap locationInView:tap.view];
    //tap.view  通过这个属性我们可以获得添加此手势的视图
    NSLog(@"%@---%@",tap.view,NSStringFromCGPoint(point));
    
    UIView *c=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
    [c removeFromSuperview];
}
-(void)pinch:(UIPinchGestureRecognizer *)pinch
{
    UIImageView *c=(UIImageView *)pinch.view;
    CGFloat scale=pinch.scale;
    c.transform=CGAffineTransformScale(c.transform, scale, scale);
    pinch.scale=1;
}
//平移手势
-(void)pan:(UIPanGestureRecognizer *)pan
{
    UIImageView *view=(UIImageView *)pan.view;
    if (view.frame.size.width>screenW) {
        //获得偏移量
        CGPoint point=[pan translationInView:self.view];
        
        view.center=CGPointMake(point.x+view.center.x, point.y+view.center.y);
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
