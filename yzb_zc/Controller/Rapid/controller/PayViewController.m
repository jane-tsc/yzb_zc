//
//  PayViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "PayViewController.h"
#import "ImmViewController.h"
#import "PayViewCell.h"
#import "PayWCViewController.h"
#import "TheViewController.h"
#import "TransmissionViewController.h"
#import "KongjianpayViewController.h"
#import "CishuPayViewController.h"
#import "PayShibaiViewController.h"
///微信支付头文件
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "Constant.h"
#import "WXApi.h"

#define CELLHEIFGT 85

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,PayViewCellDelegate,UIAlertViewDelegate,WXApiManagerDelegate>{
    
    UITableView *_tableView;
    
    NSInteger _index;
    
    int PayTypemoney;
    
    NSInteger rowindex;
    
    NSString *oderSn;///订单号
}

@property(nonatomic,strong) UILabel * price;///支付价格

@property(nonatomic,strong) UIButton *PaymentButton;///立即代管

@property(nonatomic,strong) NSDictionary *Paydic;///支付之前服务器返回的要支付的信息\

@property (nonatomic, assign) NSInteger      selectedIndex;


@end

@implementation PayViewController

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
    self.title = @"保全支付";
    self.Paydic = [NSDictionary dictionary];
    
    [self setupView];
    
    [WXApiManager sharedManager].delegate = self;
    

    if ([self.payType isEqualToString:@"300"]) {
        
        oderSn = self.data [@"orderSn"];
        NSLog(@"oderSn:%@",oderSn);
        NSLog(@"1111");
    }
    else if ([self.payType isEqualToString:@"500"] || [self.ywjType isEqualToString:@"1001"])
    {
        oderSn = self.data [@"orderSn"];
        NSLog(@"开通份数");
    }
    else if ([self.payType isEqualToString:@"600"] || [self.NoywjType isEqualToString:@"601"])
    {
        oderSn = self.data [@"orderSn"];
        NSLog(@"self.data:%@",self.data [@"orderSn"]);
        NSLog(@"开通空间");
    }
    else if ([self.payType isEqualToString:@"100"])
    {
        oderSn = self.data [@"orderSn"];
        NSLog(@"无原文件代管");
    }
    ///购买空间续费续费
    else if ([self.payType isEqualToString:@"1100"])
    {
        oderSn = self.data [@"orderSn"];
         NSLog(@"self.data:%@",self.data [@"orderSn"]);
        NSLog(@"无原文件代管");
    }
    ///购买次数续费
    else if ([self.payType isEqualToString:@"1200"])
    {
        oderSn = self.data [@"orderSn"];
        NSLog(@"self.data:%@",self.data [@"orderSn"]);
        NSLog(@"无原文件代管");
    }
    else{
        oderSn = self.data [@"orderSn"];
        NSLog(@"2222");
    }
    
}

- (void)setupView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *baoquanMessage = [[UILabel alloc]init];
    baoquanMessage.textAlignment = NSTextAlignmentLeft;
    baoquanMessage.text = @"需支付金额";
    baoquanMessage.textColor = [UIColor blackColor];
    baoquanMessage.font = [UIFont boldSystemFontOfSize:screen_width / 22];
    [view addSubview:baoquanMessage];
    [baoquanMessage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(view.top).offset(40);
        make.width.equalTo(screen_width / 2 - 20);
        make.height.equalTo(15);
    }];
    
    self.price = [[UILabel alloc]init];
    self.price.textAlignment = NSTextAlignmentRight;
    
    if ([self.payType isEqualToString:@"300"] || [self.payType isEqualToString:@"1100"] || [self.payType isEqualToString:@"1200"] || [self.payType isEqualToString:@"600"] || [self.payType isEqualToString:@"500"] || [self.ywjType isEqualToString:@"1001"] || [self.NoywjType isEqualToString:@"601"] || [self.payType isEqualToString:@"100"]) {
        self.price.text = [NSString stringWithFormat:@"¥%.2f",[self.data [@"orderAmount"] doubleValue]];
    }else{
         self.price.text = [NSString stringWithFormat:@"¥%.2f",[self.data [@"amount"] doubleValue]];
    }
    
    //    self.price.text = [NSString stringWithFormat:@"¥%@",@"5"];
    self.price.textColor = [UIColor blackColor];
    self.price.font = [UIFont boldSystemFontOfSize:screen_width / 22];
    [view addSubview:self.price];
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baoquanMessage.right);
        make.top.equalTo(view.top).offset(40);
        make.width.equalTo(screen_width / 2 - 20);
        make.height.equalTo(15);
    }];
    
    UIView *henxian = [[UIView alloc]init];
    henxian.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:henxian];
    [henxian makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(20);
        make.top.equalTo(baoquanMessage.bottom).offset(30);
        make.width.equalTo(screen_width - 40);
        make.height.equalTo(0.5);
    }];
   
    NSArray *images  = @[@"wx_pay.png",@"zfb_pay.png",@"yhk_pay.png"];
    NSArray *titles  = @[@"微信支付",@"支付宝",@"银行卡支付"];
    NSArray *titles1 = @[@"推荐安装微信5.0以上版本用户使用",@"推荐有支付宝帐号的用户使用",@"支持储蓄卡信用卡，无需开通网银"];
    
    _selectedIndex   = 0;
    for (int i = 0; i < 1; i ++) {
        
        UIView *itemView = [UIView new];
        itemView.backgroundColor = [UIColor whiteColor];
        [view addSubview:itemView];
        [itemView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left);
            make.right.equalTo(view.right);
            make.height.equalTo(CELLHEIFGT);
            make.top.equalTo(henxian.bottom).offset(CELLHEIFGT * i + 30);
        }];

        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:images[i]];
        [itemView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(itemView.top).offset(24);
            make.width.equalTo(itemView.height).offset(-45);
            make.height.equalTo(itemView.height).offset(-45);
        }];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = [UIColor blackColor];
        lable.font = [UIFont systemFontOfSize:screen_width / 24];
        lable.text = titles[i];
        [itemView addSubview:lable];
        [lable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(10);
            make.top.equalTo(itemView.top).offset(24);
            make.width.equalTo(itemView.width).offset( - 120);
            make.height.equalTo(20);
        }];
        
        UILabel *lable1 = [[UILabel alloc]init];
        lable1.textAlignment = NSTextAlignmentLeft;
        lable1.textColor = [UIColor blackColor];
        lable1.font = [UIFont systemFontOfSize:screen_width / 26];
        lable1.text = titles1 [i];
        [itemView addSubview:lable1];
        [lable1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( imageView.right).offset(10);
            make.top.equalTo(lable.bottom).offset(5);
            make.width.equalTo(itemView.width).offset( - 120);
            make.height.equalTo(20);
        }];
        
        UIButton * button               = UIButton.new;
        button.tag                      = 100 + i;
        button.selected                 = i == 0 ? YES : NO;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
        button.imageEdgeInsets          = UIEdgeInsetsMake(12, 12, 12, 12);
        [itemView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.top);
            make.bottom.equalTo(itemView.bottom);
            make.right.equalTo(screen_width).offset(4);
            make.width.equalTo(CELLHEIFGT);
        }];
 
    }
    
    UIView * lastLineView;
    for (int i = 0; i < 1; i++)
    {
        UIView * lineView        = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(view.left).offset(20);
            make.right.equalTo(view.right).offset(-20);
            make.height.equalTo(0.8);
            make.top.equalTo(henxian.bottom).offset((i + 1) * CELLHEIFGT + 30);
        }];
        lastLineView             = lineView;
    }
 
    ///确认支付按钮
    self.PaymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.PaymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.PaymentButton setTitle:@"确认支付" forState:UIControlStateNormal];
    self.PaymentButton.layer.cornerRadius = 15.0;
    [self.PaymentButton setBackgroundColor:RGB(251, 140, 142)];
    self.PaymentButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.PaymentButton.layer.shadowOpacity = 0.5;
    self.PaymentButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.PaymentButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.PaymentButton];
    [self.PaymentButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(henxian.bottom).offset(350);
        make.width.equalTo(screen_width / 2.5);
        make.height.equalTo(screen_width / 11);
    }];
    [self.PaymentButton addTarget:self action:@selector(querenButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)buttonClick:(UIButton *)sender
{
    for (int i = 0; i < 1; i ++) {
        
        UIButton *button =(UIButton *)[self.view viewWithTag:100 + i];
        button.selected = button.tag == sender.tag ? YES : NO;
    }
    _selectedIndex   =   sender.tag - 100;
}
- (void)NavigationBackItemClick{

    UIAlertView * alertView                        = [[UIAlertView alloc] initWithTitle:@"支付提示"
                                                                                message:@"您确定要取消支付 ？"
                                                                               delegate:self
                                                                      cancelButtonTitle:nil
                                                                      otherButtonTitles:@"确定",@"取消", nil];
    [alertView show];

}

#pragma mark - 确认支付按钮
- (void)querenButtonButtonClick:(UIButton *)sender{
#pragma 微信支付
    if (_selectedIndex == 0) {
        NSLog(@"进入了微信支付");
        
        WXApiManager *wxmassage = [[WXApiManager alloc]init];
        wxmassage.delegate = self;
        
        NSLog(@"oderSn:%@",oderSn);
        
        [[TSCCntc sharedCntc] queryWithPoint:@"getWxPaySign" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&orderSn=%@",[User shareUser].appKey,[User shareUser].authToken,oderSn] andURL:@"Pay" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                
                self.Paydic = [object objectForKey:@"data"];
                
                NSMutableString *stamp  = [self.Paydic objectForKey:@"timeStamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [self.Paydic objectForKey:@"partnerId"];
                req.prepayId            = [self.Paydic objectForKey:@"prepayId"];
                req.nonceStr            = [self.Paydic objectForKey:@"nonceStr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [self.Paydic objectForKey:@"packageVal"];
                req.sign                = [self.Paydic objectForKey:@"sign"];
                
                [WXApi sendReq:req];
      
            }else{
                
                [OMGToast showWithText:object [@"msg"]];
                return;
            }
            
        } andFailed:^(NSString *object) {
            
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
            
        }];
    }
#pragma 支付宝
    else if (_selectedIndex  == 1)
    
    {
        
        NSLog(@"进入了支付宝");
        [OMGToast showWithText:@"该功能未开启！"];
        return;
    }
#pragma 银联支付
    else if (_selectedIndex  == 2)
    {
        
        NSLog(@"进入了银联支付");
        [OMGToast showWithText:@"该功能未开启！"];
        return;
    }

}
///通过代理返回支付状态进行判断跳转界面
#pragma mark - WXApiManagerDelegate
- (void)wxPaywithType:(int)Type
{
    NSLog(@"这是返回的微信支付状态：%d",Type);
    PayTypemoney = Type;
    if (PayTypemoney == 0) {
        

        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"用户支付成功！" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([self.payType isEqualToString:@"300"]) {
                
                TheViewController *the = [[TheViewController alloc]init];
                [self.navigationController pushViewController:the animated:YES];
                
            }
            ///购买份数
            else if ([self.payType isEqualToString:@"500"]){
            
                CishuPayViewController *cishu = [[CishuPayViewController alloc]init];
                cishu.rapType = @"700";
                [self.navigationController pushViewController:cishu animated:YES];
                
            }
            ///首页购买份数
            else if ([self.payType isEqualToString:@"1200"]){
                
                CishuPayViewController *cishu = [[CishuPayViewController alloc]init];
                cishu.rapType = @"1200";
                [self.navigationController pushViewController:cishu animated:YES];
                
            }
            ///份数过期购买
            else if ([self.payType isEqualToString:@"1001"]){
                
                CishuPayViewController *cishu = [[CishuPayViewController alloc]init];
                cishu.FSguoqiType = @"1002";
                [self.navigationController pushViewController:cishu animated:YES];
            }
            ///购买空间
            else if ([self.payType isEqualToString:@"600"]){
                
                KongjianpayViewController *kongjian = [[KongjianpayViewController alloc]init];
                kongjian.rapType = @"700";
                [self.navigationController pushViewController:kongjian animated:YES];
                
            }
            ///首页购买空间
            else if ([self.payType isEqualToString:@"1100"]){
                
                KongjianpayViewController *kongjian = [[KongjianpayViewController alloc]init];
                kongjian.rapType = @"1100";
                [self.navigationController pushViewController:kongjian animated:YES];
                
            }
            ///从原文件代管页面跳转进来的
            else if ([self.NoywjType isEqualToString:@"601"]){
                
                KongjianpayViewController *kongjian = [[KongjianpayViewController alloc]init];
                kongjian.YWdaiguanType = @"800";
                [self.navigationController pushViewController:kongjian animated:YES];
                
            }
            ///验证证书 文件代管跳转过来的，
            else if ([self.payType isEqualToString:@"602"]){
                
                KongjianpayViewController *kongjian = [[KongjianpayViewController alloc]init];
                kongjian.YWdaiguanType = @"801";
                [self.navigationController pushViewController:kongjian animated:YES];
                
            }
            else if ([self.payType isEqualToString:@"100"]){
                
                PayWCViewController *imm = [[PayWCViewController alloc]init];
                imm.Dictionary = self.Dictionary;
                imm.imageArray = self.imageArray;
                imm.image = self.image;
                imm.finder = self.data [@"certId"];
                [self.navigationController pushViewController:imm animated:YES];
            }
            else{
            
                PayWCViewController *imm = [[PayWCViewController alloc]init];
                imm.Dictionary = self.Dictionary;
                imm.imageArray = self.imageArray;
                imm.image = self.image;
                imm.finder = self.data [@"certId"];
                [self.navigationController pushViewController:imm animated:YES];

            }

        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
        rowindex = 1;
        
    }else if (PayTypemoney == 1){

        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"支付失败！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ///购买次数跳转到支付失败界面
            if ([self.payType isEqualToString:@"500"] || [self.payType isEqualToString:@"1200"] || [self.payType isEqualToString:@"1001"]) {
                
                PayShibaiViewController *payshibai = [[PayShibaiViewController alloc]init];
                payshibai.shibaiType = @"1";
                [self.navigationController pushViewController:payshibai animated:YES];
            }
             ///购买空间跳转到支付失败界面
            else if ([self.payType isEqualToString:@"600"] || [self.payType isEqualToString:@"1100"] || [self.NoywjType isEqualToString:@"601"] || [self.payType isEqualToString:@"602"]){
            
                PayShibaiViewController *payshibai = [[PayShibaiViewController alloc]init];
                payshibai.shibaiType = @"2";
                [self.navigationController pushViewController:payshibai animated:YES];
            
            }
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];

    
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户取消支付！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if ([self.payType isEqualToString:@"100"]) {
        
        if (buttonIndex                                == alertView.firstOtherButtonIndex)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        }
    }else if ([self.payType isEqualToString:@"200"]){
     
        if (buttonIndex                                == alertView.firstOtherButtonIndex)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
    
    }else if ([self.payType isEqualToString:@"300"]){
        
        if (buttonIndex                                == alertView.firstOtherButtonIndex)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        }
        
    }else if ([self.payType isEqualToString:@"500"]){
        
        if (buttonIndex                                == alertView.firstOtherButtonIndex)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }else if ([self.payType isEqualToString:@"600"]){
        
        if (buttonIndex                                == alertView.firstOtherButtonIndex)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        }
    }else{
    
           [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
