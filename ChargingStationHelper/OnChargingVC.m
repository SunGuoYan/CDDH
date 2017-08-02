//
//  OnChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/19.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "OnChargingVC.h"
#import "EndChargingVC.h"

@interface OnChargingVC ()
//
@property (weak, nonatomic) IBOutlet UIView *bigContainerView;

@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;
@property (weak, nonatomic) IBOutlet UILabel *labd;

@property (weak, nonatomic) IBOutlet UILabel *labe;

@property (weak, nonatomic) IBOutlet UILabel *labf;


//
@property (weak, nonatomic) IBOutlet UIImageView *animationImageVa;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageVb;

@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *endChargingBtn;

@end

@implementation OnChargingVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.endChargingBtn.radius=50;
    
    self.endChargingBtn.backgroundColor=[UIColor cyanColor];
    self.animationImageVb.hidden=YES;
    self.animationImageVa.image=[UIImage imageNamed:@"scratch_00"];
    
    NSMutableArray *imageArray=[[NSMutableArray alloc]init];
    for (int i=0; i<56; i++) {
        NSString *imageNameStr=@"";
        if (i<10) {
            imageNameStr=[NSString stringWithFormat:@"scratch_0%d.jpg",i];
        }else{
            imageNameStr=[NSString stringWithFormat:@"scratch_%d.jpg",i];
        }
        UIImage *image=[UIImage imageNamed:imageNameStr];
        [imageArray addObject:image];
    }
    self.animationImageVa.animationImages=imageArray;
    self.animationImageVa.animationDuration=5.6;
    self.animationImageVa.animationRepeatCount=CGFLOAT_MAX;
    [self.animationImageVa startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)endChargingBtnClicked:(UIButton *)sender {
    [self.animationImageVa stopAnimating];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EndChargingVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EndChargingVC class])];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
