//
//  CSHDriverCertificatingViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/20/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHDriverCertificatingViewController.h"
#import "CSHProvinceSelectionViewController.h"
#import "CSHCarBrandListViewController.h"
#import "UpYun.h" //又拍云 SDK
#import "UIImageView+WebCache.h"
@interface CSHDriverCertificatingViewController () <UITableViewDelegate, CSHProvinceSelectionViewControllerDelegate, CSHCarBrandListViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *pickerController;
}
@property (weak, nonatomic) IBOutlet UIButton *provinceNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *carSeriesLabel;
//1，品牌车型
@property(nonatomic,copy)NSString *brandName;
@property(nonatomic,copy)NSString *brandSeries;
//2，车架号码
@property (weak, nonatomic) IBOutlet UITextField *textFielda;
//3，发动机号码
@property (weak, nonatomic) IBOutlet UITextField *textFieldb;

//5.1,车牌号
@property (weak, nonatomic) IBOutlet UITextField *textFieldc;
//5.2,车牌号（省份）
@property(nonatomic,copy)NSString *provinceName;
//4，行驶证照片
@property (weak, nonatomic) IBOutlet UIImageView *imageV;


//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


//又拍云参数
@property(nonatomic,copy)NSString *bucket;
@property(nonatomic,copy)NSString *policy;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,copy)NSString *imageUrlStr;

//para
@property(nonatomic,strong)NSDictionary *para;
@end

@implementation CSHDriverCertificatingViewController
-(NSDictionary *)para{
    if (_para==nil) {
        _para=[[NSDictionary alloc]init];
    }
    return _para;
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
    [super viewDidLoad];
    
    self.commitBtn.radius=4;
    
    self.commitBtn.backgroundColor=themeCorlor;
    
    self.provinceName=@"京";//默认为京
    if (self.carBrand==nil) {
        self.carBrand=@"";
    }
    if (self.carType==nil) {
        self.carType=@"";
    }
    if (![self.carBrand isEqualToString:@"<null>"]) {
        self.carSeriesLabel.text=[NSString stringWithFormat:@"%@%@",self.carBrand,self.carType];
    }
    if (![self.frameNumber isEqualToString:@"<null>"]) {
        self.textFielda.text=self.frameNumber;
    }
    if (![self.engineNumber isEqualToString:@"<null>"]) {
        self.textFieldb.text=self.engineNumber;
    }
    
    
    if (self.plateNumber.length>0) {
        
        NSString *provinceName = [self.plateNumber substringToIndex:1];
        NSString *brandName=[self.plateNumber substringFromIndex:1];
        
        self.provinceName=provinceName;
        
        if (![brandName isEqualToString:@"<null>"]) {
            self.textFieldc.text=brandName;//车牌号
        }
        
        if (self.driverId==nil) {//1.未提交过
            [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        }else{
            /*
             PASSED("认证通过"),CHECKING("资料提交"),FAILED("认证失败");
             */
            //2.认证失败
            if ([self.carIdentifyStatus isEqualToString:@"认证失败"]) {
                self.carIdentifyStatus=@"提交";
            }else if([self.carIdentifyStatus isEqualToString:@"资料提交"]||[self.carIdentifyStatus isEqualToString:@"认证通过"]){
                //3.认证中
                [self.commitBtn setTitle:self.carIdentifyStatus forState:UIControlStateNormal];
                self.commitBtn.userInteractionEnabled=NO;
                self.commitBtn.backgroundColor=[UIColor lightGrayColor];
            }
            
            
        }
        
        self.imageUrlStr=[NSString stringWithFormat:@"%@",self.drivingLicensePhoto];
        
        if (![self.imageUrlStr isEqualToString:@"<null>"]) {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.drivingLicensePhoto] placeholderImage:[UIImage imageNamed:@"cddh"]];
        }
    }
 
    
    self.title = @"车主认证";
    
    [self setGoBackBtnStyle];
    
    self.imageV.image=[UIImage imageNamed:@"cddh"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- 点击车架号码 ？
- (IBAction)carNumberClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.7 animations:^{
        UIView *c=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        c.backgroundColor=[UIColor lightGrayColor];
        c.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        c.tag=120;
        
        
        //添加到keyWindow 上
        [[UIApplication sharedApplication].keyWindow addSubview:c];
        
        //1.单击手势
        UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveFromSuperCarNumber)];
        //设置点击次数
        tapOne.numberOfTapsRequired=1;//默认1
        //设置手指个数
        tapOne.numberOfTouchesRequired=1;//默认1
        [c addGestureRecognizer:tapOne];
        
        
        CGFloat imageW=screenW-20;
        CGFloat imageH=(screenW-20)*390/572;
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, screenH/2-imageH/2, imageW,imageH )];
        imageV.image=[UIImage imageNamed:@"frame_question"];
        [c addSubview:imageV];
    }];
    
}
-(void)moveFromSuperCarNumber{
    
        UIView *c=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:120];
        [c removeFromSuperview];
  
}

#pragma mark --- 发动机号码 ？
- (IBAction)engineNOClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.7 animations:^{
        UIView *c=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        c.backgroundColor=[UIColor lightGrayColor];
        c.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        c.tag=121;
        
        
        //添加到keyWindow 上
        [[UIApplication sharedApplication].keyWindow addSubview:c];
        
        //1.单击手势
        UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveFromSuperEngine)];
        //设置点击次数
        tapOne.numberOfTapsRequired=1;//默认1
        //设置手指个数
        tapOne.numberOfTouchesRequired=1;//默认1
        [c addGestureRecognizer:tapOne];
        
        CGFloat imageW=screenW-20;
        CGFloat imageH=(screenW-20)*390/572;
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, screenH/2-imageH/2, imageW,imageH )];
        imageV.image=[UIImage imageNamed:@"engine_question"];
        [c addSubview:imageV];
    }];
}
-(void)moveFromSuperEngine{
    UIView *c=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:121];
    [c removeFromSuperview];
}

#pragma mark - 点击省份选择按钮
- (IBAction)handleProvinceNameButton:(UIButton *)sender {
    
    CSHProvinceSelectionViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHProvinceSelectionViewController class])];
    viewController.delegate = self;
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark - 点击提交
- (IBAction)handleConfirmButton:(UIButton *)sender {
    if (self.brandName==nil) {
        [MBProgressHUD showError:@"请选择品牌车型！"];
        return;
    }
    if ([self.brandName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择品牌车型！"];
        return;
    }
    
    if ([self.textFielda.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入车架号码！"];
        return;
    }
    if ([self.textFieldb.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入发动机号码！"];
        return;
    }
    if ([self.textFieldc.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入车牌号码！"];
        return;
    }
    if (self.imageUrlStr==nil) {
        [MBProgressHUD showError:@"请上传行驶证照片！"];
        return;
    }
    
    [self commitDriverInfo];
    
}
-(void)commitDriverInfo{
    NSString *api=@"/api/carIdentify/updateOrAdd";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
//    NSString *carBand=[NSString stringWithFormat:@"%@%@",self.brandName,self.brandSeries];
    //车牌号
    
    
    
    NSString *plateNumber=[NSString stringWithFormat:@"%@%@",self.provinceName,self.textFieldc.text];
    if (self.driverId!=nil) {//修改
        self.para=@{@"id":self.driverId,
                    @"carBrand":self.brandName,
                    @"carType":self.brandSeries,
                    @"frameNumber":self.textFielda.text,
                    @"engineNumber":self.textFieldb.text,
                    @"plateNumber":plateNumber,
                    @"vinNumber":self.textFielda.text,
                    @"drivingLicensePhoto":self.imageUrlStr};
    }else{
        self.para=@{@"carBrand":self.brandName,
                    @"carType":self.brandSeries,
                         @"frameNumber":self.textFielda.text,
                         @"engineNumber":self.textFieldb.text,
                         @"plateNumber":plateNumber,
                         @"vinNumber":self.textFielda.text,
                @"drivingLicensePhoto":self.imageUrlStr};
    }

    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:self.para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *statusCode=[NSString stringWithFormat:@"%ld",operation.response.statusCode];
        if ([statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"提交成功"];
        }
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}


-(void)getImage{
    pickerController=[[UIImagePickerController alloc]init];
    pickerController.delegate=self;
    pickerController.allowsEditing=YES;
    
    //类方法
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"拍照或相册" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //点击事件
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
            NSLog(@"no camera");
            [MBProgressHUD showError:@"您的设备缺少相机"];
            return ;
        }
        
        //需要真机调试
        pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alertVC addAction:photoAction];
    [alertVC addAction:cameraAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
#pragma mark ---  又拍云上传图片
//ImagePicker结束时回调的函数 把取出来的Image赋值给imageV
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage *image=info[UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //压缩图片
    CGSize imagesize = image.size;
    imagesize.height = 200;
    imagesize.width = 200;
    image = [self imageWithImage:image scaledToSize:imagesize];
    
    self.imageV.image=image;
//    self.userIcon.image=image;
    
    if (self.imageV.image!=nil) {
        [self getImageUrlWithImage:self.imageV.image];
    }
    
//    
//    if (self.userIcon.image!=nil) {
//        [self getImageUrlWithImage:self.userIcon.image];
//    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
}
-(void)getImageUrlWithImage:(UIImage *)image{
    
    [self upImageToStorageWithImage:image];
}
//获取又拍云上传图片所需参数
-(void)upImageToStorageWithImage:(UIImage *)image{
    
    NSString *api=@"/ajax/photo-storage-settings";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSDictionary *para=@{@"directory":@"avatar"};
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        
        if (responseObject[@"bucket"]!=nil) {
            
            self.bucket=[NSString stringWithFormat:@"%@",responseObject[@"bucket"]];
            self.policy=[NSString stringWithFormat:@"%@",responseObject[@"policy"]];
            self.signature=[NSString stringWithFormat:@"%@",responseObject[@"signature"]];
            
            [self getImageUrlWithImage:image andWithBucket:self.bucket andWithPolicy:self.policy andWithSignature:self.signature];
            
        }
        
        
        //        if ((self.bucket!=nil)&&(self.policy!=nil)&&(self.signature!=nil)) {
        //
        //        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
}
-(void)getImageUrlWithImage:(UIImage *)image andWithBucket:(NSString *)bucket andWithPolicy:(NSString *)policy andWithSignature:(NSString *)signature{
    
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = bucket;
    
    __block UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        
     
        
        self.imageUrlStr=[NSString stringWithFormat:@"http://youetong.b0.upaiyun.com%@",responseData[@"url"]];
        
        NSLog(@"%@",self.imageUrlStr);
        
        
    };
    
    uy.failBlocker = ^(NSError * error) {
        
        NSLog(@"error %@", error);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        
        
    };
    
    uy.policyBlocker = ^()
    {
        return policy;
    };
    
    uy.signatureBlocker = ^(NSString *policy)
    {
        return signature;
    };
    
    [uy uploadImage:image savekey:[self getSaveKeyWith:@"png"]];
}
- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}
//对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark ---- cell的点击事件对应的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //品牌车型
    if (indexPath.section == 0 && indexPath.row == 0) {
        CSHCarBrandListViewController *viewController = [[UIStoryboard csh_menuStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CSHCarBrandListViewController class])];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    //行驶证照片  
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self getImage];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //UITableViewController中cell的点击事件里面收期键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - CSHProvinceSelectionViewControllerDelegate
//省份的返回代理
- (void)provinceSelectionViewControllerDidStop {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//省份的逆向传值
- (void)provinceSelectionViewControllerDidStopWithName:(NSString *)name {
    self.provinceName=name;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.provinceNameButton setTitle:name forState:UIControlStateNormal];
}

//brand的delegate的逆向传值，接受brand和series
#pragma mark - CSHCarBrandListViewControllerDelegate
- (void)carBrandListViewControllerDidStopWithBrandName:(NSString *)brandName andBrandImageStr:(NSString *)brandImageStr andSeries:(NSString *)series{
    self.carLogoImageView.image = [UIImage imageNamed:brandImageStr];
    self.carSeriesLabel.text = series;
    self.brandName=brandName;
    self.brandSeries=series;
    [self.navigationController popToViewController:self animated:YES];
}


@end
