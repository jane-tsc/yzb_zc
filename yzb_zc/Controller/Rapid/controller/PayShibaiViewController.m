//
//  PayShibaiViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/22.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "PayShibaiViewController.h"

@interface PayShibaiViewController (){

        UIView *view;
}

@end

@implementation PayShibaiViewController

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
}

- (void)setViewloadUI{
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width / 2 - 25, 80, 50, 50)];
    image.image = [UIImage imageNamed:@"wr_n@2x.png"];
    [view addSubview:image];
    
    UILabel *lable = [UILabel new];
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.bottom).offset(30);
        make.width.equalTo(screen_width);
    }];
    
    UILabel *congxin = [UILabel new];
    congxin.textColor = [UIColor blueColor];
    congxin.text = @"重新购买";
    congxin.textAlignment = NSTextAlignmentCenter;
    congxin.font = [UIFont systemFontOfSize:screen_width / 24];
    congxin.userInteractionEnabled = YES;
    [view addSubview:congxin];
    [congxin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable.bottom).offset(30);
        make.width.equalTo(screen_width);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPayclick)];
    [congxin addGestureRecognizer:tap];
    
    ///次数
    if ([self.shibaiType isEqualToString:@"1"]) {
        
        lable.text = @"保全服务购买失败";
        
    }else if ([self.shibaiType isEqualToString:@"2"]){
    
        lable.text = @"存储空间服务购买失败";
    }
}
///重新购买
- (void)tapPayclick{
  
    [self.navigationController popViewControllerAnimated:YES];
}
///左上角返回按钮
- (void)NavigationBackItemClick{

    ///返回到根视图
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

@end
