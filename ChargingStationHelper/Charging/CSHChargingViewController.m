//
//  CSHChargingViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 3/2/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHChargingViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "CSHChargerDetailVC.h"
#import "CSHStartChargingVC.h"

@interface CSHChargingViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *scanView;
@property (nonatomic, strong) UIImageView *scanRectView;
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, assign) CGSize scanSize;

@property (nonatomic, strong) UIView *deviceNumberView;
@property (nonatomic, strong) UITextField *deviceNumberTextField;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation CSHChargingViewController



-(void)setGoBackBtnStyle{
    [self.navigationItem setHidesBackButton:YES];

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, 10, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn] ;
    
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootOne" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充电";
    
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
         NSLog(@"Device name: %@", [device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
            }else{
                NSLog(@"Device position : front");
            }
        }
    }
    
//    [self setGoBackBtnStyle];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    /*
     (lldb) po self.device
     <AVCaptureFigVideoDevice: 0x137e5dee0 [后置镜头][com.apple.avfoundation.avcapturedevice.built-in_video:0]>
     
     (lldb) po self.input
     nil
     (lldb) 
     */
    //正常情况下：
    /*
     (lldb) po self.device
     <AVCaptureFigVideoDevice: 0x1434af6c0 [背面相机][com.apple.avfoundation.avcapturedevice.built-in_video:0]>
     
     (lldb) po self.input
     <AVCaptureDeviceInput: 0x1461c1c20 [背面相机]>
     */
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    
    //判断是否有相机
    BOOL isExit=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isExit==NO) {
//        NSLog(@"no camera");
        [MBProgressHUD showError:@"您的设备缺少相机"];
        return ;
    }
    
    // 这里运行两处崩溃  但是真机调试就没问题，疑是模拟器缺少相机无扫描功能
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    //计算扫描器的大小
    CGSize windowSize = CGSizeMake(CGRectGetMaxX([UIScreen mainScreen].bounds), CGRectGetMaxY([UIScreen mainScreen].bounds) - 64);
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    self.scanSize = scanSize;
    
    
    //计算扫面器的坐标位置
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, 60, scanSize.width, scanSize.height);
    //计算rectOfInterest 注意x,y交换位置
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    self.output.rectOfInterest = scanRect;
    
    
    //1，第一个界面的 clear 的大背景视图
    self.scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
    self.scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanView];//1
    
    // 2，扫描的那个线条  scan-frame
    self.scanRectView = [UIImageView new];
    self.scanRectView.frame = CGRectMake((windowSize.width-scanSize.width)/2, 60, scanSize.width, scanSize.height);
    self.scanRectView.image = [UIImage imageNamed:@"scan-frame"];
    [self.scanView addSubview:self.scanRectView];
    
    
    
    //3， 扫描的那个线条  scan-line
    self.scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, scanSize.width - 20, 2)];
    self.scanLineImageView.image = [UIImage imageNamed:@"scan-line"];
    [self.scanRectView addSubview:self.scanLineImageView];
    
    //4，白色提示文字 label
    UILabel *scanLabel = [UILabel new];
    scanLabel.font = [UIFont systemFontOfSize:13.0f];
    scanLabel.textColor = [UIColor whiteColor];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    scanLabel.numberOfLines = 0;
    CGFloat margin = 20.0f;
    CGFloat scanLabelWidth = windowSize.width - margin * 2;
    scanLabel.preferredMaxLayoutWidth = scanLabelWidth;
    scanLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.scanRectView.frame) + 20, scanLabelWidth, 40.0f);
    scanLabel.text = @"扫描充电桩二维码，即可享受充电服务";
    [self.scanView addSubview:scanLabel];
    
    //5，切换至输入设备号充电 label
    UILabel *switchToDeviceNumberLabel = [UILabel new];
    switchToDeviceNumberLabel.font = [UIFont systemFontOfSize:13.0f];
    switchToDeviceNumberLabel.textColor = [UIColor whiteColor];
    switchToDeviceNumberLabel.textAlignment = NSTextAlignmentCenter;
    switchToDeviceNumberLabel.numberOfLines = 1;
    switchToDeviceNumberLabel.text = @"切换至输入设备号充电";
    [switchToDeviceNumberLabel sizeToFit];
    CGFloat horizontalSpacing = 15.0f;
    CGFloat switchToDeviceNumberLabelHeight = CGRectGetHeight(switchToDeviceNumberLabel.bounds);
    CGFloat keyboardIconImageViewWidth = switchToDeviceNumberLabelHeight * 67.0f / 44.0f;
    switchToDeviceNumberLabel.frame = CGRectMake(keyboardIconImageViewWidth + horizontalSpacing * 2, horizontalSpacing, CGRectGetWidth(switchToDeviceNumberLabel.bounds), CGRectGetHeight(switchToDeviceNumberLabel.bounds));
    
    //6，切换至输入设备号充电 icon
    UIImageView *keyboardIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpacing, horizontalSpacing, keyboardIconImageViewWidth, switchToDeviceNumberLabelHeight)];
    keyboardIconImageView.image = [UIImage imageNamed:@"keyboard-icon"];
    
    //7，切换至输入设备号充电 灰色背景
    UIView *switchToDeviceNumberContainerView = [[UIView alloc] init];
    switchToDeviceNumberContainerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    switchToDeviceNumberContainerView.bounds = CGRectMake(0, 0, CGRectGetWidth(switchToDeviceNumberLabel.bounds) + keyboardIconImageViewWidth + horizontalSpacing * 3, switchToDeviceNumberLabelHeight + horizontalSpacing * 2);
    switchToDeviceNumberContainerView.center = CGPointMake(windowSize.width / 2.0f, windowSize.height - horizontalSpacing * 2 - CGRectGetMaxY(keyboardIconImageView.bounds) / 2.0f);
    
    switchToDeviceNumberContainerView.radius = CGRectGetHeight(switchToDeviceNumberContainerView.bounds) / 2.0f;
    
    
    //切换至输入设备号充电入 灰色背景 添加手势
    [switchToDeviceNumberContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchToDeviceNumberTapGesture:)]];
    //母视图上加小控件 icon
    [switchToDeviceNumberContainerView addSubview:keyboardIconImageView];
    
    //母视图上加小控件 label
    [switchToDeviceNumberContainerView addSubview:switchToDeviceNumberLabel];
   
    [self.scanView addSubview:switchToDeviceNumberContainerView];
#pragma mark --- 自己做的  切换至输入设备号充电入 button
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=switchToDeviceNumberContainerView.bounds;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"切换至输入设备号充电" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor yellowColor];
    
    btn.radius=15;
    //手电筒
    UIButton *lightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame=CGRectMake(screenW/2-15, CGRectGetMinY(switchToDeviceNumberContainerView.frame)-50-40+30, 30, 30);
    [lightBtn addTarget:self action:@selector(lightUp:) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn setBackgroundImage:[UIImage imageNamed:@"light_down"] forState:UIControlStateNormal];
    [self.scanView addSubview:lightBtn];
    
    
    /**     第二个界面      **/
    
    
    //1，第二个界面的 clear 的大背景视图
    self.deviceNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
    self.deviceNumberView.hidden = YES;
    [self.view addSubview:self.deviceNumberView];
    self.deviceNumberView.backgroundColor = [UIColor clearColor];
    
    //2，输入框的白色背景
    UIView *deviceNumberTextFieldContainerView = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpacing, 100, windowSize.width - horizontalSpacing * 2, 50)];
    deviceNumberTextFieldContainerView.backgroundColor = [UIColor whiteColor];
    deviceNumberTextFieldContainerView.radius=4.0f;
    [self.deviceNumberView addSubview:deviceNumberTextFieldContainerView];
    
    //3，输入框
    self.deviceNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(horizontalSpacing, 0, windowSize.width - horizontalSpacing * 4, 50)];
    self.deviceNumberTextField.backgroundColor = [UIColor whiteColor];
    self.deviceNumberTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.deviceNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.deviceNumberTextField.font = [UIFont systemFontOfSize:15.0f];
    self.deviceNumberTextField.placeholder = @"请输入设备号";
    self.deviceNumberTextField.radius=4.0f;
    
    [deviceNumberTextFieldContainerView addSubview:self.deviceNumberTextField];
    
    //4，切换至扫码 label
    UILabel *switchToScanLabel = [UILabel new];
    switchToScanLabel.textColor = [UIColor whiteColor];
    switchToScanLabel.font = [UIFont systemFontOfSize:13.0f];
    switchToScanLabel.text = @"切换至扫码";
    [switchToScanLabel sizeToFit];
    CGFloat scanIconHeight = 24.0f;
    switchToScanLabel.frame = CGRectMake(horizontalSpacing * 2 + scanIconHeight, horizontalSpacing, CGRectGetWidth(switchToScanLabel.bounds), CGRectGetHeight(switchToScanLabel.bounds));
    
    
    //5，切换至扫码 icon
    UIImageView *scanIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpacing, (CGRectGetHeight(switchToScanLabel.bounds) + horizontalSpacing * 2 - scanIconHeight) / 2.0f , scanIconHeight, scanIconHeight)];
    scanIconImageView.image = [UIImage imageNamed:@"scan-icon"];
    
    
    //6，切换至扫码 灰色背景图
    UIView *switchToScanContainerView = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpacing, CGRectGetMaxY(deviceNumberTextFieldContainerView.frame) + 40, horizontalSpacing * 3 + scanIconHeight + CGRectGetWidth(switchToScanLabel.bounds), CGRectGetHeight(switchToScanLabel.bounds) + horizontalSpacing * 2)];
    switchToScanContainerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    switchToScanContainerView.radius=CGRectGetHeight(switchToScanContainerView.bounds) / 2.0f;
    
    //添加手势  切换至扫码
    [switchToScanContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchToScanTapGesture:)]];
    [switchToScanContainerView addSubview:scanIconImageView];
    [switchToScanContainerView addSubview:switchToScanLabel];
    [self.deviceNumberView addSubview:switchToScanContainerView];
    
    //7，确定按钮
    UIButton *deviceNumberConfirmButton = [UIButton new];
    deviceNumberConfirmButton.frame = CGRectMake(windowSize.width - CGRectGetWidth(switchToScanContainerView.bounds) - horizontalSpacing, CGRectGetMinY(switchToScanContainerView.frame), CGRectGetWidth(switchToScanContainerView.bounds), CGRectGetHeight(switchToScanContainerView.bounds));
    [deviceNumberConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [deviceNumberConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deviceNumberConfirmButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    deviceNumberConfirmButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    deviceNumberConfirmButton.radius = CGRectGetHeight(deviceNumberConfirmButton.bounds) / 2.0f;
    //  确定按钮的点击事件
    [deviceNumberConfirmButton addTarget:self action:@selector(handleDeviceNumberConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.deviceNumberView addSubview:deviceNumberConfirmButton];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //开始捕获
    [self.session startRunning];
    
    
    
}
-(void)lightUp:(UIButton *)btn{
    if (btn.selected) {
        [self turnTorchOn:YES];
        [btn setBackgroundImage:[UIImage imageNamed:@"light_up"] forState:UIControlStateNormal];
    }else{
        [self turnTorchOn:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"light_down"] forState:UIControlStateNormal];
    }
    btn.selected=!btn.selected;
    
}
- (void) turnTorchOn: (bool) on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                on = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                on = NO;
            }
            [device unlockForConfiguration];
        }
    }
}




#pragma mark---界面一点击切换至输入设备号充电 切换界面
-(void)btnClick{
    self.deviceNumberView.hidden = NO;
    self.scanView.hidden = YES;
    [self turnTorchOn:NO];
    [self.deviceNumberTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
//        NSLog(@"no camera");
        [MBProgressHUD showError:@"您的设备缺少相机"];
        return ;
    }
    [self.tabBarController.tabBar setHidden:YES];
    
    //开始捕获
    [self.session startRunning];
    
    self.deviceNumberTextField.text=@"";
    [self setGoBackBtnStyle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if (!self.scanView.hidden) {
        [self startScanLineImageViewAnimation];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self turnTorchOn:NO];
    self.scanLineImageView.frame = CGRectMake(10, 10, self.scanSize.width - 20, 2);
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark---左上角的的返回按钮 返回首页
- (IBAction)handleLeftBarButton:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootOne" object:nil];
}
#pragma mark --- 2.界面二的点击确定按钮  push到开启充电的界面
/*
 手动输入和电站详情里面点击Cell调用的同一个接口
 扫码充电调用的是qrcode的接口
 */
- (void)handleDeviceNumberConfirmButton:(UIButton *)button {
    
    if ([self.deviceNumberTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入设备号！"];
        return;
    }
    
    [self getOneChargerByCodeWithChargerNO:self.deviceNumberTextField.text];
}
-(void)getOneChargerByCodeWithChargerNO:(NSString *)chargerNO{
    
    NSString *api=@"/api/chargers/code";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"code":chargerNO};
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject!=nil) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CSHChargerDetailVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargerDetailVC class])];
            vc.chargerQrcode=chargerNO;
//            vc.chargerCode=chargerNO;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"电桩号不存在"];
    }];
}
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}




/*  这段代码好像没什么用 */
//切换到界面二
- (void)handleSwitchToDeviceNumberTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
//    NSLog(@"返回界面二");
    self.deviceNumberView.hidden = NO;
    self.scanView.hidden = YES;
    [self turnTorchOn:NO];
//    self.deviceNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    [self.deviceNumberTextField resignFirstResponder];
//    [self.deviceNumberTextField becomeFirstResponder];
}

#pragma mark --- 切换至扫码的响应事件  返回界面一
- (void)handleSwitchToScanTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    self.deviceNumberView.hidden = YES;
    self.scanView.hidden = NO;
    [self.deviceNumberTextField resignFirstResponder];
    
    //开始捕获
    [self.session startRunning];
}

- (void)startScanLineImageViewAnimation {
    [UIView animateWithDuration:2.4 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        
        self.scanLineImageView.frame = CGRectMake(10, self.scanSize.height - 10, self.scanSize.width - 20, 2);
        
    } completion:nil];
}

#pragma mark --- 1，扫描完成的操作
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (self.scanView.hidden) {
        return;
    }
    
    if ( (metadataObjects.count==0) ){
        return;
    }
    
    if (metadataObjects.count>0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //输出扫描字符串
        [self goToChargerDetailVCByQrcode:metadataObject.stringValue];
    }
}

//先查询是否有电桩 再跳到详情页面
-(void)goToChargerDetailVCByQrcode:(NSString *)code{
    NSString *api=@"/api/chargers/qrcode";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"qrcode":code};
    
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject!=nil) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CSHChargerDetailVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CSHChargerDetailVC class])];
            vc.chargerQrcode=code;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //1,
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入错误，请重新输入！" preferredStyle:UIAlertControllerStyleAlert];
        
        
        //2
        UIAlertAction *defaultActiona = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //开始捕获
            [self.session startRunning];
        }];
        [alertController addAction:defaultActiona];
        
        //3
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];
     //   [MBProgressHUD showError:@"电桩号不存在"];
    }];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.session startRunning];
}


@end
