//
//  OpenpreservationViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/7/8.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "OpenpreservationViewController.h"
#import "openViewCell.h"
#import "YSProgressView.h"
#import "PayViewController.h"
#define CELLHEIFGT 55
@interface OpenpreservationViewController ()<UITableViewDelegate,UITableViewDataSource>{
  
    UIView *view;
    UITableView *_tableView;
    YSProgressView *ysView;
}
@property (nonatomic,strong) NSMutableDictionary *Dictionary;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSMutableArray *arrayList;
@end

@implementation OpenpreservationViewController

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
    self.title = @"开通保全";
    self.arrayList = [NSMutableArray array];
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    
    [self setWithUpUI];
    [self settableView];
}

- (void)setWithUpUI{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getSecurityNum" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"Level" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            self.Dictionary = object [@"data"];
            
            self.dic = self.Dictionary [@"currentLevel"];

             self.arrayList = self.Dictionary [@"list"];
            
            if (self.dic.count == 0) {
                
                UILabel *kaitong = [[UILabel alloc]init];
                kaitong.text = @"当前剩余份数";
                kaitong.textColor = [UIColor darkGrayColor];
                kaitong.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:kaitong];
                [kaitong makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.left).offset(30);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
                UILabel *weigoumai = [[UILabel alloc]init];
                weigoumai.text = @"未开通";
                weigoumai.textColor = [UIColor darkGrayColor];
                weigoumai.textAlignment = NSTextAlignmentRight;
                weigoumai.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:weigoumai];
                [weigoumai makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.right).offset(- 80);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
                
                NSLog(@"self.arrayList:%lu",(unsigned long)self.arrayList.count);
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, screen_width, self.arrayList.count == 0 ? 0 : 55 * self.arrayList.count) style:UITableViewStylePlain];
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
                _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.scrollEnabled = NO;
                [self.view addSubview:_tableView];
                _tableView.tableFooterView = [[UIView alloc]init];
                
                UILabel *kaitong1 = [UILabel new];
                kaitong1.text = @"开通须知";
                kaitong1.textColor = [UIColor darkGrayColor];
                kaitong1.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:kaitong1];
                [kaitong1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(_tableView.bottom).offset(10);
                    make.height.equalTo(35);
                }];
                
                UILabel *xuzhi1 = [UILabel new];
                xuzhi1.text = @"1.请选择对应套餐完成支付开通";
                xuzhi1.textColor = [UIColor darkGrayColor];
                xuzhi1.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi1];
                [xuzhi1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(kaitong1.bottom);
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
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi3 = [UILabel new];
                xuzhi3.text = @"3.如有疑问请联系客服：400-000-00";
                xuzhi3.textColor = [UIColor darkGrayColor];
                xuzhi3.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi3];
                [xuzhi3 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi2.bottom);
                    make.height.equalTo(35);
                }];
                
                
            }else{
                
                UILabel *kaitong = [[UILabel alloc]init];
                kaitong.text = @"当前剩余份数:";
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
                NSString *timenum;
                
//                for (NSDictionary *ddic in arr) {
                    shengyu = self.dic [@"restNum"];
                    zhong  = self.dic [@"totalNum"];
                    timenum = self.dic [@"expiresAt"];
//                }
                
                UILabel *capacity = [[UILabel alloc]init];
                NSString *strnum = [NSString stringWithFormat:@"%@份/%@份",shengyu,zhong];
                capacity.text = strnum;
                capacity.textColor = [UIColor darkGrayColor];
                capacity.textAlignment = NSTextAlignmentLeft;
                capacity.font = [UIFont systemFontOfSize:11];
                [view addSubview:capacity];
                [capacity makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(kaitong.right).offset(15);
                    make.top.equalTo(view.top).offset(20);
                    make.height.equalTo(45);
                }];
                
            
                UILabel *time = [[UILabel alloc]init];
                time.text = timenum;
                time.textColor = [UIColor darkGrayColor];
                time.textAlignment = NSTextAlignmentLeft;
                time.font = [UIFont systemFontOfSize:11];
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
                [renewal addTarget:self action:@selector(renewalxufeiClcik:) forControlEvents:UIControlEventTouchUpInside];
                [renewal makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.right).offset( - 85);
                    make.top.equalTo(view.top).offset(35);
                    make.width.equalTo(60);
                    make.height.equalTo(20);
                }];
                
                
                NSLog(@"self.arrayList:%lu",(unsigned long)self.arrayList.count);
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, screen_width, self.arrayList.count == 0 ? 0 : 55 * self.arrayList.count) style:UITableViewStylePlain];
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
                _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.scrollEnabled = NO;
                [self.view addSubview:_tableView];
                _tableView.tableFooterView = [[UIView alloc]init];
                
                UILabel *kaitong1 = [UILabel new];
                kaitong1.text = @"开通须知";
                kaitong1.textColor = [UIColor darkGrayColor];
                kaitong1.font = [UIFont systemFontOfSize:screen_width / 24];
                [view addSubview:kaitong1];
                [kaitong1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(_tableView.bottom).offset(10);
                    make.height.equalTo(35);
                }];
                
                UILabel *xuzhi1 = [UILabel new];
                xuzhi1.text = @"1.请选择对应套餐完成支付开通";
                xuzhi1.textColor = [UIColor darkGrayColor];
                xuzhi1.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi1];
                [xuzhi1 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(kaitong1.bottom);
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
                    make.height.equalTo(35);
                }];
                
                
                UILabel *xuzhi3 = [UILabel new];
                xuzhi3.text = @"3.如有疑问请联系客服：400-000-00";
                xuzhi3.textColor = [UIColor darkGrayColor];
                xuzhi3.font = [UIFont systemFontOfSize:screen_width / 28];
                [view addSubview:xuzhi3];
                [xuzhi3 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.left).offset(30);
                    make.top.equalTo(xuzhi2.bottom);
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

- (void)settableView{


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.arrayList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    openViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[openViewCell alloc]init];
    }
    NSArray * titles4              = @[@"购买",@"购买",@"购买"];
//    self.arrayList = self.Dictionary [@"list"];
    
    cell.lable1.text = [self.arrayList [indexPath.row] objectForKey:@"levelName"];
    cell.lable2.text = [self.arrayList [indexPath.row] objectForKey:@"levelNum"];
    cell.lable3.text = [self.arrayList [indexPath.row] objectForKey:@"levelPrice"];
    [cell.buybtn2 setTitle:titles4 [indexPath.row] forState:UIControlStateNormal];
    cell.buybtn2.tag = indexPath.row + 2000;
    [cell.buybtn2 addTarget:self action:@selector(baytaocanClcik:) forControlEvents:UIControlEventTouchUpInside];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
///续费按钮
- (void)renewalxufeiClcik:(UIButton *)sender{
    NSLog(@"续费按钮");
    
    [SVProgressHUD showWithStatus:@"正在调取支付,请稍等" maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"doSecurityNumOrder" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&levelId=%@",[User shareUser].appKey,[User shareUser].authToken,self.dic [@"levelId"]] andURL:@"Pay" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];

            
            ///原文件次数过期界面过来的
            if ([self.YwjType isEqualToString:@"1000"]) {
                
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.ywjType = @"1001";
                [self.navigationController pushViewController:pay animated:YES];
                
            }else{
            
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.payType = @"1200";
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
}
///购买按钮事件
- (void)baytaocanClcik:(UIButton *)sender{
    
    NSDictionary *dddd = self.arrayList [sender.tag - 2000];
    
    [SVProgressHUD showWithStatus:@"正在调取支付,请稍等" maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"doSecurityNumOrder" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&levelId=%@",[User shareUser].appKey,[User shareUser].authToken,dddd [@"levelId"]] andURL:@"Pay" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            ///原文件次数过期界面过来的
            if ([self.YwjType isEqualToString:@"1000"]) {
                
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.ywjType = @"1001";
                [self.navigationController pushViewController:pay animated:YES];
                
            }else{
                
                PayViewController *pay = [[PayViewController alloc]init];
                pay.data = dic;
                pay.payType = @"1200";
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


@end
