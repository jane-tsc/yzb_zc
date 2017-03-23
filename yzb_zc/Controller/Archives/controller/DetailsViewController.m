//
//  DetailsViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "DetailsViewController.h"
#import "XTPopView.h"
#import "JZMTBtnView.h"
#import "OMGToast.h"
#import "originaNolViewController.h"
#import "originalYESViewController.h"
#import "XuzhiViewController.h"
#import "mobileViewController.h"
#import "detailsMedel.h"
#import "ResultsViewController.h"
#import "MyMD5.h"
#import "WsqMD5Util.h"
#import "ShibaiViewController.h"
#import "MSpopView.h"
#import "SecurityViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "OpenpreservationViewController.h"
#import "ProfileAlertView.h"///弹出视图不在提醒勾选

#import "UMSocial.h"
#import "UMSocialDataService.h"
#define AppKey @"5774ba7e67e58e3f12001f13"

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]



@interface DetailsViewController ()<selectIndexPathDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,WJTouchIDDelegate,confirmButtonClickDelegate>{
    XTPopView *view1;
    UIButton *timeBtn;
    UIButton *yanjingBtn;
    UIButton *searchBtn;
    UIImage *imagephoto;
    UILabel *lable;
    UILabel *beizhu;
    //图片2进制路径
    //    NSString* filePath;
    UIImage *yanzImage;///验证选择的图片
    //    NSString * size;///图片大小
    //    NSString *md5image;///图片的哈希值
    
    ///发送按钮弹出的POPview
    UIView *wirthView;
    UIView *blackView;
    
    
    UIButton *tabbarBtn;
    UILabel * tabbarTitle;
    
    NSString *shiyongType;
    
    UIImage *FenxiangImage;
    UITextField *userEmail;
    
    NSInteger index;///这个是纪录指纹是证书出证还是删除证书
    
    NSInteger indexpaths;///根据下标的到是验证还是出证
    
    NSInteger buzaitixing;
    
}
@property(nonatomic,strong) UIButton *publicButton;//公开证书按钮
@property(nonatomic,strong) NSMutableDictionary *Dictionary;
@property (nonatomic, strong) NSMutableArray * deleteArr;
@property(nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) WJTouchID *touchID;///指纹验证
@end

@implementation DetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _Dictionary = [[NSMutableDictionary alloc]init];
    _deleteArr = [NSMutableArray array];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.title = self.labletitle;
    self.imageArray = [NSMutableArray array];
    NSLog(@" --- :%d-----:%d ----;%d -----;%d",[User shareUser].zhenshuDelete,[User shareUser].zhengshuchuzheng,[User shareUser].yuanwenjianxiazai,[User shareUser].yuanwenjianDelete);
    
    [self tabbarView];
    [self setupView];
    [self httprestsTableviewFile];
    [self getfasongButton];
    ///提前把证书下好
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fenxingimageString = [NSString stringWithFormat:@"http://test.yzzdata.com/App/V1/View/downCert?certId=%@",self.fileid];
        NSURL * url = [NSURL URLWithString:fenxingimageString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        FenxiangImage = [UIImage imageWithData:data];
        NSLog(@"下载好的证书：%@",FenxiangImage);
    });
    
}
///请求网络
- (void)httprestsTableviewFile{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getDetail" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        NSLog(@"证书详情数据：%@",object);
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            self.Dictionary = object[@"data"];
            lable.text = self.Dictionary [@"remarks"];
            
            shiyongType = self.Dictionary [@"usedStatus"];
            
            ///判断是否是试用
            if ([self.Dictionary [@"usedStatus"] intValue] == 0) {
                beizhu.text = @"试用";
                beizhu.backgroundColor = RGB(246, 142, 140);
            }else{
                
            }
            ///判断是否标记过
            if ([self.Dictionary [@"collectStatus"] intValue] == 1)
            {
                [timeBtn setImage:[UIImage imageNamed:@"mark@2x.png"] forState:UIControlStateNormal];
            }
            else if([self.Dictionary [@"collectStatus"] intValue] == 2)
            {
                [timeBtn setImage:[UIImage imageNamed:@"unmark@2x.png"] forState:UIControlStateNormal];
            }
            else if([self.Dictionary [@"collectStatus"] intValue] == 0)
            {
                [timeBtn setImage:[UIImage imageNamed:@"unmark@2x.png"] forState:UIControlStateNormal];
            }
            
            ///判断是否公开1表示未公开
            if ([self.Dictionary [@"accessState"] intValue] == 1) {
                [yanjingBtn setImage:[UIImage imageNamed:@"lock@2x.png"] forState:UIControlStateNormal];
            }else if ([self.Dictionary [@"accessState"] intValue] == 0){
                [yanjingBtn setImage:[UIImage imageNamed:@"unlock@2x.png"] forState:UIControlStateNormal];
            }
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}
- (void)setupView{
    
    UIView *publicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 60 - 64)];
    publicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:publicView];
    
    
    
    beizhu = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 50, 20)];
    beizhu.textAlignment = NSTextAlignmentCenter;
    beizhu.textColor = [UIColor whiteColor];
    beizhu.font =[UIFont systemFontOfSize:13];
    [publicView addSubview:beizhu];
    
    ///显示备注
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screen_width, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor blackColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.font =[UIFont systemFontOfSize:13];
    [publicView addSubview:lable];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;///禁止webview滚动
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(self.view.top).offset(40);
        make.width.equalTo(publicView.width).offset(-20);
        make.height.equalTo(publicView.height).offset(-40);
    }];
    
    NSString *path = [NSString stringWithFormat:@"%@%@?certId=%@",HttpUrl,@"View/securityCert",self.fileid];
    //    NSString *path = [NSString stringWithFormat:@"%@?certId=%@",@"http://192.168.1.2/App/View/securityCert",self.fileid];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    
    ///unlock@2x.png
    ///lock@2x.png
    yanjingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    yanjingBtn.frame = CGRectMake(0, 0, screen_width / 15, screen_width / 15);
    yanjingBtn.selected = YES;
    [yanjingBtn addTarget:self action:@selector(yanjingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ///save_nor.png    save_h.png
    searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"more_n@2x.png"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, 0, screen_width / 15, screen_width / 15);
    [searchBtn addTarget:self action:@selector(diandiandianClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    timeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [timeBtn  setImage:[UIImage imageNamed:@"unmark@2x.png"] forState:UIControlStateNormal];
    //    [timeBtn setImage:[UIImage imageNamed:@"mark@2x.png"] forState:UIControlStateSelected];
    timeBtn.frame = CGRectMake(0, 0, screen_width / 15, screen_width / 15);
    timeBtn.selected = YES;
    [timeBtn addTarget:self action:@selector(xinxinClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *yanjingBtnaa=[[UIBarButtonItem alloc]initWithCustomView:yanjingBtn];
    UIBarButtonItem *barSearchBtn=[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    UIBarButtonItem *barTimeBtn=[[UIBarButtonItem alloc]initWithCustomView:timeBtn];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:barSearchBtn,barTimeBtn,yanjingBtnaa, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载webview");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败");
    [SVProgressHUD dismiss];
}

///加载UI
- (void)tabbarView{
    
    UIView *tabbarView = [[UIView alloc]init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabbarView];
    [tabbarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(self.view.bottom).offset(-60);
        make.width.equalTo(screen_width);
        make.height.equalTo(60);
    }];
    
    UIView *henxian = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 1)];
    henxian.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tabbarView addSubview:henxian];
    
    NSMutableArray *images =[NSMutableArray arrayWithObjects:
                             @"download_nor@2x.png",
                             @"ywj_nor@2x.png",
                             @"yz_n@2x.png",
                             @"cz_n@2x.png",
                             @"send_n@2x.png", nil];
    NSMutableArray *Heithimages =[NSMutableArray arrayWithObjects:
                                  @"download_h@2x.png",
                                  @"ywj_h@2x.png",
                                  @"yz_h@2x.png",
                                  @"cz_h@2x.png",
                                  @"send_h@2x.png", nil];
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"下载",@"原文件",@"验证",@"出证",@"发送", nil];
    for (int i = 0; i< images.count; i ++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * screen_width / 5, 0, screen_width / 5, 60)];
        view.userInteractionEnabled = YES;
        [tabbarView addSubview:view];
        CGRect frame = CGRectMake(i * screen_width / 5, 0, screen_width / 5, 60);
        tabbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tabbarBtn.frame =frame;
        [tabbarBtn setTitle:titles [i] forState:UIControlStateNormal];
        [tabbarBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [tabbarBtn setTitleColor:RGB(253, 139, 142) forState:UIControlStateHighlighted];
        tabbarBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
        tabbarBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [tabbarBtn setImage:[UIImage imageNamed:images [i]] forState:UIControlStateNormal];
        [tabbarBtn setImage:[UIImage imageNamed:Heithimages [i]] forState:UIControlStateHighlighted];
        tabbarBtn.imageEdgeInsets = UIEdgeInsetsMake(-30, 21, 0, 0);
        tabbarBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -15, 0, 0);
        [tabbarBtn setContentEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        tabbarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [tabbarView addSubview:tabbarBtn];
        [tabbarBtn addTarget:self action:@selector(OnTapBtnView:) forControlEvents:UIControlEventTouchUpInside];
        tabbarBtn.tag = 100 + i;
    }
}

-(void)OnTapBtnView:(UIButton *)sender{
    NSLog(@"tag:%ld",(long)sender.tag);
    switch (sender.tag) {
        case 100:
        {
            if ([shiyongType intValue] == 0) {
                NSLog(@"试用状态：%@",shiyongType);
                [OMGToast showWithText:@"您好，您当前是试用不能操作"];
                return;
                
            }else{
                
                                ///判断次数是否过期
                if ([[User shareUser].numExpires integerValue] == 0)
                 {
                
                  UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"次数已过期，请前往开通" preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                  }];
                  UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                       OpenpreservationViewController *open = [[OpenpreservationViewController alloc]init];
                                        open.YwjType = @"1000";
                           [self.navigationController pushViewController:open animated:YES];
                
                        }];
                     // 添加操作（顺序就是呈现的上下顺序）
                   [alertDialog addAction:quxiao];
                   [alertDialog addAction:Okaction];
                    // 呈现警告视图
                   [self presentViewController:alertDialog animated:YES completion:nil];
                
                   }
                    else
                  {
                [SVProgressHUD showWithStatus:@"正在下载中" maskType:SVProgressHUDMaskTypeGradient];
                NSLog(@"下载");
                ///将图片保存到相册
                UIImageWriteToSavedPhotosAlbum(FenxiangImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                NSLog(@"证书详情下载的证书:%@",FenxiangImage);
                
               }
            
            }
            
        }
            break;
            
        case 101:
        {
            NSLog(@"源文件");
            
            ///＝＝＝＝＝＝＝＝＝＝＝＝＝＝判断是否有原文件
            if ([shiyongType intValue] == 0) {
                NSLog(@"试用状态L：%@",shiyongType);
                [OMGToast showWithText:@"您好，您当前是试用不能操作"];
                return;
                
            }else{
                
                
                [[TSCCntc sharedCntc] queryWithPoint:@"getFileUrl" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"]] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        
                        //跳转到原文件的界面
                        originalYESViewController *original = [[originalYESViewController alloc]init];
                        //                original.fileID = self.Dictionary [@"certId"];
                        original.Dictionary = self.Dictionary;
                        [self.navigationController pushViewController:original animated:YES];
                        
                    }else{
                        
                        //                    [OMGToast showWithText:object[@"msg"]];
                        
                        ///跳转到没有原文件的界面
                        originaNolViewController *original = [[originaNolViewController alloc]init];
                        original.Dictionary = self.Dictionary;
                        [self.navigationController pushViewController:original animated:YES];
                        
                    }
                    
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                
            }
            
        }
            break;
        case 102:
        {
           
///indexpaths = 10 是验证
indexpaths = 10;
            NSLog(@"验证");
            if ([shiyongType intValue] == 0) {
                NSLog(@"试用状态L：%@",shiyongType);
                [OMGToast showWithText:@"您好，您当前是试用不能操作"];
                return;
                
            }else{
                
                if ([self.Dictionary [@"fileType"] intValue] == 40) {
                    
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    //                imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                    [self presentModalViewController:imagePicker animated:YES];
                    
                }else if ([self.Dictionary [@"fileType"] intValue] == 20){
                    
                    ///选择图片
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    //            imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //			[self presentModalViewController:imagePicker animated:YES];
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                }
            }
        }
            break;
        case 103:
        {
///indexpaths = 20 是验证
indexpaths = 20;
            NSLog(@"出征");
            if ([shiyongType intValue] == 0) {
                NSLog(@"试用状态：%@",shiyongType);
                [OMGToast showWithText:@"您好，您当前是试用不能操作"];
                return;
                
            }else{
             
                ///没有设置安全设置
                if ([User shareUser].zhengshuchuzheng == 0 ) {
                    
                    
                    if ([User shareUser].zhengshuchuzhengNoremind == 0) {
                        
                        ProfileAlertView *alertView = [[ProfileAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)withGroupNumber:10];
                        alertView.delegate = self;
                        alertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.7];
                        [self.view.window addSubview:alertView];
                        
                        buzaitixing = 2;
                        
                    }else{
                    
                        if ([self.Dictionary [@"fileType"] intValue] == 40) {
                            
                            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                            imagePicker.delegate = self;
                            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                            [self presentModalViewController:imagePicker animated:YES];
                            
                        }else if ([self.Dictionary [@"fileType"] intValue] == 20){
                            
                            ///选择图片
                            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                            imagePicker.delegate = self;
                            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        }
                    
                    }
                }
                //／不启用
                else if ([User shareUser].zhengshuchuzheng  == 10)
                {
                    if ([self.Dictionary [@"fileType"] intValue] == 40) {
                        
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                        imagePicker.delegate = self;
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                        [self presentModalViewController:imagePicker animated:YES];
                        
                    }else if ([self.Dictionary [@"fileType"] intValue] == 20){
                        
                        ///选择图片
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.delegate = self;
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                }
                //／启用密码验证
                else if ([User shareUser].zhengshuchuzheng  == 30)
                {
                    ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
                    pwdAlert.title = @"请输入验证密码";
                    [pwdAlert show];
                    pwdAlert.completeAction = ^(NSString *pwd) {
                        NSLog(@"输入的密码:%@", pwd);
                    
                        [[TSCCntc sharedCntc] queryWithPoint:@"verifySafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,pwd] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                            NSLog(@"证书出证密码数据:%@",object);
                            if ([object [@"code"] integerValue] == 200) {
                                
                                NSDictionary *dic = object [@"data"];
                                if ([dic [@"result"] integerValue] == 1) {
                                    
                                    if ([self.Dictionary [@"fileType"] intValue] == 40) {
                                        
                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                        imagePicker.delegate = self;
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                                        [self presentModalViewController:imagePicker animated:YES];
                                        
                                    }else if ([self.Dictionary [@"fileType"] intValue] == 20){
                                        
                                        ///选择图片
                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                        imagePicker.delegate = self;
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                    }
                                    
                                }else{
                                [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                                }

                            }else{
                                [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                            }
                        } andFailed:^(NSString *object) {
                            [SVProgressHUD showErrorWithStatus:@"网络错误"];
                        }];
                        
                    };
                }
                //／启用指纹验证
                else if ([User shareUser].zhengshuchuzheng == 40)
                {
                    WJTouchID *touchid = [[WJTouchID alloc]init];
                    self.touchID = touchid;
                    touchid.delegate = self;
                    touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
                    [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                    [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                    
                    index = 1;
                }
            }
        }
            break;
        case 104:
        {
            NSLog(@"发送");
            if ([shiyongType intValue] == 0) {
                NSLog(@"试用状态L：%@",shiyongType);
                [OMGToast showWithText:@"您好，您当前是试用不能操作"];
                return;
                
            }else{
                [self showclassPopview];///调用发送按钮事件
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -  分类按钮点击事件
-(void)fasongpopView:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 300:
        {
            ///qq好友
            //标题
            [UMSocialData defaultData].extConfig.qqData.title = @"云证保";
            //发送到为qq消息类型
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:FenxiangImage  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
        case 301:
        {
            ///微信好友
            //应用分享类型如果用户已经安装应用，则打开APP，如果为安装APP，则提示未安装或跳转至微信开放平台
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"微信好友" image:FenxiangImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
            
        case 302:
        {
            
            ///邮件发送
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:@"云证保证书" image:FenxiangImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
            
        case 303:
        {
            ///短信发送
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:@"云证保证书" image:FenxiangImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            ///点击发送动画弹出提示框
            [self classPopView2];
        }
            break;
            
        default:
            break;
    }
}
///回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [OMGToast showWithText:@"取消选择"];
    return;
}
#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate  // 选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
/*
 indexpaths == 10  是验证选取的图片
 indexpaths == 20  是出证选取的图片
 */
   if (indexpaths == 10) {
       if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
       {
           NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
           
           ///得到路径和图片
           if ([type isEqualToString:@"public.image"]) {
               //先把图片转成NSDatas
               yanzImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
               ///得到图片原来的名称
               __block NSString *imagesss;
               __block double size;
               
               NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
               ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
               {
                   ALAssetRepresentation *representation = [myasset defaultRepresentation];
                   imagesss = [representation filename];
                   NSLog(@"图片名称＋＋＋＋＋＋＋＋＋＋＋＋＋::%@",imagesss);
                   
                   NSURL *urlname = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
                   
                   __block NSData *data;
                   __block NSString *md5image;
                   __block  NSString * imagePath;
                   __block NSUInteger buffered;
                   __block  NSString *buff;
                   __block  NSString *fileExt;
                   __block  NSString *certId;
                   __block NSString *s;
                   
                   // 如何判断已经转化了,通过是否存在文件路径
                   ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                   // 创建存放原始图的文件夹--->OriginalPhotoImages
                   NSFileManager * fileManager1 = [NSFileManager defaultManager];
                   if (![fileManager1 fileExistsAtPath:KOriginalPhotoImagePath]) {
                       [fileManager1 createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
                   }
                   if (urlname) {
                       // 主要方法
                       [assetLibrary assetForURL:urlname resultBlock:^(ALAsset *asset) {
                           ALAssetRepresentation *rep = [asset defaultRepresentation];
                           Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                           buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                           NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                           data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                           imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                           [data writeToFile:imagePath atomically:YES];
                           
                           NSLog(@"data.length -:%lu",(unsigned long)data.length);
                           
                           s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                           
                           float floatString = [s floatValue];
                           
                           size = floatString / (1024 * 1024);
                           
                           NSLog(@"size:%.2lf",size);
                           
                           buff = [NSString stringWithFormat:@"%.2lf",size];
                           
                           NSLog(@"图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                           
                           ///文件原名
                           NSLog(@"imagesss:%@",imagesss);
                           /// md5 加密
                           md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                           ///字节数
                           NSLog(@"buffered:%lu",(unsigned long)buffered);
                           /// 后缀名
                           fileExt = self.Dictionary [@"fileExt"];
                           ///id
                           certId = self.Dictionary [@"certId"];
                           
                           NSLog(@"imagesss:%@,md5image:%@,buffered:%lu,fileExt:%@,certId:%@",imagesss,md5image,(unsigned long)buffered,fileExt,certId);
                           
                           NSDictionary *dic = @{@"image":yanzImage,@"filePath":imagesss,@"zhao":buff,@"price":@"",@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s,@"fileExt":fileExt};
                           
                           [self.imageArray addObject:dic];
                           
                           
                           [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeGradient];
                           [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,certId,md5image,imagesss,(unsigned long)buffered,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                               
///================================清除沙盒路径============================
                               [AllObject clearCacheWithFilePath:imagePath];
                               
                               if ([object [@"code"] integerValue] == 200) {
                                   [SVProgressHUD dismiss];
                                   NSDictionary *dic = object[@"data"];
                                   
                                   if ([dic [@"verifyResult"] intValue]== 1)
                                   {
                                       NSLog(@"self.imageArray:%@",self.imageArray);
                                       
                                       ResultsViewController *result = [[ResultsViewController alloc]init];
                                       result.Dictionary = self.Dictionary;
                                       result.image = yanzImage;
                                       result.imageArray = self.imageArray;
                                       result.data = dic ;
                                       [self.navigationController pushViewController:result animated:YES];
                                       
                                   }
                                   else if ([dic [@"verifyResult"] intValue]== 0){
                                       
                                       ShibaiViewController *shibai = [[ShibaiViewController alloc]init];
                                       shibai.Dictionary =  self.Dictionary;
                                       shibai.image = yanzImage;
                                       shibai.data = dic;
                                       [self.navigationController pushViewController:shibai animated:YES];
                                       
                                   }
                                   
                               }else{
                                   ///验证失败后就删除数组里面的值
                                   [self.imageArray removeAllObjects];
                                   
 ///================================清除沙盒路径============================
                                   [AllObject clearCacheWithFilePath:imagePath];
                                   
                                   [SVProgressHUD dismiss];
                                   [SVProgressHUD showErrorWithStatus:@"操作失败！" duration:2.0];
                               }
                               
                           } andFailed:^(NSString *object) {
                                [SVProgressHUD showErrorWithStatus:@"网络错误"];
                           }];
                           
                       } failureBlock:nil];
                   }
                   
               };
               
               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
               [assetslibrary assetForURL:imageURL
                              resultBlock:resultblock
                
                             failureBlock:nil];
               
               
           }
           
           
           
       }
       else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
       {
           
           NSLog(@"--选取的是视频-----------");
           NSString *videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
           NSLog(@"url:%@",videoPath);
           //先把图片转成NSDatas
           UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
           ///得到图片原来的名称
           __block NSString *imagesss;
           __block double size;
           
           NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
           NSLog(@"imageURL:%@",imageURL);
           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
           {
               ALAssetRepresentation *representation = [myasset defaultRepresentation];
               imagesss = [representation filename];
               __block NSData *data;
               __block NSString *md5image;
               __block  NSString * imagePath;
               __block NSUInteger buffered;
               __block  NSString *buff;
               __block  NSString *fileExt;
               __block NSString *s;
               // 如何判断已经转化了,通过是否存在文件路径
               ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
               // 创建存放原始图的文件夹--->OriginalPhotoImages
               NSFileManager * fileManager1 = [NSFileManager defaultManager];
               if (![fileManager1 fileExistsAtPath:KVideoUrlPath]) {
                   [fileManager1 createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
               }
               if (imageURL) {
                   // 主要方法
                   [assetLibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                       ALAssetRepresentation *rep = [asset defaultRepresentation];
                       Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                       buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                       NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                       data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                       imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                       [data writeToFile:imagePath atomically:YES];
                       
                       NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                       /// 图片data转换成NSString
                       NSString *endimage = [data base64Encoding];
                       //
                       NSLog(@"data.length -:%lu",(unsigned long)data.length);
                       ///md5 加密
                       md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                       ///计算图片大小
                       s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                       
                       float floatString = [s floatValue];
                       
                       size = floatString / (1024 * 1024);
                       
                       NSLog(@"size:%.2lf",size);
                       buff = [NSString stringWithFormat:@"%.2lf",size];
                       /// 后缀名
                       fileExt = self.Dictionary [@"fileExt"];
                       
                       NSLog(@"视频的图片++++++++++++++++++++++:%@",image);
                       NSLog(@"视频的名字++++++++++++++++++++++:%@",imagesss);
                       NSLog(@"视频的大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@",buff);
                       NSLog(@"视频的md5++++++++++++++++++++++:%@",md5image);
                       NSLog(@"视频的路径++++++++++++++++++++++:%@",imagePath);
                       NSLog(@"视频的s++++++++++++++++++++++:%@",s);
                       
                       NSDictionary *dic = @{@"image":@"",@"filePath":imagesss,@"zhao":buff,@"price":@"",@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s};
                       
                       [self.imageArray addObject:dic];
                       
                       [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeGradient];
                       [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],md5image,imagesss,(unsigned long)buffered,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                           
///================================清除沙盒路径============================
                           [AllObject clearCacheWithFilePath:imagePath];
                           
                           if ([object [@"code"] integerValue] == 200) {
                               [SVProgressHUD dismiss];
                               NSDictionary *dic = object[@"data"];
                               
                               if ([dic [@"verifyResult"] intValue]== 1)
                               {
                                   NSLog(@"self.imageArray:%@",self.imageArray);
                                   
                                   ResultsViewController *result = [[ResultsViewController alloc]init];
                                   result.Dictionary = self.Dictionary;
                                   result.image = yanzImage;
                                   result.imageArray = self.imageArray;
                                   result.data = dic ;
                                   [self.navigationController pushViewController:result animated:YES];
                                   
                               }
                               else if ([dic [@"verifyResult"] intValue]== 0){
                                   
                                   ShibaiViewController *shibai = [[ShibaiViewController alloc]init];
                                   shibai.Dictionary =  self.Dictionary;
                                   shibai.image = yanzImage;
                                   shibai.data = dic;
                                   [self.navigationController pushViewController:shibai animated:YES];
                                   
                               }
                               
                           }else{
                               ///验证失败后就删除数组里面的值
                               [self.imageArray removeAllObjects];
                               
///================================清除沙盒路径============================
                               [AllObject clearCacheWithFilePath:imagePath];
                               
                               [SVProgressHUD dismiss];
                               [SVProgressHUD showErrorWithStatus:@"操作失败！" duration:2.0];
                           }
                           
                       } andFailed:^(NSString *object) {
                            [SVProgressHUD showErrorWithStatus:@"网络错误"];
                       }];
                       
                       
                   } failureBlock:nil];
               }
               
           };
           ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
           [assetslibrary assetForURL:imageURL
                          resultBlock:resultblock
            
                         failureBlock:nil];
           
       }

    }
//  indexpaths == 20  是出证选取的图片
    else if (indexpaths == 20)
    {
    
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
        {
            NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
            
            ///得到路径和图片
            if ([type isEqualToString:@"public.image"]) {
                //先把图片转成NSDatas
                yanzImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                ///得到图片原来的名称
                __block NSString *imagesss;
                __block double size;
                
                NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    imagesss = [representation filename];
                    NSLog(@"图片名称＋＋＋＋＋＋＋＋＋＋＋＋＋::%@",imagesss);
                    
                    NSURL *urlname = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
                    
                    __block NSData *data;
                    __block NSString *md5image;
                    __block  NSString * imagePath;
                    __block NSUInteger buffered;
                    __block  NSString *buff;
                    __block  NSString *fileExt;
                    __block  NSString *certId;
                    __block NSString *s;
                    
                    // 如何判断已经转化了,通过是否存在文件路径
                    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                    // 创建存放原始图的文件夹--->OriginalPhotoImages
                    NSFileManager * fileManager1 = [NSFileManager defaultManager];
                    if (![fileManager1 fileExistsAtPath:KOriginalPhotoImagePath]) {
                        [fileManager1 createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    if (urlname) {
                        // 主要方法
                        [assetLibrary assetForURL:urlname resultBlock:^(ALAsset *asset) {
                            ALAssetRepresentation *rep = [asset defaultRepresentation];
                            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                            buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                            NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                            data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                            imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                            [data writeToFile:imagePath atomically:YES];
                            NSLog(@"data.length -:%lu",(unsigned long)data.length);
                            
                            s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                            
                            float floatString = [s floatValue];
                            
                            size = floatString / (1024 * 1024);
                            
                            NSLog(@"size:%.2lf",size);
                            
                            buff = [NSString stringWithFormat:@"%.2lf",size];
                            
                            NSLog(@"图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                            
                            ///文件原名
                            NSLog(@"imagesss:%@",imagesss);
                            /// md5 加密
                            md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                            ///字节数
                            NSLog(@"buffered:%lu",(unsigned long)buffered);
                            /// 后缀名
                            fileExt = self.Dictionary [@"fileExt"];
                            ///id
                            certId = self.Dictionary [@"certId"];
                            
                            NSLog(@"imagesss:%@,md5image:%@,buffered:%lu,fileExt:%@,certId:%@",imagesss,md5image,(unsigned long)buffered,fileExt,certId);
     
                            [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,certId,md5image,imagesss,(unsigned long)buffered,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                                
///================================清除沙盒路径============================
                                [AllObject clearCacheWithFilePath:imagePath];
                                
                                if ([object [@"code"] integerValue] == 200) {
                                    
                                    NSDictionary *dic = object[@"data"];
                                    
                                    if ([dic [@"verifyResult"] intValue] == 0) {
                                        [SVProgressHUD showErrorWithStatus:@"验证失败！" duration:2.0];
                                        ///验证失败后就返回到证书详情
                                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                    }else if ([dic [@"verifyResult"] intValue] == 1){
                                        
                                        [SVProgressHUD showSuccessWithStatus:@"验证成功" duration:2.0];
                                        ///跳转到出征须知界面
                                        XuzhiViewController *xuzhi = [[XuzhiViewController alloc]init];
                                        xuzhi.fileID = self.fileid;
                                        xuzhi.Dictionary = self.Dictionary;
                                        xuzhi.image = yanzImage;
//                                        xuzhi.storageState = _storageState;
                                        [self.navigationController pushViewController:xuzhi  animated:YES];
                                    }
                                    
                                }else{
                                }
                                
                            } andFailed:^(NSString *object) {
                                 [SVProgressHUD showErrorWithStatus:@"网络错误"];
                            }];
                            
                            
                        } failureBlock:nil];
                    }
                    
                };
                
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:imageURL
                               resultBlock:resultblock
                 
                              failureBlock:nil];
                
                
            }
            
        }
        else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
        {
            
            NSLog(@"--选取的是视频-----------");
            NSString *videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"url:%@",videoPath);
            //先把图片转成NSDatas
            UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            ///得到图片原来的名称
            __block NSString *imagesss;
            __block double size;
            
            NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            NSLog(@"imageURL:%@",imageURL);
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *representation = [myasset defaultRepresentation];
                imagesss = [representation filename];
                __block NSData *data;
                __block NSString *md5image;
                __block  NSString * imagePath;
                __block NSUInteger buffered;
                __block  NSString *buff;
                __block  NSString *fileExt;
                __block NSString *s;
                // 如何判断已经转化了,通过是否存在文件路径
                ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                // 创建存放原始图的文件夹--->OriginalPhotoImages
                NSFileManager * fileManager1 = [NSFileManager defaultManager];
                if (![fileManager1 fileExistsAtPath:KVideoUrlPath]) {
                    [fileManager1 createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                if (imageURL) {
                    // 主要方法
                    [assetLibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *rep = [asset defaultRepresentation];
                        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                        buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                        NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                        data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                        imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                        [data writeToFile:imagePath atomically:YES];

                        NSLog(@"data.length -:%lu",(unsigned long)data.length);
                        ///md5 加密
                        md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                        ///计算图片大小
                        s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                        
                        float floatString = [s floatValue];
                        
                        size = floatString / (1024 * 1024);
                        
                        NSLog(@"size:%.2lf",size);
                        buff = [NSString stringWithFormat:@"%.2lf",size];
                        /// 后缀名
                        fileExt = self.Dictionary [@"fileExt"];
                        
                        NSLog(@"视频的图片++++++++++++++++++++++:%@",image);
                        NSLog(@"视频的名字++++++++++++++++++++++:%@",imagesss);
                        NSLog(@"视频的大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@",buff);
                        NSLog(@"视频的md5++++++++++++++++++++++:%@",md5image);
                        NSLog(@"视频的路径++++++++++++++++++++++:%@",imagePath);
                        NSLog(@"视频的s++++++++++++++++++++++:%@",s);
    
                        [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],md5image,imagesss,(unsigned long)data.length,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                            
 ///================================清除沙盒路径============================
                            [AllObject clearCacheWithFilePath:imagePath];
                            
                            if ([object [@"code"] integerValue] == 200) {
                                
                                NSDictionary *dic = object[@"data"];
                                
                                if ([dic [@"verifyResult"] intValue] == 0) {
                                    [SVProgressHUD showErrorWithStatus:@"验证失败！" duration:2.0];
                                    ///验证失败后就返回到证书详情
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                }else if ([dic [@"verifyResult"] intValue] == 1){
                                    
                                    [SVProgressHUD showSuccessWithStatus:@"验证成功" duration:2.0];
                                    ///跳转到出征须知界面
                                    XuzhiViewController *xuzhi = [[XuzhiViewController alloc]init];
                                    xuzhi.fileID = self.fileid;
                                    xuzhi.Dictionary = self.Dictionary;
                                    xuzhi.image = yanzImage;
                                    [self.navigationController pushViewController:xuzhi  animated:YES];
                                    
                                }
                                
                            }else{
                            }
                            
                        } andFailed:^(NSString *object) {
                             [SVProgressHUD showErrorWithStatus:@"网络错误"];
                        }];
                        
                        
                        
                    } failureBlock:nil];
                }
                
            };
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:imageURL
                           resultBlock:resultblock
             
                          failureBlock:nil];
            
        }
    }
}


#pragma mark - 把图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
        [alert show];
    }
    
}

#pragma mark - right -1
- (void)yanjingBtnClick:(UIButton *)sender{
    
    if (sender.selected) {
        NSLog(@"开启");
        sender.selected = NO;
        
        [[TSCCntc sharedCntc] queryWithPoint:@"setAccessState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&accessState=%d",[User shareUser].appKey,[User shareUser].authToken,self.fileid,0] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            NSLog(@"object:%@",object);
            if ([object [@"code"] integerValue] == 200) {
                [OMGToast showWithText:@"公开成功"];
                [yanjingBtn setImage:[UIImage imageNamed:@"unlock@2x.png"] forState:UIControlStateNormal];
                [self httprestsTableviewFile];
            }else{
                [OMGToast showWithText:object[@"msg"]];
            }
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }else{
        NSLog(@"关闭");
        sender.selected = YES;
        
        
        [[TSCCntc sharedCntc] queryWithPoint:@"setAccessState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&accessState=%d",[User shareUser].appKey,[User shareUser].authToken,self.fileid,1] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            NSLog(@"object:%@",object);
            if ([object [@"code"] integerValue] == 200) {
                [OMGToast showWithText:@"关闭公开成功"];
                [yanjingBtn setImage:[UIImage imageNamed:@"lock@2x.png"] forState:UIControlStateNormal];
                [self httprestsTableviewFile];
            }else{
                [OMGToast showWithText:object[@"msg"]];
            }
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }
}

#pragma mark-right 2
- (void)xinxinClick:(UIButton *)sender
{
    
    if ([self.Dictionary [@"collectStatus"] intValue] == 0)
    {
        [[TSCCntc sharedCntc] queryWithPoint:@"mark" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&actType＝%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid,@"1"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            if ([object [@"code"] integerValue] == 200) {
                [OMGToast showWithText:@"标记成功"];
                [timeBtn setImage:[UIImage imageNamed:@"mark@2x.png"] forState:UIControlStateNormal];
                [self httprestsTableviewFile];
            }else{
                [OMGToast showWithText:@"标记失败"];
            }
        } andFailed:^(NSString *object) {
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }
    else if ([self.Dictionary [@"collectStatus"] intValue] == 1)
    {
        [[TSCCntc sharedCntc] queryWithPoint:@"mark" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&actType=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid,@"2"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            if ([object [@"code"] integerValue] == 200) {
                [OMGToast showWithText:@"取消标记"];
                [timeBtn setImage:[UIImage imageNamed:@"unmark@2x.png"] forState:UIControlStateNormal];
                [self httprestsTableviewFile];
            }else{
                [OMGToast showWithText:@"取消标记失败"];
            }
        } andFailed:^(NSString *object) {
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }
    else if ([self.Dictionary [@"collectStatus"] intValue] == 2)
    {
        [[TSCCntc sharedCntc] queryWithPoint:@"mark" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&actType＝%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid,@"1"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            if ([object [@"code"] integerValue] == 200) {
                [OMGToast showWithText:@"标记成功"];
                [timeBtn setImage:[UIImage imageNamed:@"mark@2x.png"] forState:UIControlStateNormal];
                [self httprestsTableviewFile];
            }else{
                [OMGToast showWithText:@"标记失败"];
            }
        } andFailed:^(NSString *object) {
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }
}
#pragma mark-right 3
- (void)diandiandianClick:(UIButton *)sender
{
    CGPoint point = CGPointMake(searchBtn.center.x,searchBtn.frame.origin.y + 60);
    view1 = [[XTPopView alloc] initWithOrigin:point Width:100 Height:40 * 3 Type:XTTypeOfUpRight Color:[UIColor blackColor]];
    view1.dataArray = @[@"备注",@"移动",@"删除",];
    view1.fontSize = screen_width / 25;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor whiteColor];
    view1.delegate = self;
    [view1 popView];
    
    NSLog(@"点击了右上角按钮2");
}
- (void)selectIndexPathRow:(NSInteger)indexpathrow
{
    switch (indexpathrow) {
        case 0:
        {
            NSLog(@"备注");
            
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"档案备注" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入档案备注名";
                textField.secureTextEntry = NO;
            }];
            
            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 读取文本框的值显示出来
                userEmail = alertDialog.textFields.firstObject;
                userEmail.delegate = self;
                NSLog(@"请输入档案备注名的值%@",userEmail.text);
                if (userEmail.text.length != 0) {
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"remarks" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&remarks=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid,userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                        if ([object [@"code"] integerValue] == 200) {
                            
                            [self httprestsTableviewFile];
                            [OMGToast showWithText:@"修改备注成功"];
                            
                        }else{
                            [OMGToast showWithText:@"修改备注失败"];
                        }
                    } andFailed:^(NSString *object) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                }else{
                    
                }
            }];
            // 添加操作（顺序就是呈现的上下顺序）
            [alertDialog addAction:quxiao];
            [alertDialog addAction:Okaction];
            // 呈现警告视图
            [self presentViewController:alertDialog animated:YES completion:nil];
            
            [view1 removeFromSuperview];
        }
            break;
        case 1:
        {
            NSLog(@"移动");
            
            NSString* fileid = self.Dictionary [@"certId"];
            
            NSDictionary *dic = @{@"id":fileid,@"listBy":@"2"};
            
            [self.deleteArr addObject:dic];
            
            NSString *list = [self.deleteArr JSONString];
            
            mobileViewController *moble = [[mobileViewController alloc]init];
            moble.fileid = list;
            moble.arrayCount = @"1";
            moble.mobileType = @"20";
            [self.navigationController pushViewController:moble animated:YES];
            [view1 removeFromSuperview];
        }
            break;
        case 2:
        {
            NSLog(@"删除");
NSLog(@"删除证书的状态：%d",[User shareUser].zhenshuDelete);
            ///没设置安全设置
            if ([User shareUser].zhenshuDelete== 0) {
                
                ///没有设置不再提醒
                if ([User shareUser].Noremind == 0) {
                    
                    ProfileAlertView *alertView = [[ProfileAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)withGroupNumber:10];
                    alertView.delegate = self;
                    alertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.7];
                    [self.view.window addSubview:alertView];
                    
                    buzaitixing = 1;
                }
                ///设置了不再提醒
                else if ([User shareUser].Noremind == 1)
                {
                
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"是否确定删除证书" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                            if ([object [@"code"] integerValue] == 200) {
                                
                                [self.navigationController popViewControllerAnimated:YES];///删除成功后返回上一页
                                [SVProgressHUD showSuccessWithStatus:@"删除证书成功"];
                                
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"删除证书失败"];
                            }
                        } andFailed:^(NSString *object) {
                            [SVProgressHUD showErrorWithStatus:@"网络错误"];
                        }];
                        
                        NSLog(@"确定");
                    }];
                    // 添加操作（顺序就是呈现的上下顺序）
                    [alertDialog addAction:quxiao];
                    [alertDialog addAction:Okaction];
                    // 呈现警告视图
                    [self presentViewController:alertDialog animated:YES completion:nil];
                }
            }
            ///设置了不启用直接删除
            else if ([User shareUser].zhenshuDelete == 10)
            {
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确定删除证书" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                        if ([object [@"code"] integerValue] == 200) {
                            
                            [self.navigationController popViewControllerAnimated:YES];///删除成功后返回上一页
                            [SVProgressHUD showSuccessWithStatus:@"删除证书成功"];
                            
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"删除证书失败"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                  
                    NSLog(@"确定");
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
    
            }
            ///设置了密码验证
            else if([User shareUser].zhenshuDelete == 30)
            {
                ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
                pwdAlert.title = @"请输入验证密码";
                [pwdAlert show];
                pwdAlert.completeAction = ^(NSString *pwd) {
                    NSLog(@"输入的密码:%@", pwd);
                    [[TSCCntc sharedCntc] queryWithPoint:@"verifySafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,pwd] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                        NSLog(@"删除证书验证密码数据:%@",object);
                        if ([object [@"code"] integerValue] == 200) {
                            
                            NSDictionary *dic = object [@"data"];
                            if ([dic [@"result"] integerValue] == 1) {
                                
                                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确定删除证书" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"取消");
                                }];
                                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                                        if ([object [@"code"] integerValue] == 200) {
                                            
                                            [self.navigationController popViewControllerAnimated:YES];///删除成功后返回上一页
                                            [SVProgressHUD showSuccessWithStatus:@"删除证书成功"];
                                            
                                        }else{
                                            [SVProgressHUD showErrorWithStatus:@"删除证书失败"];
                                        }
                                    } andFailed:^(NSString *object) {
                                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                                    }];
                                    NSLog(@"确定");
                                }];
                                // 添加操作（顺序就是呈现的上下顺序）
                                [alertDialog addAction:quxiao];
                                [alertDialog addAction:Okaction];
                                // 呈现警告视图
                                [self presentViewController:alertDialog animated:YES completion:nil];
                            }
                            else
                            {
                                
                             [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                            
                            }
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                };
                
            }
            ///设置了指纹验证
            else if ([User shareUser].zhenshuDelete == 40)
            {
                WJTouchID *touchid = [[WJTouchID alloc]init];
                self.touchID = touchid;
                touchid.delegate = self;
                touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
                [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
             
                index = 2;
            }

            [view1 removeFromSuperview];
        }
            break;
        default:
            break;
    }
}
/**
 *  TouchID验证成功就删除证书
 *
 *  (English Comments) Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
 
/*
 
 index == 1  是证书出证     index ＝=  2 是删除证书
 */
//  index ＝=  2 是删除证书
    if (index == 2) {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认删除证书？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                if ([object [@"code"] integerValue] == 200) {
                    
                    [self.navigationController popViewControllerAnimated:YES];///删除成功后返回上一页
                    [SVProgressHUD showSuccessWithStatus:@"删除证书成功"];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除证书失败"];
                }
            } andFailed:^(NSString *object) {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
            NSLog(@"确定");
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }
    
//index == 1  证书出证
    else if (index == 1)
    {
        
        if ([self.Dictionary [@"fileType"] intValue] == 40) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            [self presentModalViewController:imagePicker animated:YES];
            
        }else if ([self.Dictionary [@"fileType"] intValue] == 20){
            
            ///选择图片
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }

    NSLog(@"line 37: %@",WJNotice(@"TouchID验证成功", @"TouchID验证成功"));
}
/**
 *  TouchID验证失败
 *
 *  (English Comments) Authentication Failure
 */
- (void) WJTouchIDAuthorizeFailure {
    NSLog(@"line 46: %@",WJNotice(@"TouchID验证失败", @"TouchID验证失败") );
    [SVProgressHUD showErrorWithStatus:@"TouchID验证失败" duration:2.0];
}
///这个是不在提醒按钮的操作
- (void) confirmButtonDidCilckedIsSetChat:(BOOL) isChat {
    NSLog(@"%d",isChat);
    
    if (buzaitixing == 1) {
        
        NSLog(@"进入了删除证书");
        NSLog(@"[user share].Noremind;%d",[User shareUser].Noremind);
        
        if (isChat) {
            NSLog(@"勾选了");
            [User shareUser].Noremind = 1;
            [User saveUserInfo];
            NSLog(@"[user share].Noremind;%d",[User shareUser].Noremind);
            
        }else{
            NSLog(@"没有勾选");
        }
    }else if(buzaitixing == 2){
    
        NSLog(@"进入了证书出证");
        
        NSLog(@"[user share].zhengshuchuzhengNoremind;%d",[User shareUser].zhengshuchuzhengNoremind);
        
        if (isChat) {
            NSLog(@"勾选了");
            [User shareUser].zhengshuchuzhengNoremind = 1;
            [User saveUserInfo];
            NSLog(@"[user share].zhengshuchuzhengNoremind;%d",[User shareUser].zhengshuchuzhengNoremind);
            
        }else{
            NSLog(@"没有勾选");
        }
    
    }
}
///这个是点击了前往设置按钮
- (void)conqianwangshezClickButton{
    NSLog(@"点击了前往设置");
    SecurityViewController *secur = [[SecurityViewController alloc]init];
    [self.navigationController pushViewController:secur animated:YES];
    [view1 removeFromSuperview];

}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)getFileName
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyyMMddHHmmss";
    NSString * str              = [formatter stringFromDate:[NSDate date]];
    NSString * fileName         = [NSString stringWithFormat:@"%@.png", str];
    return fileName;
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePaths{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePaths]){
        return [[manager attributesOfItemAtPath:filePaths error:nil] fileSize] / 1024 / 5;
    }
    return 0;
}



///关闭POPview
- (void)classPopView2{
    
    [UIView animateWithDuration:0.5 animations:^{
        blackView.frame = CGRectMake(0, screen_height + screen_height, screen_width, screen_height);
        wirthView.frame = CGRectMake(0, screen_height + 165, screen_width, 150);
    }];
}
///视图出现
- (void)showclassPopview{
    
    [UIView animateWithDuration:0.5 animations:^{
        blackView.frame = CGRectMake(0, -64, screen_width, screen_height + 64);
        wirthView.frame = CGRectMake(15, screen_height - 96, screen_width - 30, 150);
    }];
}
///点击黑色区域隐藏popview
- (void)balck2Click{
    [self classPopView2];
}
///点击黑色区域隐藏popview
- (void)lableviewclick2{
    [self classPopView2];
}
#define kMainWindow [UIApplication sharedApplication].windows.lastObject
///发送按钮的点击事件
- (void)getfasongButton{
    
    blackView = [UIView new];
    blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    blackView.userInteractionEnabled = YES;
    [kMainWindow addSubview:blackView];
    
    UITapGestureRecognizer *tap111= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balck2Click)];
    [blackView addGestureRecognizer:tap111];
    wirthView = [[UIView alloc]init];
    wirthView.backgroundColor = [UIColor whiteColor];
    wirthView.layer.cornerRadius = 10.0;
    wirthView.layer.masksToBounds = YES;
    [blackView addSubview:wirthView];
    for (int i = 0; i < 4; i++) {
        NSMutableArray *images1 = [NSMutableArray arrayWithObjects:@"qq_share@2x.png",@"wx_share@2x.png",@"email@2x.png",@"text@2x.png", nil];
        NSMutableArray *titles1 = [NSMutableArray arrayWithObjects:@"QQ好友",@"微信好友",@"邮件发送",@"短信发送", nil];
        MSpopView *btnView = [[MSpopView alloc] initWithFrame:CGRectMake(i * ((screen_width - 15) / 4), 0, (screen_width - 40) / 4, 120) title:titles1 [i] imageStr:images1 [i]];
        btnView.tag = 300 + i;
        [wirthView addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fasongpopView:)];
        [btnView addGestureRecognizer:tap];
    }
    UIView *hen1 = [UIView new];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [wirthView addSubview:hen1];
    [hen1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wirthView.left);
        make.top.equalTo(95);
        make.width.equalTo(wirthView.width);
        make.height.equalTo(1);
    }];
    
    UILabel *lableview = [UILabel new];
    lableview.backgroundColor = [UIColor whiteColor];
    lableview.textAlignment = NSTextAlignmentCenter;
    lableview.text = @"取消";
    lableview.textColor = RGB(167, 197, 253);
    lableview.font = [UIFont systemFontOfSize:18];
    [wirthView addSubview:lableview];
    [lableview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wirthView.left);
        make.top.equalTo(hen1.bottom);
        make.width.equalTo(wirthView.width);
        make.height.equalTo(65);
    }];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableviewclick2)];
    [lableview addGestureRecognizer:tapview];
    
}
#pragma mark - 转换为JSON
- (NSData *)JSONData
{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSJSONSerialization dataWithJSONObject:[self JSONObject] options:kNilOptions error:nil];
}

- (id)JSONObject
{
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]]) {
        return self;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    
    return self.keyValues;
}

- (NSString *)JSONString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}
- (void)NavigationBackItemClick{
    if ([self.chenggongType isEqualToString:@"1"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (userEmail == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}


@end
