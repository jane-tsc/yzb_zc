//
//  TheViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "TheViewController.h"
#import "ArchivesViewController.h"
@interface TheViewController ()<UIWebViewDelegate>{
    
}
@property(nonatomic,strong) UIButton *backButton;///返回首页按钮
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation TheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.title = @"出证结果";
    [self setupView];
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
        make.height.equalTo(500);
    }];
    
    NSString *path = [NSString stringWithFormat:@"%@View/testifyResult",HttpUrl];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    
    ///确认支付
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 15.0;
    [self.backButton setBackgroundColor:RGB(251, 140, 142)];
    self.backButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.backButton.layer.shadowOpacity = 0.5;
    self.backButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.backButton];
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(self.webView.bottom).offset(30);
        make.width.equalTo(screen_width / 2.4);
        make.height.equalTo(31);
    }];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark - 返回首页
- (void)backButtonClick:(UIButton *)sender{
    NSLog(@"返回首页");
   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)NavigationBackItemClick{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
