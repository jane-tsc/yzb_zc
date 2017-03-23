//
//  HomeViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ViewController.h"
#import "Public.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extensions.h"
#import "Constants.h"
#import "MessageViewController.h"
#import "ArchivesViewController.h"
#import "Rapid1ViewController.h"
#import "OpenpreservationViewController.h"
#import "BaycapacityViewController.h"

@interface ViewController ()<UIWebViewDelegate>{
    
    UIView *view;
    UIView *view1;
    UIView *view2;
    UIWebView *webview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(25, 25, 33 , 1);
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *image = [UIImage imageWithColor:RGBA(25, 25, 33 , 1)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.title = @"云证保";
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64,  screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    navView.backgroundColor = [UIColor clearColor];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    UILabel *navtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, screen_width, 44)];
    navtitle.text =@"云证保";
    navtitle.userInteractionEnabled = YES;
    navtitle.textColor = [UIColor whiteColor];
    navtitle.font = [UIFont systemFontOfSize:NacFontsize];
    navtitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:navtitle];
    ///左按钮
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 30, 25, 25)];
    leftImage.image = [UIImage imageNamed:@"gr_homepage-n"];
    leftImage.userInteractionEnabled = YES;
    [navView addSubview:leftImage];
    UITapGestureRecognizer *leftImagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickLeftItemleft)];
    [leftImage addGestureRecognizer:leftImagetap];
    ///右按钮
    UIImageView *rigthImage = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width - 37, 30, 25, 25)];
    rigthImage.image = [UIImage imageNamed:@"imfor_homepage-nor"];
    rigthImage.userInteractionEnabled = YES;
    [navView addSubview:rigthImage];
    UITapGestureRecognizer *rigthImagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickRigthItemrigth)];
    [rigthImage addGestureRecognizer:rigthImagetap];
    
    [self setWithbanner];
    [self setupView];

}

- (void)viewWillAppear:(BOOL)animated{

    UIImage *image = [UIImage imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    ///已进入这个界面就隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"-----++++++++++appkey :%@-- authToken:%@, 电话：%@,,,名字：%@,,身份证：%@,,头像：%@,,,性别: %@,,,地址：％@ mdgID:%@",[User shareUser].appKey,[User shareUser].authToken,[User shareUser].userTel,[User shareUser].userName,[User shareUser].userSn,[User shareUser].userAvatar,[User shareUser].userSex,[User shareUser].msgId);
    
    [self httprestWithup];
    view1.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cehuaNotification" object:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    ///一离开这个界面就不隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    //    设置 状态栏的颜色
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cehuaNotification" object:nil];
}

- (void)onClickLeftItemleft
{

    //发送通知，执行侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLeftSlide object:nil];
}
///跳转到消息中心
- (void)onClickRigthItemrigth
{
    MessageViewController *message = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:message animated:YES];
}
- (void)setWithbanner{
    UIImageView *banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height / 1.75)];
    banner.image = [UIImage imageNamed:@"banner.png"];
    banner.userInteractionEnabled = YES;
    [view addSubview:banner];
    
    UILabel *guojia = [[UILabel alloc]init];
    guojia.text = @"国家授时中心";
    guojia.font = [UIFont systemFontOfSize:screen_width / 40];
    guojia.textColor = [UIColor whiteColor];
    [banner addSubview:guojia];
    [guojia makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 2.0 + 10);
        make.top.equalTo(banner.top).offset(33);
        make.height.equalTo(15);
    }];
    ///时间
    webview = [[UIWebView alloc] init];
    webview.backgroundColor = [UIColor clearColor];
    webview.delegate = self;
    webview.scrollView.bounces =NO;/// 设置webview 不能滚动
    webview.scalesPageToFit = YES;
    [banner addSubview:webview];
    [webview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(guojia.right).offset(5);
        make.top.equalTo(banner.top).offset(33);
        make.height.equalTo(14);
        make.width.equalTo(90);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@View/clock",HttpUrl]]];
    [webview loadRequest:request];
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        NSString *path = [NSString stringWithFormat:@"%@View/clock",HttpUrl];
//        NSLog(@"首页国家授时中心时间 ：－－－－－－－－－－－%@",path);
//        NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//           [webview loadRequest:request];
//            
//        });
//        
//    });
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载webview");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败");
}

///homepage_1_normal
///homepage_3_normal

- (void)setupView{
    
    view1 =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - screen_height / 1.9 + 33, screen_width / 2, self.view.frame.size.height - screen_height / 1.9)];
    view1.backgroundColor = [UIColor clearColor];
    view1.userInteractionEnabled = YES;
    [view addSubview:view1];
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(view1.frame.size.width -1, self.view.frame.size.height - screen_height / 2.4, 1, self.view.frame.size.height - screen_height / 1.9)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen];
    view2 =[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 0.5, self.view.frame.size.height - screen_height / 1.9 + 33, screen_width / 2, self.view.frame.size.height - screen_height / 1.9)];
    view2.backgroundColor = [UIColor clearColor];
    view2.userInteractionEnabled = YES;
    [view addSubview:view2];

    
    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:@"homepage_1_normal.png"];
    [view1 addSubview:image];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.frame.size.width / 3.5);
        make.top.equalTo(screen_width / 4.7);
        make.width.equalTo(screen_width / 4.5);
        make.height.equalTo(screen_width / 4.5);
    }];
    UILabel *lable = [UILabel new];
    lable.text = @"快速保全";
    lable.textColor= [UIColor darkGrayColor];
    lable.font = [UIFont systemFontOfSize:screen_width / 21];
    lable.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(image.bottom).offset(5);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(20);
    }];
    
    UILabel *lable1 = [UILabel new];
    lable1.text = @"Elctronic Preservation";
    lable1.textColor= [[UIColor grayColor]colorWithAlphaComponent:0.4];
    lable1.font = [UIFont systemFontOfSize:screen_width / 28];
    lable1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:lable1];
    [lable1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(lable.bottom).offset(1);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(20);
    }];

    UIImageView *image1 = [UIImageView new];
    image1.image = [UIImage imageNamed:@"homepage_3_normal.png"];
    [view2 addSubview:image1];
    [image1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.frame.size.width / 3.5);
        make.top.equalTo(screen_width / 4.7);
        make.width.equalTo(screen_width / 4.5);
        make.height.equalTo(screen_width / 4.5);
    }];
    UILabel *lable2 = [UILabel new];
    lable2.text = @"我的保全";
    lable2.textColor= [UIColor darkGrayColor];
    lable2.font = [UIFont systemFontOfSize:screen_width / 21];
    lable2.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:lable2];
    [lable2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(image.bottom).offset(5);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(20);
    }];
    UILabel *lable3 = [UILabel new];
    lable3.text = @"My Certificate";
    lable3.textColor= [[UIColor grayColor]colorWithAlphaComponent:0.4];
    lable3.font = [UIFont systemFontOfSize:screen_width / 28];
    lable3.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:lable3];
    [lable3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(lable2.bottom).offset(1);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(20);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(View1Click:)];
    [view1 addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(View2Click:)];
    [view2 addGestureRecognizer:tap1];
}

- (void)View1Click:(UITapGestureRecognizer *)sender{
    NSLog(@"快速保全");
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:1.0f];
 
}///防止多次点击
- (void)todoSomething:(id)sender
{
    NSLog(@"点击了按钮");
    
    //在这里做按钮的想做的事情。
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&clientType=%@&versionCode=%@",[User shareUser].appKey,[User shareUser].authToken,@"20",@""] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        view1.userInteractionEnabled = NO;
        
        if ([object [@"code"] integerValue] == 200) {
            
            NSDictionary *dic = object [@"data"];
            
            ///usedStatus ＝ 0是试用
            if ([dic [@"usedStatus"] integerValue] == 0)
            {
                
                ///是否未开通次数
                if([dic [@"numUsed"] integerValue] == 0){
                    
                    NSString *string = [NSString stringWithFormat:@"您可体验%@次（结果无效），建议开通正式服务",dic [@"testRestNum"]];
                    
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"继续体验" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        Rapid1ViewController *rapid = [[Rapid1ViewController alloc]init];
                        rapid.baoquanType = @"电子保全(试用)";
                        rapid.Dictionary = dic;
                        //                    rapid.trialType = @"0";
                        [self.navigationController pushViewController:rapid animated:YES];
                        
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"前往开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        OpenpreservationViewController *open = [[OpenpreservationViewController alloc]init];
                        [self.navigationController pushViewController:open animated:YES];
                        
                    }];
                    // 添加操作（顺序就是呈现的上下顺序）
                    [alertDialog addAction:quxiao];
                    [alertDialog addAction:Okaction];
                    // 呈现警告视图
                    [self presentViewController:alertDialog animated:YES completion:nil];
                    
                }
                ///判断次数是否用完了
                else if ([dic [@"testRestNum"] intValue] == 0) {
                    
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"您的次数已用完，需要成功缴纳服务费后才能使用保全功能" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"前往开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        OpenpreservationViewController *open = [[OpenpreservationViewController alloc]init];
                        [self.navigationController pushViewController:open animated:YES];
                        
                    }];
                    // 添加操作（顺序就是呈现的上下顺序）
                    [alertDialog addAction:quxiao];
                    [alertDialog addAction:Okaction];
                    // 呈现警告视图
                    [self presentViewController:alertDialog animated:YES completion:nil];
                }
                
                
            }
            //
            else if([dic [@"usedStatus"] integerValue] == 1)
            {
                ///次数不足时提醒去购买
                if ([dic [@"securityRestNum"] intValue] == 0) {
                    
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"您的保全剩余次数不足，请前往购买保全次数！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSLog(@"取消");
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"前往购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        OpenpreservationViewController *open = [[OpenpreservationViewController alloc]init];
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
                    
                    Rapid1ViewController *rapid = [[Rapid1ViewController alloc]init];
                    rapid.Dictionary = dic;
                    rapid.baoquanType = @"电子保全";
                    //                    rapid.trialType = @"0";
                    [self.navigationController pushViewController:rapid animated:YES];
                }
                
            }
            
        }else{
            
            [OMGToast showWithText:object [@"msg"]];
            return;
        }
        
    } andFailed:^(NSString *object) {
        
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        
    }];
    
}

- (void)View2Click:(UITapGestureRecognizer *)sender{
    NSLog(@"我的保全");
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.2f];
}
///防止多次点击
- (void)todoSomethingss:(id)sender{
    
    ArchivesViewController *archives = [[ArchivesViewController alloc]init];
    [self.navigationController pushViewController:archives animated:YES];

}

- (void)httprestWithup{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            NSDictionary *dic = object [@"data"];
            
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
            
            NSLog(@"首页类");
        }else{
            
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
