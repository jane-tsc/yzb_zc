//
//  XuzhiViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "XuzhiViewController.h"
#import "FordetailsViewController.h"
@interface XuzhiViewController ()<UIWebViewDelegate>
@property(nonatomic,strong) UIButton *TongYiButton;///同意
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation XuzhiViewController

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
    
    self.title = @"出证须知";
    [self setupView];
}

- (void) setupView{
    UIView *publicView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 64)];
    publicView.backgroundColor = RGB(249, 253, 255);
    [self.view addSubview:publicView];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [publicView addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(publicView.top);
        make.width.equalTo(publicView.width);
        make.height.equalTo(publicView.height).offset(-100);
    }];
    
    self.webView.layer.shadowColor =RGB(237, 245, 255).CGColor;
    self.webView.layer.shadowOpacity = 0.8;
    self.webView.layer.shadowOffset = CGSizeMake(1, 6);
    self.webView.layer.shadowRadius = 3;
    //路径阴影
    UIBezierPath *Bezierpath = [UIBezierPath bezierPath];
    
    float width = self.webView.bounds.size.width;
    float height = self.webView.bounds.size.height;
    float x = self.webView.bounds.origin.x;
    float y = self.webView.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = self.webView.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [Bezierpath moveToPoint:topLeft];
    //添加四个二元曲线
    [Bezierpath addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [Bezierpath addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [Bezierpath addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [Bezierpath addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.webView.layer.shadowPath = Bezierpath.CGPath;
    
     [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    NSString *path = [NSString stringWithFormat:@"%@View/testifyReadMe",HttpUrl];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    
    ///同意按钮
    self.TongYiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.TongYiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.TongYiButton setTitle:@"同意" forState:UIControlStateNormal];
    self.TongYiButton.layer.cornerRadius = 15.0;
    [self.TongYiButton setBackgroundColor:RGB(251, 140, 142)];
    self.TongYiButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.TongYiButton.layer.shadowOpacity = 0.5;
    self.TongYiButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.TongYiButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [publicView addSubview:self.TongYiButton];
    [self.TongYiButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(self.webView.bottom).offset(30);
        make.width.equalTo(screen_width / 2.4);
        make.height.equalTo(screen_width / 11);
    }];
    [self.TongYiButton addTarget:self action:@selector(TongYiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 同意按钮
- (void)TongYiButtonClick:(UIButton *)sender{
    
    FordetailsViewController *forder = [[FordetailsViewController alloc]init];
    forder.fileID = self.fileID;
    forder.Dictionaryaa = self.Dictionary;
    forder.image = self.image;
    [self.navigationController pushViewController:forder animated:YES];
    NSLog(@"同意按钮");
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

- (void)NavigationBackItemClick{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}


@end
