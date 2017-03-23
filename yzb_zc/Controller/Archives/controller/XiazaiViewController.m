//
//  XiazaiViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "XiazaiViewController.h"

@interface XiazaiViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate>{
     NSMutableData* _imageData;
     float _length;
}
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIButton *downloadBtn;
@property(nonatomic, strong) UIImage *imagephoto;
@end

@implementation XiazaiViewController

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
    self.title = @"保全验证";
    //初始化图片数据
    _imageData = [[NSMutableData alloc] init];
    [self setupView];
    
    NSString *path = [NSString stringWithFormat:@"%@View/downVerifyCert?verifyAuth=%@",HttpUrl,self.data [@"verifyAuth"]];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imagephoto = [UIImage imageWithData:data];
    
//    NSString *path = [NSString stringWithFormat:@"%@View/downVerifyCert?verifyAuth=%@",HttpUrl,self.data [@"verifyAuth"]];
//    NSURL *url = [NSURL URLWithString:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    //连接
//    [NSURLConnection connectionWithRequest:request delegate:self];
    
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
        make.height.equalTo(screen_height - 140);
    }];
    
    NSString *path = [NSString stringWithFormat:@"%@View/verifyCert?verifyAuth=%@",HttpUrl,self.data [@"verifyAuth"]];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
 
    
    ///下载验证证书
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadBtn setTitle:@"下载验证证书" forState:UIControlStateNormal];
    self.downloadBtn.layer.cornerRadius = 15.0;
    [self.downloadBtn setBackgroundColor:RGB(251, 140, 142)];
    self.downloadBtn.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.downloadBtn.layer.shadowOpacity = 0.5;
    self.downloadBtn.layer.shadowOffset = CGSizeMake(1, 6);
    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.downloadBtn];
    [self.downloadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(self.webView.bottom).offset(20);
        make.width.equalTo(screen_width / 2.5);
        make.height.equalTo(screen_width / 11);
    }];
    [self.downloadBtn addTarget:self action:@selector(downloadBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

////响应头
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    //清空图片数据
//    [_imageData setLength:0];
//    //强制转换
//    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
//    _length = [[resp.allHeaderFields objectForKey:@"Content-Length"] floatValue];
//    //设置状态栏接收数据状态
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//}
////响应体
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [_imageData appendData:data];//拼接响应数据
//}
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    self.imagephoto = [UIImage imageWithData:_imageData];
//    NSLog(@"异步下载的图片：%@",self.imagephoto);
//    //设置状态栏
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}
///下载验证证书
- (void)downloadBtnButtonClick:(UIButton *)sender{
    ///将图片保存到相册
    UIImageWriteToSavedPhotosAlbum(self.imagephoto, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark - 把图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
        [alert show];
    }
    
}
///返回到证书详情界面
- (void)NavigationBackItemClick{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
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
@end
