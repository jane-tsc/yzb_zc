//
//  BasicTableViewController.m
//  AdailyShop
//
//  Created by 重庆阿达西科技有限公司 on 15/9/1.
//  Copyright (c) 2015年 com.adaxi.AdailyShop. All rights reserved.
//  A

#import "BasicTableViewController.h"

@interface BasicTableViewController ()

@end

@implementation BasicTableViewController
@synthesize leftBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // 添加自定义返回按钮
    [self loadCustomnavigationLeftItem];
}

#pragma mark - 判断是不是跳转后的页面 更改导航栏返回按钮
- (void)loadCustomnavigationLeftItem
{
    if (self.navigationController.viewControllers.count > 1)
    {
        leftBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"back-icon" ofType:@"png"]]
                 forState:UIControlStateNormal];
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



@end
