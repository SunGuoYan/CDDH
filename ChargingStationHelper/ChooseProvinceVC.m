//
//  ChooseProvinceVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/12/15.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ChooseProvinceVC.h"
#import "IWAreaPickerView.h"

@interface ChooseProvinceVC ()

@property (nonatomic,strong) IWAreaPickerView *areaPickerView;
@end

@implementation ChooseProvinceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, screenH-216, self.view.frame.size.width, 216)];
    
    __weak typeof(self) weakSelf = self;
    
    //点击成功的回调
    self.areaPickerView.areaPickerViewConfirmBlock=^(NSString *provinceStr,NSString *cityStr,NSString *districtStr){
        
        weakSelf.myBlcok(provinceStr,cityStr,districtStr);
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.areaPickerView.areaPickerViewCancleBlock=^(){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    
    [self.view addSubview:_areaPickerView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
