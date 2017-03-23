//
//  CishuPayViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/19.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "CishuPayViewController.h"
#import "BaycapacityViewController.h"
@interface CishuPayViewController (){

    UIView *view;
}

@end

@implementation CishuPayViewController

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
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width / 2 - 20, 50, 40, 40)];
    image.image = [UIImage imageNamed:@"right_grzx@2x.png"];
    [view addSubview:image];
    
    UILabel *lable = [UILabel new];
    lable.text = @"保全服务购买成功";
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:screen_width / 22];
    [self.view addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.bottom).offset(30);
        make.width.equalTo(screen_width);
    }];
 
    
    UILabel *lable1 = [UILabel new];
    lable1.text = @"开通存储空间服务，保全可以使用文件代管，";
    lable1.textColor = [UIColor blackColor];
    lable1.textAlignment = NSTextAlignmentLeft;
    lable1.font = [UIFont systemFontOfSize:screen_width / 23];
    [self.view addSubview:lable1];
    [lable1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable.bottom).offset(20);
        make.left.equalTo(self.view.left).offset(20);
    }];
    
    UILabel *lable2 = [UILabel new];
    lable2.text = @"前往开通";
    lable2.textColor = RGB(244, 183, 184);
    lable2.userInteractionEnabled = YES;
    lable2.textAlignment = NSTextAlignmentLeft;
    lable2.font = [UIFont systemFontOfSize:screen_width / 24];
    [self.view addSubview:lable2];
    [lable2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable.bottom).offset(19);
        make.left.equalTo(lable1.right);
//        make.height.equalTo(20);
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qianwangkaitong)];
    [lable2 addGestureRecognizer:tap];
    
    UIView *hen = [UIView new];
    hen.backgroundColor = RGB(244, 183, 184);
    [self.view addSubview:hen];
    [hen makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable2.bottom).offset(-1);
        make.left.equalTo(lable1.right);
        make.width.equalTo(lable2.width);
        make.height.equalTo(1.0);
    }];
    
}

- (void)NavigationBackItemClick{
    ///从快速保全界面过来， 返回到快速保全
    if ([self.rapType isEqualToString:@"700"]) {
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }
    ///从原文件界面过来，次数过期，返回到原文件界面
    else if ([self.FSguoqiType isEqualToString:@"1002"])
    {
        [self httprestWithup];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
    }
    ///首页购买次数
    else if ([self.rapType isEqualToString:@"1200"])
    {
        [self httprestWithup];
         [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else{
       [self httprestWithup];
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    }
}

///前往开通
- (void)qianwangkaitong{
    NSLog(@"前往开通");
    BaycapacityViewController *bay = [[BaycapacityViewController alloc]init];
    [self.navigationController pushViewController:bay animated:YES];
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
            
            
            NSLog(@"剩余次数:%@",[User shareUser].securityRestNum);
            
        }else{
            
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
