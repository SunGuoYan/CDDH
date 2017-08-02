//
//  CSHCaptchaViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//


//登录界面 带输入验证码字样

//输入验证码captcha登录界面
#import "CSHCaptchaViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"

@interface CSHCaptchaViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation CSHCaptchaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.captchaTextField.delegate = self;
    [self.captchaTextField csh_setDefaultCornerRadius];
    [self.loginButton csh_setDefaultCornerRadius];
    [self.loginButton csh_disableWithLoginAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - @protocol UITextFieldDelegate
//输入验证内容，改变button的颜色，但是这里的button并没有点击事件
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    BOOL isValidText = text.length > 0;
    if (!self.loginButton.enabled && isValidText) {
        [self.loginButton csh_enableWithLoginAppearance];
    } else if (self.loginButton.enabled && !isValidText) {
        [self.loginButton csh_disableWithLoginAppearance];
    }
    
    return YES;
}

@end
