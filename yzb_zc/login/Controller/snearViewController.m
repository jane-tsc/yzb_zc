//
//  snearViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "snearViewController.h"
#import "senarViewCell.h"
#import "fujinModel.h"
@interface snearViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *array;
    UITableView *table;
}
@end

@implementation snearViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

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
    self.title = @"附近服务商";
    [self setupView];
    [self configeData];
    array = [[NSMutableArray alloc]init];
    //    设置 状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)configeData{
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.separatorColor = [UIColor groupTableViewBackgroundColor];
    table.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.dataSource = self;
    [self.view addSubview:table];
    table.tableFooterView = [[UIView alloc]init];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSNumber *latitude = [NSNumber numberWithDouble:delegate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:delegate.longitude];
    
    NSString *aString = [latitude stringValue];
    NSString *bString = [longitude stringValue];
    
    NSString *string = [NSString stringWithFormat:@"%@,%@",aString,bString];
    
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] TheserverWithPoint:@"getServerByCity" andParamsDictionary:[NSString stringWithFormat:@"cityPos=%@",string] andURL:@"Server" andSuccessCompletioned:^(id object) {
        if ([object [@"code"]boolValue]) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = [object objectForKey:@"data"];
            
            array = [fujinModel objectArrayWithKeyValuesArray:dic [@"list"]];
            [table reloadData];
            
        }else{
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)setupView{
    table.tableFooterView = [[UIView alloc]init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    senarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[senarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    fujinModel *fujinmodel = array [indexPath.row];
    
    cell.Image.image = [UIImage imageNamed:@"tx_bg_nor.png"];
    cell.address.text = fujinmodel.address;
    cell.title.text  = fujinmodel.user;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///点击后消除点击痕迹
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    fujinModel *fujinmodel = array [indexPath.row];
    
    if (self.Delegate && [self.Delegate respondsToSelector:@selector(passTrendValues:)]) {
         [self.Delegate passTrendValues:fujinmodel.tel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
