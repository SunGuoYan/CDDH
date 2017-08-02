//
//  CSHLoginAndSignupViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/8/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

//登录界面，不带注册字样
//这个界面好像并没有什么用！！！
#import "CSHLoginAndSignupViewController.h"
#import "UIView+CornerRadius.h"
#import "UIButton+CSHLogin.h"
#import "CSHCaptchaViewController.h"

@interface CSHLoginAndSignupViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// for fixing bug: while navigation back from captcha view controller, the phone in text field disappear
@property (copy, nonatomic) NSString *phone;

@end

@implementation CSHLoginAndSignupViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneTextField.delegate = self;
    [self.phoneTextField csh_setDefaultCornerRadius];
    [self.nextButton csh_setDefaultCornerRadius];
    [self.nextButton csh_disableWithLoginAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - response to behavior

- (IBAction)handleQQLoginGesture:(UITapGestureRecognizer *)sender {
}

- (IBAction)handleWeiboLoginGesture:(UITapGestureRecognizer *)sender {
}

- (IBAction)handleWeChatLoginGesture:(UITapGestureRecognizer *)sender {
}

//点击下一步button响应事件
- (IBAction)handleNextButton:(UIButton *)sender {
    
    // hide keyboard
    [self.phoneTextField resignFirstResponder];
    
    // show captcha view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CSHCaptchaViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHCaptchaViewController class])];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - helper

- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    return [phoneTest evaluateWithObject:phoneNumber];
}

#pragma mark - @protocol UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    BOOL isValidText = [self isValidPhoneNumber:text];
    if (!self.nextButton.enabled && isValidText) {
        [self.nextButton csh_enableWithLoginAppearance];
    } else if (self.nextButton.enabled && !isValidText) {
        [self.nextButton csh_disableWithLoginAppearance];
    }
    
    return YES;
}

@end
