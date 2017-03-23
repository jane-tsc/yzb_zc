//
//  KongjianpayViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/19.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "KongjianpayViewController.h"

@interface KongjianpayViewController (){

    UIView *view;
}

@end

@implementation KongjianpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"购买结果";
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [self setViewloadUI];
    [self httprestWithup];
}

- (void)setViewloadUI{
 
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width / 2 - 25, 80, 50, 50)];
    image.image = [UIImage imageNamed:@"right_grzx@2x.png"];
    [view addSubview:image];
    
    UILabel *lable = [UILabel new];
    lable.text = @"存储空间购买成功";
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:screen_width / 20];
    [view addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.bottom).offset(30);
        make.width.equalTo(screen_width);
    }];
}

- (void)NavigationBackItemClick{
    ///返回到快速保全
    if ([self.rapType isEqualToString:@"700"]) {
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }
    ///返回到原文件
    else if ([self.YWdaiguanType isEqualToString:@"800"]){
        
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }
    ///返回到验证证书
    else if ([self.YWdaiguanType isEqualToString:@"801"]){
        
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    }
    ///返回到首页
    else if ([self.rapType isEqualToString:@"1100"]){
        
        [self httprestWithup];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
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
            
            NSLog(@"剩余空间:%@",[User shareUser].securityUsedSize);
            
        }else{
            
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}
@end
