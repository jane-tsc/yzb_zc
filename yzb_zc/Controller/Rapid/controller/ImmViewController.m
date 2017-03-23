//
//  ImmediatelyViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ImmViewController.h"
#import "PayWCViewController.h"
#import "dianziModel.h"
#import "PayWcViewCell.h"
#import "DetailsViewController.h"
@interface ImmViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}
@property(nonatomic,strong) UIButton *PayButton;///立即支付
@property(nonatomic,strong) UIButton *backButton;///返回首页
@end

@implementation ImmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = [NSString stringWithFormat:@"电子保全%ld/6",(long)self.num];
    
    [self setupView];
    
    self.ListArray = [NSMutableArray alloc];
    self.ListArray = [dianziModel objectArrayWithKeyValuesArray:self.Dictionary [@"list"]];
    NSLog(@"self.ListArray－－－－－－－：%@",_ListArray);

}

#pragma mark-right 2
- (void)clickEvent
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 200)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    ///确认支付按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 15.0;
    [self.backButton setBackgroundColor:RGB(251, 140, 142)];
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
    return self.ListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    PayWcViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[PayWcViewCell alloc]init];
    }
    dianziModel *model =self.ListArray [indexPath.row];
    NSDictionary *diction = self.imageArray [indexPath.row];
    cell.title.text = model.archiveName;
    cell.time.text = model.securityTime;
    
    ///根据后缀名去判断显示图片类型
    if ([model.fileType isEqualToString:@"10"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanwendang.png"];
        
    }
    else if([model.fileType isEqualToString:@"20"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquantupian.png"];
    }
    else if ([model.fileType isEqualToString:@"30"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanyingping.png"];
    }
    else if ([model.fileType isEqualToString:@"40"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanshiping.png"];
    }
    else if ([model.fileType isEqualToString:@"50"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanqita.png"];
    }
    
    ///根据后缀名去判断小图片类型
    if ([model.fileType isEqualToString:@"10"])
    {
        cell.imgType.image = [UIImage imageNamed:@"baoquanwendang.png"];
        
    }
    else if([model.fileType isEqualToString:@"20"])
    {
        cell.imgType.image = [UIImage imageNamed:@"baoquantupian.png"];
    }
    else if ([model.fileType isEqualToString:@"30"])
    {
        cell.imgType.image = [UIImage imageNamed:@"baoquanyingping.png"];
    }
    else if ([model.fileType isEqualToString:@"40"])
    {
        cell.imgType.image = [UIImage imageNamed:@"baoquanshiping.png"];
    }
    else if ([model.fileType isEqualToString:@"50"])
    {
        cell.imgType.image = [UIImage imageNamed:@"baoquanqita.png"];
    }
    
    if (model.result == 0)
    {
        cell.typeNum.text =@"失败";
        [cell.csBtn setBackgroundImage:[UIImage imageNamed:@"sx_n.png"] forState:UIControlStateNormal];
        [cell.csBtn addTarget:self action:@selector(csclick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.typeNum.text =@"成功";
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    dianziModel *model =self.ListArray [indexPath.row];
    DetailsViewController *details = [[DetailsViewController alloc]init];
    details.fileid = model.certId;
    //                details.chenggongType = @"1";
    details.labletitle = model.archiveName;
    [self.navigationController pushViewController:details animated:YES];
}

- (void)backButtonClick:(UIButton *)sender{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
#pragma mark -  重试按钮
- (void)csclick:(UIButton *)sender{
    
    NSLog(@"重试按钮");
}

- (void)NavigationBackItemClick{
    
    if ([self.payType isEqualToString:@"1"]) {
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else{
    
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
     }
}


@end
