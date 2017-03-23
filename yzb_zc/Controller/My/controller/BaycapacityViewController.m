//
//  BaycapacityViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/7/8.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BaycapacityViewController.h"
#import "YSProgressView.h"
#import "baycapViewCell.h"
#import "PayViewController.h"
#import "TYMProgressBarView.h"
#define CELLHEIFGT 55
@interface BaycapacityViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIView *view;
    YSProgressView *ysView;
    UITableView *_tableView;
}
@property (nonatomic,strong) NSDictionary *Dictionary;
@property (nonatomic,strong) NSMutableArray *arrayList;
@property (nonatomic,strong) NSDictionary *dic;
@end

@implementation BaycapacityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"购买容量";
    self.arrayList = [NSMutableArray array];
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    [self setWithUpUI];
}


- (void)setWithUpUI{
  
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getSecuritySize" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"Level" andSuccessCompletioned:^(id object) {
        NSLog(@"容量返回的数据:%@",object);
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            self.Dictionary = object [@"data"];
            
            ///未购买容量
            self.dic = self.Dictionary [@"currentLevel"];
            
//            NSMutableArray *arr = self.Dictionary [@"currentLevel"];
            
            if (self.dic.count == 0) {
                
                UILabel *kaitong = [[UILabel alloc]init];
                kaitong.text = @"当前容量";
                kaitong.textColor = [UIColor darkGrayColor];
                kaitong.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:kaitong];
                [kaitong makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.left).offset(30);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
                
                UILabel *weigoumai = [[UILabel alloc]init];
                weigoumai.text = @"未购买";
                weigoumai.textColor = [UIColor darkGrayColor];
                weigoumai.textAlignment = NSTextAlignmentRight;
                weigoumai.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:weigoumai];
                [weigoumai makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.right).offset(- 80);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
                
                UIView *hen1 = [[UIView alloc]initWithFrame:CGRectMake(30, 80, screen_width - 60, 0.6)];
                hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [view addSubview:hen1];
                
                NSArray *arr = self.Dictionary [@"list"];
                NSLog(@"arr.count:%lu",(unsigned long)arr.count);
                
                
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, screen_width, arr.count == 0 ? 0 : 55 * arr.count) style:UITableViewStylePlain];
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
                _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.scrollEnabled = NO;
                [self.view addSubview:_tableView];
                
                
                UILabel *xuzhi = [UILabel new];
                xuzhi.text = @"开通须知";
                xuzhi.textColor = [UIColor darkGrayColor];
                xuzhi.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:xuzhi];
                [xuzhi makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(_tableView.bottom).offset(10);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(45);
                }];
                
                
                UILabel *xuzhi1 = [UILabel new];
                xuzhi1.text = @"1.请选择对应套餐完成支付开通";
                xuzhi1.textColor = [UIColor darkGrayColor];
                xuzhi1.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi1];
                [xuzhi1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi2 = [UILabel new];
                xuzhi2.text = @"2.服务有效期至开通成功后开始计算";
                xuzhi2.textColor = [UIColor darkGrayColor];
                xuzhi2.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi2];
                [xuzhi2 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi1.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi3 = [UILabel new];
                xuzhi3.text = @"3.购买高等级套餐将替换当前套餐，时间按最后一次";
                xuzhi3.textColor = [UIColor darkGrayColor];
                xuzhi3.numberOfLines = 0;
                xuzhi3.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi3];
                [xuzhi3 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi2.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi4 = [UILabel new];
                xuzhi4.text = @"4.如有疑问请联系客服：400-000-00";
                xuzhi4.textColor = [UIColor darkGrayColor];
                xuzhi4.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi4];
                [xuzhi4 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi3.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                
            }else{
                
                
                UILabel *kaitong = [[UILabel alloc]init];
                kaitong.text = @"当前容量";
                kaitong.textColor = [UIColor darkGrayColor];
                kaitong.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:kaitong];
                [kaitong makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.left).offset(30);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
                NSString *shengyu;
                NSString *zhong;
                NSString *timeNum;
                    shengyu = self.dic [@"restSize"];
                    zhong = self.dic [@"totalSize"];
                    timeNum = self.dic [@"expiresAt"];

                UILabel *capacity = [[UILabel alloc]init];
                NSString *string = [NSString stringWithFormat:@"%@M/%@M",shengyu,zhong];
                capacity.text = string;
                capacity.textColor = [UIColor darkGrayColor];
                capacity.textAlignment = NSTextAlignmentLeft;
                capacity.font = [UIFont systemFontOfSize:screen_width / 35];
                [view addSubview:capacity];
                [capacity makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(kaitong.right).offset(15);
                    make.top.equalTo(view.top).offset(30);
                    make.height.equalTo(15);
                }];

                ///进度条
                CGFloat width = kaitong.frame.size.width;
                TYMProgressBarView *progressBarView1 = [TYMProgressBarView new];
                progressBarView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                progressBarView1.progress = [self.dic [@"percent"] floatValue];
                [view addSubview:progressBarView1];
                [progressBarView1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(kaitong.right).offset(10);
                    make.top.equalTo(capacity.bottom);
                    make.width.equalTo(screen_width - width - 10 - 210);
                    make.height.equalTo(6);
                }];
                
                
                UILabel *time = [[UILabel alloc]init];
                time.text = timeNum;
                time.textColor = [UIColor darkGrayColor];
                time.textAlignment = NSTextAlignmentLeft;
                time.font = [UIFont systemFontOfSize:screen_width / 35];
                [view addSubview:time];
                [time makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.left).offset(30);
                    make.top.equalTo(kaitong.bottom).offset(-10);
                    make.height.equalTo(15);
                }];
                
                ///购买了现实这个
                UIButton * renewal = [UIButton buttonWithType:UIButtonTypeCustom];
                [renewal setTitle:@"续费" forState:UIControlStateNormal];
                [renewal setTitleColor:RGB(254, 185, 187) forState:UIControlStateNormal];
                renewal.titleLabel.font = [UIFont systemFontOfSize:13];
                renewal.layer.cornerRadius = 3.0;
                renewal.layer.masksToBounds = YES;
                renewal.layer.borderWidth = 1.0;
                renewal.layer.borderColor = RGB(254, 185, 187).CGColor;
                [view addSubview:renewal];
                [renewal addTarget:self action:@selector(xufeiClcik:) forControlEvents:UIControlEventTouchUpInside];
                [renewal makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.right).offset( - 85);
                    make.top.equalTo(view.top).offset(40);
                    make.width.equalTo(60);
                    make.height.equalTo(20);
                }];
                
                
                UIView *hen1 = [[UIView alloc]initWithFrame:CGRectMake(30, 80, screen_width - 60, 0.6)];
                hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [view addSubview:hen1];

                NSArray *arr = self.Dictionary [@"list"];
                NSLog(@"arr.count:%lu",(unsigned long)arr.count);
                
                
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, screen_width, arr.count == 0 ? 0 : 55 * arr.count) style:UITableViewStylePlain];
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
                _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.scrollEnabled = NO;
                [self.view addSubview:_tableView];
                
                
                UILabel *xuzhi = [UILabel new];
                xuzhi.text = @"开通须知";
                xuzhi.textColor = [UIColor darkGrayColor];
                xuzhi.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:xuzhi];
                [xuzhi makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(_tableView.bottom).offset(10);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(45);
                }];
                
                
                UILabel *xuzhi1 = [UILabel new];
                xuzhi1.text = @"1.请选择对应套餐完成支付开通";
                xuzhi1.textColor = [UIColor darkGrayColor];
                xuzhi1.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi1];
                [xuzhi1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi2 = [UILabel new];
                xuzhi2.text = @"2.服务有效期至开通成功后开始计算";
                xuzhi2.textColor = [UIColor darkGrayColor];
                xuzhi2.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi2];
                [xuzhi2 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi1.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi3 = [UILabel new];
                xuzhi3.text = @"3.购买高等级套餐将替换当前套餐，时间按最后一次";
                xuzhi3.textColor = [UIColor darkGrayColor];
                xuzhi3.numberOfLines = 0;
                xuzhi3.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi3];
                [xuzhi3 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi2.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi4 = [UILabel new];
                xuzhi4.text = @"4.如有疑问请联系客服：400-000-00";
                xuzhi4.textColor = [UIColor darkGrayColor];
                xuzhi4.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi4];
                [xuzhi4 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi3.bottom);
                    make.width.equalTo(screen_width - 30);
                    make.height.equalTo(35);
                }];
            }
            
            
            [_tableView reloadData];
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.arrayList = self.Dictionary [@"list"];
    
    return self.arrayList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    baycapViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[baycapViewCell alloc]init];
    }
    NSArray * titles4              = @[@"购买",@"购买",@"购买"];
    self.arrayList = self.Dictionary [@"list"];
    
    cell.lable1.text = [self.arrayList [indexPath.row] objectForKey:@"levelName"];
    cell.lable2.text = [self.arrayList [indexPath.row] objectForKey:@"levelPrice"];
    [cell.buybtn2 setTitle:titles4 [indexPath.row] forState:UIControlStateNormal];
    cell.buybtn2.tag = indexPath.row + 20000;
    [cell.buybtn2 addTarget:self action:@selector(baytao111canClcik:) forControlEvents:UIControlEventTouchUpInside];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

///续费按钮
- (void)xufeiClcik:(UIButton *)sender{
    NSLog(@"续费按钮");
    
    [SVProgressHUD showWithStatus:@"正在调取支付,请稍等" maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"doSecuritySizeOrder" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&levelId=%@",[User shareUser].appKey,[User shareUser].authToken,self.dic [@"levelId"]] andURL:@"Pay" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            ///无原文件代管过来买的空间
            if ([self.NOType isEqualToString:@"800"]) {
                NSLog(@"self.notype:%@",self.NOType);
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.NoywjType = @"601";
                [self.navigationController pushViewController:pay animated:YES];
            }
            ///验证无原文件过来买的空间
            else if([self.NOType isEqualToString:@"900"])
            {
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.payType = @"602";
                [self.navigationController pushViewController:pay animated:YES];
                
            }
            ///快速保全过来买的空间
            else if([self.rapType isEqualToString:@"700"])
            {
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.payType = @"600";
                [self.navigationController pushViewController:pay animated:YES];
                
            }
            ///其它首页进来的
            else{
                
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                NSLog(@"dic:%@",dic);
                pay.payType = @"1100";
                [self.navigationController pushViewController:pay animated:YES];
                
            }
            
            [_tableView reloadData];
            
        }else{
            
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

///购买按钮事件
- (void)baytao111canClcik:(UIButton *)sender{
    
    NSDictionary *ddd = self.arrayList [sender.tag - 20000];
  
    NSLog(@"aaaa------------:%@",self.dic);
    

    if ([self.dic isKindOfClass:[NSNull class]] || self.dic.count == 0) {
        
    
        [SVProgressHUD showWithStatus:@"正在调取支付,请稍等" maskType:SVProgressHUDMaskTypeGradient];
        
        [[TSCCntc sharedCntc] queryWithPoint:@"doSecuritySizeOrder" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&levelId=%@",[User shareUser].appKey,[User shareUser].authToken,ddd [@"levelId"]] andURL:@"Pay" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                [SVProgressHUD dismiss];
                
                NSDictionary *dic = [object objectForKey:@"data"];
                
                ///无原文件代管过来买的空间
                if ([self.NOType isEqualToString:@"800"]) {
                    NSLog(@"self.notype:%@",self.NOType);
                    PayViewController *pay = [[PayViewController alloc]init];
                    pay.data = dic;
                    pay.NoywjType = @"601";
                    [self.navigationController pushViewController:pay animated:YES];
                }
                ///验证无原文件过来买的空间
                else if([self.NOType isEqualToString:@"900"])
                {
                    PayViewController *pay = [[PayViewController alloc]init];
                    pay.data = dic;
                    pay.payType = @"602";
                    [self.navigationController pushViewController:pay animated:YES];
                    
                }
                ///快速保全过来买的空间
                else if([self.rapType isEqualToString:@"700"])
                {
                    PayViewController *pay = [[PayViewController alloc]init];
                    pay.data = dic;
                    pay.payType = @"600";
                    [self.navigationController pushViewController:pay animated:YES];
                    
                }
                ///其它首页进来的
                else{
                    
                    PayViewController *pay = [[PayViewController alloc]init];
                    pay.data = dic;
                    pay.payType = @"1100";
                     NSLog(@"dic:%@",dic);
                    [self.navigationController pushViewController:pay animated:YES];
                    
                }
                [_tableView reloadData];
                
            }else{
                
                [SVProgressHUD dismiss];
                [OMGToast showWithText:object[@"msg"]];
            }
            
        } andFailed:^(NSString *object) {
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }else{
    
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"如果购买后，将替换你当前已享有的存储容量，是否确认购买？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SVProgressHUD showWithStatus:@"正在调取支付,请稍等" maskType:SVProgressHUDMaskTypeGradient];
            
            [[TSCCntc sharedCntc] queryWithPoint:@"doSecuritySizeOrder" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&levelId=%@",[User shareUser].appKey,[User shareUser].authToken,ddd [@"levelId"]] andURL:@"Pay" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [SVProgressHUD dismiss];
                    
                    NSDictionary *dic = [object objectForKey:@"data"];
                    
                    
                    ///无原文件代管过来买的空间
                    if ([self.NOType isEqualToString:@"800"]) {
                        NSLog(@"self.notype:%@",self.NOType);
                        PayViewController *pay = [[PayViewController alloc]init];
                        pay.data = dic;
                        pay.NoywjType = @"601";
                        [self.navigationController pushViewController:pay animated:YES];
                    }
                    ///验证无原文件过来买的空间
                    else if([self.NOType isEqualToString:@"900"])
                    {
                        PayViewController *pay = [[PayViewController alloc]init];
                        pay.data = dic;
                        pay.payType = @"602";
                        [self.navigationController pushViewController:pay animated:YES];
                        
                    }
                    ///快速保全过来买的空间
                    else if([self.rapType isEqualToString:@"700"])
                    {
                        PayViewController *pay = [[PayViewController alloc]init];
                        pay.data = dic;
                        pay.payType = @"600";
                        [self.navigationController pushViewController:pay animated:YES];
                        
                    }
                    ///其它首页进来的
                    else{
                        
                        PayViewController *pay = [[PayViewController alloc]init];
                        pay.data = dic;
                         NSLog(@"dic:%@",dic);
                        pay.payType = @"1100";
                        [self.navigationController pushViewController:pay animated:YES];
                        
                    }

                    [_tableView reloadData];
                    
                }else{
                    
                    [SVProgressHUD dismiss];
                    [OMGToast showWithText:object[@"msg"]];
                }
                
            } andFailed:^(NSString *object) {
                 [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
            NSLog(@"确定");
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }
    
}

- (void)NavigationBackItemClick{
   
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

@end
