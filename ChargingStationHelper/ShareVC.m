//
//  ShareVC.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/11/2.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "ShareVC.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ShareVC ()
@property (weak, nonatomic) IBOutlet UIView *bg;




@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    self.bg.userInteractionEnabled=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShareBoard) name:@"closeShareBoard" object:nil];
}
-(void)closeShareBoard{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//微信  微信走appdelate的回调 但是不走block回调
- (IBAction)btna:(UIButton *)sender {
    
    [self shareDataWithPlatform:UMSocialPlatformType_WechatSession];
}
//朋友圈
- (IBAction)btnb:(UIButton *)sender {
    [self shareDataWithPlatform:UMSocialPlatformType_WechatTimeLine];
}
//QQ  QQ不走appdelegate里面的回调函数 但是进去blcok回调
- (IBAction)btnc:(UIButton *)sender {
    [self shareDataWithPlatform:UMSocialPlatformType_QQ];
}
//QQ控件
- (IBAction)btnd:(UIButton *)sender {
    [self shareDataWithPlatform:UMSocialPlatformType_Qzone];
}
//微信收藏
- (IBAction)btne:(UIButton *)sender {
    [self shareDataWithPlatform:UMSocialPlatformType_WechatFavorite];
}
//新浪
- (IBAction)btnf:(UIButton *)sender {
    [MBProgressHUD showError:@"功能暂未开放"];
}

-(void)shareDataWithPlatform:(UMSocialPlatformType)platformType{
    
    UMSocialMessageObject *messageObject=[UMSocialMessageObject messageObject];
    NSString  *url=[NSString stringWithFormat:@"%@/share/pages/show?stationId=%@&positionX=%lf&positionY=%lf",baseUrl,self.stationId,self.longitude,self.latitude];
    
    NSString *title=@"充电大亨";
    NSString *text=@"只为方便您的出行";
//    NSString *url =@"https://www.baidu.com";
    UIImage *image=[UIImage imageNamed:@"cddhH"];
    
    //0
    messageObject.text=text;
    /*
     一下是设置分享信息的分享体
     */
    
    //1 分享 url
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:@"http://dev.umeng.com/images/tab2_1.png"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareObject setWebpageUrl:url];
    messageObject.shareObject = shareObject;
    
    //2 分享 Image
    UMShareImageObject *shareImageObject=[UMShareImageObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareImageObject setShareImage:image];
    //    messageObject.shareObject=shareImageObject;
    
    //3 分享 Video
    UMShareVideoObject *shareVideoObject=[UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareVideoObject setVideoUrl:@"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"];
    //    messageObject.shareObject=shareVideoObject;
    
    //4 分享 Music
    UMShareMusicObject *shareMusicObject=[UMShareMusicObject shareObjectWithTitle:title descr:text thumImage:image];
    [shareMusicObject setMusicUrl:@"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3"];
    //    messageObject.shareObject=shareMusicObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        if (!error) {
            NSLog(@"success");
//            [MBProgressHUD showError:@"分享成功！"];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"fail");
            [MBProgressHUD showError:@"分享失败！"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
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
