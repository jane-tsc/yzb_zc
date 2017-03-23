//
//  TransmissionViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/21.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "TransmissionViewController.h"
#import "TransmissionViewCell.h"
#import "dianziModel.h"
@interface TransmissionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}
@property(nonatomic,strong) UIButton *backButton;///返回首页
@end

@implementation TransmissionViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.title = @"文件传输";
    
    [self setupView];
}
- (void)setupView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
    view.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:view];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 200)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    ///确认支付按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 15.0;
    [self.backButton setBackgroundColor:RGB(251, 140, 142)];
    self.backButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.backButton.layer.shadowOpacity = 0.5;
    self.backButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.backButton];
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 4);
        make.top.equalTo(_tableView.bottom).offset(20);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(30);
    }];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    TransmissionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[TransmissionViewCell alloc]init];
    }

    cell.image.image = self.image;
    cell.imgType.image = [UIImage imageNamed:@"save_all_3_n.png"];
    cell.title.text = self.Dictionary [@"archiveName"];
    cell.time.text = self.Dictionary [@"securityTime"];
    cell.typeNum.text =@"存储成功";
    cell.endBB.text = self.Dictionary [@"remarks"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

///返回首页－－－》返回到指定页面  根据下标来算
- (void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
