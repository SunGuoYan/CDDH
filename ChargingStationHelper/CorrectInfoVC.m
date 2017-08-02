//
//  CorrectInfoVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/9/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CorrectInfoVC.h"

@interface CorrectInfoVC ()
//
//
@property (weak, nonatomic) IBOutlet UIImageView *imagea;

@property (weak, nonatomic) IBOutlet UILabel *laba;

@property (weak, nonatomic) IBOutlet UIButton *btna;
@property (weak, nonatomic) IBOutlet UIButton *btnb;
@property (weak, nonatomic) IBOutlet UIButton *btnc;

@property (weak, nonatomic) IBOutlet UIButton *btnd;
@property (weak, nonatomic) IBOutlet UIButton *btne;
@property (weak, nonatomic) IBOutlet UIButton *btnf;

@property (weak, nonatomic) IBOutlet UIButton *btngg;



@property (weak, nonatomic) IBOutlet UITextView *textViewa;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;
//

@end

@implementation CorrectInfoVC


- (IBAction)commitButtonClicked:(UIButton *)sender {
    
    [MBProgressHUD showError:@"提交成功"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btna.backgroundColor=initialGray;
    self.btnb.backgroundColor=initialGray;
    self.btnc.backgroundColor=initialGray;
    self.btnd.backgroundColor=initialGray;
    self.btne.backgroundColor=initialGray;
    self.btnf.backgroundColor=initialGray;
    self.btngg.backgroundColor=initialGray;
    
    self.title=@"我要纠错";
    self.view.backgroundColor=initialGray;
    self.commitButton.backgroundColor=themeCorlor;
    
    
}
- (IBAction)btnaClicked:(UIButton *)sender {
    if (!self.btna.selected) {
        self.btna.backgroundColor=themeCorlor;
    }else{
        self.btna.backgroundColor=initialGray;
    }
    self.btna.selected=!self.btna.selected;
    
}
- (IBAction)btnbClicked:(UIButton *)sender {
    if (!self.btnb.selected) {
        self.btnb.backgroundColor=themeCorlor;
    }else{
        self.btnb.backgroundColor=initialGray;
    }
    self.btnb.selected=!self.btnb.selected;
}
- (IBAction)btncClicked:(UIButton *)sender {
    if (!self.btnc.selected) {
        self.btnc.backgroundColor=themeCorlor;
    }else{
        self.btnc.backgroundColor=initialGray;
    }
    self.btnc.selected=!self.btnc.selected;
}
- (IBAction)btndClicked:(UIButton *)sender {
    if (!self.btnd.selected) {
        self.btnd.backgroundColor=themeCorlor;
    }else{
        self.btnd.backgroundColor=initialGray;
    }
    self.btnd.selected=!self.btnd.selected;
}
- (IBAction)btneClicked:(UIButton *)sender {
    if (!self.btne.selected) {
        self.btne.backgroundColor=themeCorlor;
    }else{
        self.btne.backgroundColor=initialGray;
    }
    self.btne.selected=!self.btne.selected;
}
- (IBAction)btnfClicked:(UIButton *)sender {
    if (!self.btnf.selected) {
        self.btnf.backgroundColor=themeCorlor;
    }else{
        self.btnf.backgroundColor=initialGray;
    }
    self.btnf.selected=!self.btnf.selected;
}



- (IBAction)btnggClicked:(UIButton *)sender {
    if (!self.btngg.selected) {
        self.btngg.backgroundColor=themeCorlor;
    }else{
        self.btngg.backgroundColor=initialGray;
    }
    self.btngg.selected=!self.btngg.selected;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
