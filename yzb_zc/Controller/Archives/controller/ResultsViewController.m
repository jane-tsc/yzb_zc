//
//  ResultsViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ResultsViewController.h"
#import "XiazaiViewController.h"
#import "PayViewController.h"
#import "PayWCViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyMD5.h"
#import "BaycapacityViewController.h"
@interface ResultsViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{

    UIImage * imagephone;///相册反回来的图片
    
    //图片2进制路径
    NSString* filePath;

}
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIButton *yzsBtn;
@property(nonatomic, strong) UIButton *wjdgBtn;
@property(nonatomic, strong) NSDictionary *dic;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *imagenav = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:imagenav forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"保全验证";
    [self setupView];
    
    ///oss 授权
    [self OSSshouquanappkey:[User shareUser].appKey OSSwithauthtoken:[User shareUser].authToken];
    
    NSLog(@"self.data = %@",self.data);
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self httprestWithup];
}

- (void) setupView{
    //   pull_n@2x.png
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(view.top);
        make.width.equalTo(view.width);
        make.height.equalTo(screen_height - 160);
    }];

    NSString *path = [NSString stringWithFormat:@"%@View/verifyResult?verifyAuth=%@",HttpUrl,self.data [@"verifyAuth"]];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    
    if ([self.Dictionary [@"storageState"] intValue] == 1) {
        
        ///查看验证书
        self.yzsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.yzsBtn setTitleColor:RGB(251, 140, 142) forState:UIControlStateNormal];
        [self.yzsBtn setTitle:@"查看验证书" forState:UIControlStateNormal];
        self.yzsBtn.layer.cornerRadius = 15.0;
        [self.yzsBtn setBackgroundColor:[UIColor whiteColor]];
        self.yzsBtn.layer.borderColor = RGB(251, 140, 142).CGColor;
        self.yzsBtn.layer.borderWidth = 1.0;
        self.yzsBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
        [view addSubview:self.yzsBtn];
        [self.yzsBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width / 3);
            make.top.equalTo(self.webView.bottom).offset(20);
            make.width.equalTo(screen_width / 3);
            make.height.equalTo(screen_width / 11);
        }];
        [self.yzsBtn addTarget:self action:@selector(yzsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([self.Dictionary [@"storageState"] intValue] == 0)
    {
       
        ///查看验证书
        self.yzsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.yzsBtn setTitleColor:RGB(251, 140, 142) forState:UIControlStateNormal];
        [self.yzsBtn setTitle:@"查看验证书" forState:UIControlStateNormal];
        self.yzsBtn.layer.cornerRadius = 15.0;
        [self.yzsBtn setBackgroundColor:[UIColor whiteColor]];
        self.yzsBtn.layer.borderColor = RGB(251, 140, 142).CGColor;
        self.yzsBtn.layer.borderWidth = 1.0;
        self.yzsBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
        [view addSubview:self.yzsBtn];
        [self.yzsBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left).offset(30);
            make.top.equalTo(self.webView.bottom).offset(20);
            make.width.equalTo(screen_width / 3);
            make.height.equalTo(screen_width / 11);
        }];
        [self.yzsBtn addTarget:self action:@selector(yzsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
        /// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        ///文件代管
        self.wjdgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.wjdgBtn setTitleColor:RGB(251, 140, 142) forState:UIControlStateNormal];
        [self.wjdgBtn setTitle:@"文件代管" forState:UIControlStateNormal];
        self.wjdgBtn.layer.cornerRadius = 15.0;
        self.wjdgBtn.layer.borderColor = RGB(251, 140, 142).CGColor;
        self.wjdgBtn.layer.borderWidth = 1.0;
        self.wjdgBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
        [view addSubview:self.wjdgBtn];
        [self.wjdgBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.right).offset( - 30 -  screen_width / 3);
            make.top.equalTo(self.webView.bottom).offset(20);
            make.width.equalTo(screen_width / 3);
            make.height.equalTo(screen_width / 11);
        }];
        [self.wjdgBtn addTarget:self action:@selector(wjdgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

///查看验证书
- (void)yzsBtnClick:(UIButton *)sender{
    XiazaiViewController *xiazai = [[XiazaiViewController alloc]init];
    xiazai.data = self.data;
    [self.navigationController pushViewController:xiazai animated:YES];
}

///文件代管
- (void)wjdgBtnClick:(UIButton *)sender{

    
    //／没开通空间
    if ([[User shareUser].sizeUsed intValue] == 0) {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"未开通空间，请前往开通空间" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
            bayca.NOType = @"900";
            NSLog(@"bayca.NOType:%@",bayca.NOType);
            [self.navigationController pushViewController:bayca animated:YES];
            
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }
    //判断空间是否足够，不够请前往购买
    else if ([[User shareUser].restSize integerValue] == 0)
    {
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间容量不足，请前往开通" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
            bayca.NOType = @"900";
            NSLog(@"bayca.NOType:%@",bayca.NOType);
            [self.navigationController pushViewController:bayca animated:YES];
            
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }else{
    
    NSLog(@"self.Dictionary:%@,  self.imagearray:%@",self.Dictionary,self.imageArray);
    
    [[TSCCntc sharedCntc] queryWithPoint:@"setCertFile" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],self.Dictionary [@"fileHash"]] andURL:@"Verify" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = object [@"data"];
            NSLog(@"dic:%@",dic);
            
            if ([dic [@"verifyResult"] intValue] == 1) {

                PayWCViewController *pay = [[PayWCViewController alloc]init];
                pay.Dictionary = self.Dictionary;
                pay.imageArray = self.imageArray;
                pay.yanzhenDic = dic;///dic 是验证后返回的数据
                pay.paytype = @"1";
                [self.navigationController pushViewController:pay animated:YES];
                
            }else {

                [OMGToast showWithText:@"文件验证失败！"];
            }
            
        }
        else if ([object [@"code"] integerValue] == 4014){
        
            [SVProgressHUD dismiss];
            
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                [self.navigationController pushViewController:bayca animated:YES];
                
            }];
            // 添加操作（顺序就是呈现的上下顺序）
            [alertDialog addAction:quxiao];
            [alertDialog addAction:Okaction];
            // 呈现警告视图
            [self presentViewController:alertDialog animated:YES completion:nil];
            
        }
        else{
            
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object [@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];

    }
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载webview");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
    //    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败");
    //    [SVProgressHUD dismiss];
}

- (NSString *)getFileName
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyyMMddHHmmss";
    NSString * str              = [formatter stringFromDate:[NSDate date]];
    NSString * fileName         = [NSString stringWithFormat:@"%@.png", str];
    return fileName;
}

- (void)NavigationBackItemClick{
    
    if ([self.shibaiType isEqualToString:@"2"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }else{
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
    }else{
        BaycapacityViewController *baycapacity = [[BaycapacityViewController alloc]init];
        [self.navigationController pushViewController:baycapacity animated:YES];
    }
}
- (void)httprestWithup{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            [User shareUser].defaultAddressId           = object [@"data"] [@"defaultAddressId"];
            [User shareUser].delCertState               = object [@"data"] [@"delCertState"];
            [User shareUser].delFileState               = object [@"data"] [@"delFileState"];
            [User shareUser].downFileState              = object [@"data"] [@"downFileState"];
            [User shareUser].numExpires                 = object [@"data"] [@"numExpires"];
            [User shareUser].numUsed                    = object [@"data"] [@"numUsed"];
            [User shareUser].restSize                    = object [@"data"] [@"restSize"];
            [User shareUser].securityRestNum            = object [@"data"] [@"securityRestNum"];
            [User shareUser].securityTotalNum           = object [@"data"] [@"securityTotalNum"];
            [User shareUser].securityTotalSize          = object [@"data"] [@"securityTotalSize"];
            [User shareUser].securityUsedNum            = object [@"data"] [@"securityUsedNum"];
            [User shareUser].securityUsedSize           = object [@"data"] [@"securityUsedSize"];
            [User shareUser].sizeExpires                = object [@"data"] [@"sizeExpires"];
            [User shareUser].sizeUsed                   = object [@"data"] [@"sizeUsed"];
            [User shareUser].testRestNum                = object [@"data"] [@"testRestNum"];
            [User shareUser].testTotalNum               = object [@"data"] [@"testTotalNum"];
            [User shareUser].testifyType                = object [@"data"] [@"testifyType"];
            [User shareUser].totalSize                  = object [@"data"] [@"totalSize"];
            [User shareUser].usedStatus                 = object [@"data"] [@"usedStatus"];
            [User shareUser].userAvatar                 = object [@"data"] [@"userAvatar"];
            [User shareUser].userName                   = object [@"data"] [@"userName"];
            [User shareUser].userSex                    = object [@"data"] [@"userSex"];
            [User shareUser].userSn                     = object [@"data"] [@"userSn"];
            [User shareUser].userTel                    = object [@"data"] [@"userTel"];
            [User shareUser].verifyType                 = object [@"data"] [@"verifyType"];
            
            [User saveUserInfo];
            NSLog(@"剩余空间:%@",[User shareUser].restSize);
            
        }else{
            
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

/// oss 授权
- (void)OSSshouquanappkey:(NSString *)appkey OSSwithauthtoken:(NSString *)authtoken{
    
    ///获取临时授权
    [[TSCCntc sharedCntc] queryWithPoint:@"getOssAppToken" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",appkey,authtoken] andURL:@"UpAuth" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            [User shareUser].upExpires = object [@"data"] [@"upExpires"];
            [User shareUser].upHost = object [@"data"] [@"upHost"];
            [User shareUser].upKeyId = object [@"data"] [@"upKeyId"];
            [User shareUser].upKeySecret = object [@"data"] [@"upKeySecret"];
            [User shareUser].upPath = object [@"data"] [@"upPath"];
            [User shareUser].upSubPath = object [@"data"] [@"upSubPath"];
            [User shareUser].upToken = object [@"data"] [@"upToken"];
            [User saveUserInfo];
            
        }else{
            [OMGToast showWithText:@"授权失败！"];
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
