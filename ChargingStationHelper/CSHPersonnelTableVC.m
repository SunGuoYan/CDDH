//
//  CSHPersonnelTableVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/8/23.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "CSHPersonnelTableVC.h"

#import "KSDatePicker.h"//时间轴 库

#import "UpYun.h" //又拍云 SDK

#import "CSHChangePWDTableVC.h"
#import "UIImageView+WebCache.h"
#import "ChangePWDVC.h"
#import "BindToThirdPlatformVC.h"
#import "ChooseProvinceVC.h"

@interface CSHPersonnelTableVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

{
    BOOL sectionA;
    UIImagePickerController *pickerController;
}
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userNicknameTF;
@property (weak, nonatomic) IBOutlet UIButton *userSexBtn;

@property (weak, nonatomic) IBOutlet UIButton *userDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTF;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

//省市区
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
//详细地址
@property (weak, nonatomic) IBOutlet UITextField *addressLab;



@property(nonatomic,copy)NSString *bucket;
@property(nonatomic,copy)NSString *policy;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,copy)NSString *imageUrlStr;


@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *goBackBtn;

@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *districtStr;

@end

@implementation CSHPersonnelTableVC

-(void)getUserInfomation{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    NSString *api=@"/api/account/?access_token=";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@%@",baseUrl,api,token];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [_operation GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *personRealName=[NSString stringWithFormat:@"%@",responseObject[@"realName"]];
        //数据类型
        NSString *personRealGender=[NSString stringWithFormat:@"%@",responseObject[@"gender"]];
        
        NSString *personBirth=[NSString stringWithFormat:@"%@",responseObject[@"birth"]];
        NSString *personNickName=[NSString stringWithFormat:@"%@",responseObject[@"nickname"]];
        NSString *personAvatar=[NSString stringWithFormat:@"%@",responseObject[@"avatar"]];
        NSString *personEmail=[NSString stringWithFormat:@"%@",responseObject[@"email"]];
        
        NSString *province=[NSString stringWithFormat:@"%@",responseObject[@"province"]];
        NSString *city=[NSString stringWithFormat:@"%@",responseObject[@"city"]];
        NSString *area=[NSString stringWithFormat:@"%@",responseObject[@"area"]];
        
        NSString *detailAddress=[NSString stringWithFormat:@"%@",responseObject[@"detailAddress"]];
        
        
        
        if ([area isEqualToString:@"<null>"]) {
            area=@"";
            city=@"";
            province=@"";
        }
        
        [self.provinceBtn setTitle:[NSString stringWithFormat:@"%@%@%@",province,city,area] forState:UIControlStateNormal];
        self.provinceStr=province;
        self.cityStr=city;
        self.districtStr=area;
        
        if ([detailAddress isEqualToString:@"<null>"]) {
            detailAddress=@"";
        }
        self.addressLab.text=detailAddress;
        
        //数据类型
        NSNumber *personPhone=responseObject[@"phone"];
        
        //1 icon
        UIImage *image=[UIImage imageNamed:@"cddh"];
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:personAvatar] placeholderImage:image];
        
        self.imageUrlStr=personAvatar;
        
//      [self.userIcon sd_setImageWithURL:[NSURL URLWithString:personAvatar]];
        
        
        //2 name
        if ([personRealName isEqualToString:@"<null>"]) {
            personRealName=@"";
        }
        self.userNameTF.text=[NSString stringWithFormat:@"%@",personRealName];
        
        //3 phone
        self.userPhoneTF.text=[NSString stringWithFormat:@"%@",personPhone];
        
        //4 nickname
        if ([personNickName isEqualToString:@"<null>"]) {
            personNickName=@"";
        }
        self.userNicknameTF.text=[NSString stringWithFormat:@"%@",personNickName];
        
        //7 email
        if ([personEmail isEqualToString:@"<null>"]) {
            personEmail=@"";
        }
        self.userEmailTF.text=[NSString stringWithFormat:@"%@",personEmail];
        
        NSString *personRealGenderStr=[NSString stringWithFormat:@"%@",personRealGender];
        NSString *personBirthStr=[NSString stringWithFormat:@"%@",personBirth];
        
        //5 sex
        if ([personRealGenderStr isEqualToString:@"<null>"]) {
            personRealGenderStr=@"";
        }
        if ([personRealGenderStr isEqualToString:@"FEMALE"]) {
            personRealGenderStr=@"女";
        }else{
            personRealGenderStr=@"男";
        }
        [self.userSexBtn setTitle:personRealGenderStr forState:UIControlStateNormal];
        
        //6 date
        if ([personBirthStr isEqualToString:@"<null>"]) {
            personBirthStr=@"";
        }
        [self.userDateBtn setTitle:personBirthStr forState:UIControlStateNormal];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
    
    /*
     {
     avatar = "<null>";
     birth = "<null>";
     cards =     (
     );
     cars =     (
     );
     createdAt = "2016-09-08 11:32:38";
     credit = 0;
     email = "<null>";
     gender = MALE;
     id = 1;
     level = "<null>";
     money = "0.11";
     nickname = "<null>";
     phone = 13657229663;
     realName = "\U738b\U4e8c";
     status = NORMAL;
     updatedAt = "2016-09-12 14:38:55";
     }
     */
    
}
-(void)setGoBackBtnStyle{
    [self.navigationItem setHidesBackButton:YES];
    self.goBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackBtn.frame = CGRectMake(35, 5, 10, 20);
    [self.goBackBtn setBackgroundImage:[UIImage imageNamed:@"goBackB"] forState:UIControlStateNormal];
    [self.goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.goBackBtn] ;
    self.navigationItem.leftBarButtonItem=back;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userSexBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    self.userDateBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    [self  setGoBackBtnStyle];
    
    [self getUserInfomation];
    
    sectionA=NO;
    
    self.title=@"个人资料";
    
    
    [self setTextState:NO];
    
    [self creatRightBtnUI];
    
    self.userDateBtn.tag=250;

    
    self.saveBtn.backgroundColor=themeBlue;
    self.cancelBtn.backgroundColor=themeBlue;
    
    self.userNameTF.delegate=self;
    self.userNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.userPhoneTF.delegate=self;
    self.userPhoneTF.userInteractionEnabled=NO;
    self.userPhoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.userNicknameTF.delegate=self;
    self.userNicknameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    self.userEmailTF.delegate=self;
    self.userEmailTF.clearButtonMode=UITextFieldViewModeWhileEditing;
}
//限制长度输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==self.userNameTF) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    
    if (textField==self.userNicknameTF) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    
    if (textField==self.userEmailTF) {
        if (string.length==0) {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 64) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)creatRightBtnUI{
    self.rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame=CGRectMake(0, 0, 50, 30);
    
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateSelected];
    
    [self.rightBtn setTitleColor:themeBlue forState:UIControlStateNormal];
    
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark --- 点击 省-市-区 选择
- (IBAction)chooseProvince:(UIButton *)sender {
    ChooseProvinceVC *vc=[[ChooseProvinceVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    __weak typeof(self) weakSelf = self;
    
    vc.myBlcok=^(NSString *provinceStr,NSString *cityStr,NSString *districtStr){
        
        self.provinceStr=provinceStr;
        self.cityStr=cityStr;
        self.districtStr=districtStr;
        
        [weakSelf.provinceBtn setTitle:[NSString stringWithFormat:@"%@%@%@",provinceStr,cityStr,districtStr] forState:UIControlStateNormal];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark --- 1，右上角编辑的点击事件
-(void)rightBtnClick{
    
    if (self.rightBtn.selected==YES) {//select
      
        [self commitPersonelInfo];
        
        self.leftBtn.hidden=YES;
        self.leftBtn=nil;
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.goBackBtn] ;
        
        self.navigationItem.leftBarButtonItem=back;
        
    }else{   //normal  编辑状态

        [self.userNameTF becomeFirstResponder];
        sectionA=YES;
        [self setTextState:YES];
        [self setCancelAction];
    }
    self.rightBtn.selected=!self.rightBtn.selected;
}
-(void)setCancelAction{
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setTitleColor:themeBlue forState:UIControlStateNormal];
    self.leftBtn.frame = CGRectMake(0, 0, 50, 30);
    
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(setCancelActionClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.leftBtn] ;
    
    self.navigationItem.leftBarButtonItem=back;
}
#pragma mark --- 2，左上角取消的点击事件
-(void)setCancelActionClicked{
    self.leftBtn.hidden=YES;
    self.leftBtn=nil;
    
    sectionA=NO;
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.goBackBtn] ;
    
    self.navigationItem.leftBarButtonItem=back;
    
    //收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.rightBtn.selected=!self.rightBtn.selected;
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    NSLog(@"a");
    
    [self setTextState:NO];
}

//邮箱的正则表达式

-(BOOL)isValidEmail{
    NSString *regex=@"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    return [self predicateWithRegex:regex];
}
- (BOOL)predicateWithRegex:(NSString *)regex
{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.userEmailTF.text];
    return isMatch;
}

#pragma  mark --- 点击确认 提交个人用户信息
- (IBAction)saveBtnClicked:(UIButton *)sender {
    
    [self commitPersonelInfo];
}

-(void)commitPersonelInfo{
    
    if (![self.userEmailTF.text isEqualToString:@""]) {
        
        if ([self isValidEmail]==NO) {
            [MBProgressHUD showError:@"邮箱格式错误"];
            return;
        }
    }
    
    
    NSString *api=@"/api/account/update";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSString *gender=[self.userSexBtn.titleLabel.text isEqualToString:@"男"]?@"MALE":@"FEMALE";
    
    if (self.imageUrlStr==nil) {
        
        NSLog(@"图片上传失败");
        
        return;
    }
    
//    NSDictionary *para=@{@"realName":self.userNameTF.text,
//                         @"gender":gender,
//                         @"birth":self.userDateBtn.titleLabel.text,
//                         @"nickname":self.userNicknameTF.text,
//                         @"avatar":self.imageUrlStr,
//                         @"email":self.userEmailTF.text};
    NSString *userNameTF=[NSString stringWithFormat:@"%@",self.userNameTF.text];
    if ( [userNameTF isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入姓名！"];
        return;
    }
    NSString *userNicknameTF=[NSString stringWithFormat:@"%@",self.userNicknameTF.text];
    if ( [userNicknameTF isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入昵称！"];
        return;
    }
    NSString *userEmailTF=[NSString stringWithFormat:@"%@",self.userEmailTF.text];
    if ( [userEmailTF isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入邮箱！"];
        return;
    }
    NSString *districtStr=[NSString stringWithFormat:@"%@",self.districtStr];
    if ([districtStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入所在地！"];
        return;
    }
    
    NSString *addressLab=[NSString stringWithFormat:@"%@",self.addressLab.text];
    if ( [addressLab isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入详细地址！"];
        return;
    }
    
    
    NSDictionary *para=@{@"realName":self.userNameTF.text,
                         @"gender":gender,
                         @"birth":self.userDateBtn.titleLabel.text,
                         @"nickname":self.userNicknameTF.text,
                         @"avatar":self.imageUrlStr,
                         @"email":self.userEmailTF.text,
                         @"province":self.provinceStr,
                         @"city":self.cityStr,
                         @"area":self.districtStr,
                         @"detailAddress":self.addressLab.text};
    
    
    AFHTTPRequestOperationManager *_operation = [AFHTTPRequestOperationManager  manager];
    //申明请求的数据是json类型
    _operation.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //设置返回格式
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头一
    [_operation.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //实际做的时候把token换掉
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"access_token"];
    
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    //设置请求头二
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *realName=[NSString stringWithFormat:@"%@",responseObject[@"realName"]];
        
        if (realName!=nil) {
            [MBProgressHUD showError:@"修改成功"];
            [self setTextState:NO];
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"修改失败！"];
    }];
}

#pragma  mark --- 点击取消
- (IBAction)cancelBtnClicked:(UIButton *)sender {
 
    [self setTextState:NO];
}
#pragma  mark --- 点击性别
- (IBAction)userSexBtnClicked:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self changeUserSex];
}
-(void)changeUserSex{
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//男
        [self.userSexBtn setTitle:@"男" forState:UIControlStateNormal];
    }else if (buttonIndex==1){//女
        [self.userSexBtn setTitle:@"女" forState:UIControlStateNormal];
    }
}
#pragma  mark --- 点击出生日期
- (IBAction)userDateBtnClicked:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    //x,y 值无效，默认是居中的
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
    
    //配置中心，详情见KSDatePikcerApperance
    
    picker.appearance.radius = 5;
    
    //设置回调
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        
        if (buttonType == KSDatePickerButtonCommit) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            NSLog(@"currentDate:%@",currentDate);
            NSLog(@"date:%@",[formatter stringFromDate:currentDate]);
            
            [sender setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
        }
    };
    // 显示
    [picker show];
    
}


-(void)setTextState:(BOOL)state{
    
    self.addressLab.enabled=state;
    self.provinceBtn.enabled=state;
    
    self.userNameTF.enabled=state;
    self.userPhoneTF.enabled=state;
    self.userNicknameTF.enabled=state;
    self.userSexBtn.enabled=state;
    self.userDateBtn.enabled=state;
    self.userEmailTF.enabled=state;
    
    self.cancelBtn.hidden=!state;
    self.saveBtn.hidden=!state;
}





#pragma mark --- cell 的点击事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {//获取相片
        if (sectionA==NO) {
            return;
        }
        [self getImage];
        
        return;
        
    }
    
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {//找回密码
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personneInfo" bundle:nil];
            
            ChangePWDVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChangePWDVC class])];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){//第三方账号绑定
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personneInfo" bundle:nil];
            
            BindToThirdPlatformVC *vc=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BindToThirdPlatformVC class])];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
}
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
#pragma mark --- 调用相册
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
#pragma mark ---  ImagePicker结束时回调的函数 把取出来的Image赋值给imageV
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image=info[UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //压缩图片
    CGSize imagesize = image.size;
    imagesize.height = 200;
    imagesize.width = 200;
    image = [self imageWithImage:image scaledToSize:imagesize];
    
    self.userIcon.image=image;
    
    
    if (self.userIcon.image!=nil) {
        [self getImageUrlWithImage:self.userIcon.image];
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    
    view.backgroundColor=initialGray;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
   
    view.backgroundColor=initialGray;
    return view;
}
@end
