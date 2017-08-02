//
//  CSHEndChargingVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/17.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHEndChargingVC.h"

@interface CSHEndChargingVC ()<UITextViewDelegate>
{
    UIImage *imageH;
    UIImage *imageL;
    int keyBoardH;
}


//已充电量
@property (weak, nonatomic) IBOutlet UILabel *laba;
//充电时长
@property (weak, nonatomic) IBOutlet UILabel *labb;
//消耗金额
@property (weak, nonatomic) IBOutlet UILabel *labc;
//行驶多少公里
@property (weak, nonatomic) IBOutlet UILabel *labd;


@property (weak, nonatomic) IBOutlet UIButton *btna;
@property (weak, nonatomic) IBOutlet UIButton *btnb;
@property (weak, nonatomic) IBOutlet UIButton *btnc;
@property (weak, nonatomic) IBOutlet UIButton *btnd;
@property (weak, nonatomic) IBOutlet UIButton *btne;

@property (weak, nonatomic) IBOutlet UIButton *btnm;
@property (weak, nonatomic) IBOutlet UIButton *btnn;

//

@property (weak, nonatomic) IBOutlet UITextView *textViewa;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property(nonatomic,copy)NSString *total;//评分

@end

@implementation CSHEndChargingVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //就一个导航栏，关了之后所有界面的导航栏都关闭了
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)goBackButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"root2" object:nil];
}

#pragma mark --- touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.total=@"5";
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil] ;
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil] ;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textViewa.delegate=self;
    
    self.title=@"充电结束";
    
    imageH=[UIImage imageNamed:@"commentH"];
    imageL=[UIImage imageNamed:@"commentL"];
    
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageH forState:UIControlStateNormal];
    
    
    [self getResult];
    
    //[self getStationIdWithChargrNO:self.chargerNO];
}
-(void)getStationIdWithChargrNO:(NSString *)chargeNO{
    
    NSString *api=[NSString stringWithFormat:@"/api/chargers/%@",chargeNO];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject!=nil) {
            self.stationId=[NSString stringWithFormat:@"%@",responseObject[@"station"][@"id"]];
            
           // [self addComments];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)getResult{
    NSString *api=@"/api/charging/result";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDictionary *para=@{@"chargerCode":self.chargerNO,
                         @"chargerConn":@"10",
                         @"orderId":self.orderId};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    // 设置返回格式
    _operation.responseSerializer= [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头二
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:TOKEN];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    //开始请求
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state=[NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            NSString *errorDescr=[NSString stringWithFormat:@"%@",responseObject[@"errorDescr"]];
            [MBProgressHUD showError:errorDescr];
            return ;
        }else{//查询充电结果
            self.laba.text=responseObject[@"electric"];
            self.labb.text=responseObject[@"chargeTime"];
            self.labc.text=[NSString stringWithFormat:@"%@",responseObject[@"money"]];
            
            NSString *electric=responseObject[@"electric"];
            
            NSInteger l= electric.length-3;
            NSString *subStr= [electric  substringToIndex:l];
            self.labd.text=[NSString stringWithFormat:@"%.2lf",subStr.floatValue*5];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error：%@",error);
        
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textViewa.text=@"";
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = aNotification.userInfo;
    CGRect frame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue] ;
    keyBoardH=frame.size.height;
    if ((screenH-CGRectGetMaxY(self.textViewa.frame))<frame.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, 64-keyBoardH, screenW, screenH);
        }];
    }
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, 0, screenW, screenH);
    }];
}

- (IBAction)btnaClicked:(UIButton *)sender {
    self.total=@"1";
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageL forState:UIControlStateNormal];
}

- (IBAction)btnbClicked:(UIButton *)sender {
    self.total=@"2";
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageL forState:UIControlStateNormal];
}
- (IBAction)btncClicked:(UIButton *)sender {
    self.total=@"3";
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageL forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageL forState:UIControlStateNormal];
}

- (IBAction)btnm:(UIButton *)sender {
    self.total=@"4";
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageL forState:UIControlStateNormal];
}
- (IBAction)btnn:(UIButton *)sender {
    self.total=@"5";
    [self.btna setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnb setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnc setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnm setBackgroundImage:imageH forState:UIControlStateNormal];
    [self.btnn setBackgroundImage:imageH forState:UIControlStateNormal];
}


#pragma mark --- 点击 提交按钮
- (IBAction)commitBtnClicked:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[self getStationIdWithChargrNO:self.chargerNO];
    [self addComments];
}
//添加评论  实际做的时候accountId 需要改
-(void)addComments{
    
    NSString *api=@"/api/reviews/add";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *accountId=[defaults objectForKey:@"accountId"];
    
    //检查参数是否为空
    NSDictionary *para=@{@"accountId":accountId,
                         @"stationId":self.stationId,
                         @"content":self.textViewa.text,
                         @"total":self.total};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString=[NSString stringWithFormat:@"%@",operation.responseString];
        if ([responseString isEqualToString:@"success"]) {
            
            [MBProgressHUD showError:@"评论成功！"];
            
            [self dismissViewControllerAnimated:NO completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"root2" object:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error：%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
