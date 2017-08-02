//
//  CSHFeedbackViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/28/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHFeedbackViewController.h"

@interface CSHFeedbackViewController ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation CSHFeedbackViewController

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
    [super viewDidLoad];
    [self setGoBackBtnStyle];
    
    self.title = @"意见反馈";
    self.textView.delegate=self;
    
    self.commitBtn.backgroundColor=themeCorlor;
    self.commitBtn.radius=4;
}
-(void)addQuestion{
    
    NSString *api=@"/api/feedBacks/add";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"content":self.textView.text,@"channel":@"APP",@"category":@"APP"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        if ([responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"提交成功！"];
            return ;
        }
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);//success
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        if ([responseString isEqualToString:@"success"]) {
            [MBProgressHUD showError:@"提交成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        NSLog(@"error：%@",error);
        
    }];
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
    [self addQuestion];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.text=@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
