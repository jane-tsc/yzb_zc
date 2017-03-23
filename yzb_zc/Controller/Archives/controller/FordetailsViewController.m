//
//  FordetailsViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "FordetailsViewController.h"
#import "FordetailsViewCell.h"
#import "TheViewController.h"
#import "addressViewController.h"
#import "PayViewController.h"

@interface FordetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIScrollView *scrollview;
    UITableView *_tableView;
    NSString *price;
    UIView *footerview;
}
@property (nonatomic, strong) UILabel *price;///价格
@property(nonatomic,strong) UIButton *ZhiFuButton;///确认支付
@property(nonatomic,strong) NSMutableDictionary *Dictionary;

@end

@implementation FordetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(247, 253, 255);
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.Dictionary = [[NSMutableDictionary alloc]init];
    self.title = @"出证详情";
  
    UIView *hen =[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:hen];
    
    [self setupView];
    [self httprestsTableviewFile];
    

    NSLog(@"fileID:------%@",self.fileID);
}

- (void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
    [self httprestsTableviewFile];
}

- (void) setupView{
    
    scrollview = UIScrollView.new;
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.showsHorizontalScrollIndicator   = YES;
    scrollview.showsVerticalScrollIndicator     = YES;
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(self.view.left);
        make.width.equalTo(screen_width);
        make.top.equalTo(self.view.top).offset(0.5);
        make.height.equalTo(screen_height -64);
    }];
    scrollview.contentSize = CGSizeMake(screen_width, screen_height +170);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height + 30) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.scrollEnabled =NO;
    _tableView.dataSource = self;
    [scrollview addSubview:_tableView];

    footerview = [[UIView alloc]init];
    footerview.backgroundColor = [UIColor whiteColor];
    footerview.frame= CGRectMake(0, screen_height + 30, screen_width, 100);
    [scrollview addSubview:footerview];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake( 20, 20 , screen_width - 40, 20)];
    _price.textColor = [UIColor blackColor];
    _price.textAlignment = NSTextAlignmentLeft;
    _price.font = [UIFont boldSystemFontOfSize:screen_width / 22];
    [footerview addSubview:_price];
    
    ///确认支付
    self.ZhiFuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ZhiFuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ZhiFuButton setTitle:@"确认支付" forState:UIControlStateNormal];
    self.ZhiFuButton.layer.cornerRadius = 15.0;
    [self.ZhiFuButton setBackgroundColor:RGB(251, 140, 142)];
    self.ZhiFuButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.ZhiFuButton.layer.shadowOpacity = 0.5;
    self.ZhiFuButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.ZhiFuButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [footerview addSubview:self.ZhiFuButton];
    [self.ZhiFuButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(_price.bottom).offset(30);
        make.width.equalTo(screen_width / 2.4);
        make.height.equalTo(screen_width / 11);
    }];
    [self.ZhiFuButton addTarget:self action:@selector(ZhiFuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

///请求网络
- (void)httprestsTableviewFile{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getTestifyDetail" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileID] andURL:@"Testify" andSuccessCompletioned:^(id object) {
        
        NSLog(@"object ;;------%@",object);
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            self.Dictionary =  object [@"data"];
            
            price = self.Dictionary [@"amount"];
            NSString *string = [NSString stringWithFormat:@"费用合计:        ¥%@",price];
            _price.text = string;
            [_tableView reloadData];
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

#pragma mark - 确认支付
- (void)ZhiFuButtonClick:(UIButton *)sender{
    
    if ([[User shareUser].addressDetailed isEqualToString:@""] || [[User shareUser].addressDetailed isKindOfClass:[NSNull class]]) {
        [OMGToast showWithText:@"地址为空，请先选择地址"];
    }else{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&amountType=%@&addressId=%@",[User shareUser].appKey,[User shareUser].authToken,self.fileID,self.Dictionary [@"amountType"],self.Dictionary [@"addressId"]] andURL:@"Testify" andSuccessCompletioned:^(id object) {
        
        NSLog(@"object ;;------%@",object);
        if ([object [@"code"] integerValue] == 200) {
           
            NSDictionary *dic = object [@"data"];
            NSDictionary *dicc = dic [@"order"];
            NSLog(@"dic:%@",dicc);
            NSLog(@"确认支付");
            PayViewController *pay = [[PayViewController alloc]init];
            pay.payType = @"300";
            pay.data = dicc;
            pay.image = self.image;
            
            [self.navigationController pushViewController:pay animated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }
    else if(indexPath.row == 6){
        return 100;
    }
    else if(indexPath.row == 8){
        return 80;
    }else{
        return 70;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidflent = @"cell";
    FordetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
    if (cell == nil) {
        cell = [[FordetailsViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell initWithIndexpath:indexPath];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.name.text = self.Dictionary [@"addressUserName"];
    cell.phone.text = self.Dictionary [@"addressUserTel"];
    cell.addressArea.text = self.Dictionary [@"addressArea"];
    cell.addressDetail.text = self.Dictionary [@"addressDetail"];
    cell.beianNum.text = self.Dictionary [@"certSn"];
    cell.danganName.text = self.Dictionary [@"archiveName"];
    
    if ([self.Dictionary [@"fileType"] integerValue] == 10)
    {
        cell.baoquanType.text = @"文档";
    }
    else if ([self.Dictionary [@"fileType"] integerValue] == 20)
    {
       cell.baoquanType.text = @"其它";
    }
    else if ([self.Dictionary [@"fileType"] integerValue] == 30)
    {
        cell.baoquanType.text = @"音频";
    }
    else if ([self.Dictionary [@"fileType"] integerValue] == 40)
    {
        cell.baoquanType.text = @"视频";
    }
    else if ([self.Dictionary [@"fileType"] integerValue] == 50)
    {
        cell.baoquanType.text = @"其它";
    }
   
    
    [cell.Modifybtn addTarget:self action:@selector(xiugaiaddressClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 修改信息按钮
- (void)xiugaiaddressClick:(UIButton *)sender{
   
    addressViewController *address = [[addressViewController alloc]init];
    address.flag = YES;
    ///传10 证明是从出证详情页面跳转的
    address.addressType = @"10";
    [self.navigationController pushViewController:address animated:YES];
    NSLog(@"修改信息按钮");
}

@end
