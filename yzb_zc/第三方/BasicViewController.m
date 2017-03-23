//
//  BasicViewController.m
//  AdailyShop
//
//  Created by 重庆阿达西科技有限公司 on 15/9/1.
//  Copyright (c) 2015年 com.adaxi.AdailyShop. All rights reserved.
/* A Da Xi of Chongqing Science and Technology Co., Ltd. is a high-tech enterprise specialized in software development and its affiliated sales of electronic products. Is a professional engaged in software development, software customization, software implementation of high-tech enterprises.
The company has a number of long-term professional engaged in software development, software customization of professional personnel, with strong technology development strength, the full range of government and business information needs.
Company's purpose: scientific and technological innovation, excellence, pioneering and enterprising, pragmatic and efficient.
Business philosophy: people-oriented, integrity, mutual benefit.
Service tenet: "the first-class technology, the first-class product, the thoughtful customer service" is our tenet. "Customer satisfaction" is our eternal pursuit.
Main business: website development and maintenance, software outsourcing, software customization development, system maintenance, OA office systems, mobile APP customization, micro channel two development, etc..
The language used include: JAVA/JSF/JSP,.NET, VB/VBA, OC, Swift, PHP, etc..
The company's business goal is to become a leader in the software development market, innovative technology, developed a series of popular consumer favorite software. */

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];    // 添加自定义返回按钮
    [self loadCustomnavigationLeftItem];
}

#pragma mark - 判断是不是跳转后的页面 更改导航栏返回按钮
- (void)loadCustomnavigationLeftItem
{
    if (self.navigationController.viewControllers.count > 1)
    {
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back-icon" ofType:@"png"]] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 0, 20, 40);
        leftBtn.backgroundColor = [UIColor clearColor];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 9, 8);
        [leftBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NavigationBackItemClick)]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
}
- (void)NavigationBackItemClick
{
    HIDEKEYBOARD;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/// 设置标题
- (void)setViewControllerNavTitle:(NSString *)titleStr
{
    UIView * titleView            = [[UIView alloc] initWithFrame:GetFrame(70, 0, screen_width - 140, 25)];
    titleView.backgroundColor     = [UIColor clearColor];
    _titleLabel                   = [[MarqueeLabel alloc] initWithFrame:titleView.bounds
                                                                   rate:50.0f
                                                          andFadeLength:0];
    _titleLabel.numberOfLines     = 1;
    _titleLabel.opaque            = NO;
    _titleLabel.enabled           = YES;
    _titleLabel.shadowOffset      = CGSizeMake(0.0, - 1.0);
    _titleLabel.textAlignment     = NSTextAlignmentCenter;
    _titleLabel.textColor         = [UIColor whiteColor];
    _titleLabel.backgroundColor   = [UIColor clearColor];
    _titleLabel.font              = [UIFont boldSystemFontOfSize:18];
    _titleLabel.text              = titleStr;
    [titleView addSubview:_titleLabel];
    self.navigationItem.titleView = titleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
