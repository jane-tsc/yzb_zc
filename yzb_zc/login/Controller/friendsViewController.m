//
//  friendsViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "friendsViewController.h"
#import "serviceViewCell.h"
#import "AllObject.h"
#import "haoyouModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface friendsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *array;
    NSMutableArray *listarray;
    UITableView *table;
     UIView *hiddenView;///没有数据界面
    NSString *list;
}

@end

@implementation friendsViewController

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
    self.title = @"好友服务商";
     array = [[NSMutableArray alloc]init];
    listarray = [[NSMutableArray alloc] init];
    
    //    设置 状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    table.backgroundColor = [UIColor whiteColor];
    table.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    table.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);///设置分割线的左右距离
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.tableFooterView = [[UIView alloc]init];
    table.hidden = YES;
    
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook =ABAddressBookCreate();
    }
    if (tip) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
 
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    //进行遍历
    for (NSInteger i=0; i<number; i++) {
    //获取联系人对象的引用
    ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
    //获取当前联系人的备注
    NSString*notes=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonNoteProperty));
        
    //获取当前联系人的电话 数组
    NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
    ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
    for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
        [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
        
        [array addObjectsFromArray:phoneArr];
        
    }
}

        list = [array componentsJoinedByString:@","];
    
//        list = [NSString stringWithFormat:@"%@,%@,%@",@"15096187296",@"18696965546",@"15977161383"];
        [self setupTableView];
        [self hiddenSubview];
        [self configeData];
}

///没有数据显示的界面
- (void)hiddenSubview{
    hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    hiddenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hiddenView];
    
    ///none_inform@2x.png
    UIImageView *hiddenimage = [UIImageView new];
    hiddenimage.image = [UIImage imageNamed:@"none_inform@2x.png"];
    [hiddenView addSubview:hiddenimage];
    [hiddenimage makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(73);
        make.width.equalTo(73);
        make.centerX.equalTo(hiddenView.centerX);
        make.top.equalTo(hiddenView.top).offset(screen_height / 4);
    }];
    UILabel *title = [UILabel new];
    title.text = @"服务商不存在";
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    [hiddenView addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hiddenimage.bottom).offset(15);
        make.centerX.equalTo(hiddenimage.centerX);
    }];
    
    hiddenView.hidden = YES;
}
///刷新表格
- (void)fireshTableview{
    
    if (listarray.count == 0)
    {
        hiddenView.hidden = NO;
        table.hidden = YES;
    }
    else
    {
        hiddenView.hidden = YES;
        table.hidden = NO;
    }
    [table reloadData];
}

- (void)configeData{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] TheserverWithPoint:@"getServerByTelList" andParamsDictionary:[NSString stringWithFormat:@"serverTelList=%@",list] andURL:@"Server" andSuccessCompletioned:^(id object) {
        if ([object [@"code"]boolValue]) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = [object objectForKey:@"data"];
            
//            listarray = [haoyouModel objectArrayWithKeyValuesArray:dic [@"list"]];
            [listarray addObjectsFromArray:[haoyouModel objectArrayWithKeyValuesArray:dic [@"list"]]];
            
            [self fireshTableview];
            
        }
        else if ([object [@"code"] intValue] == 3250){
        
            [self fireshTableview];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

///如果没有服务商就现实一张图片
- (void)setupView{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 500)];
    image.backgroundColor = [UIColor grayColor];
    [self.view addSubview:image];
}

- (void)setupTableView{
    
    table.tableFooterView = [[UIView alloc]init];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    serviceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[serviceViewCell alloc] init];
    }
    
    haoyouModel *haoyou = [listarray objectAtIndex:indexPath.row];
    cell.Image.image = [UIImage imageNamed:@"tx_bg_nor.png"];
    cell.title.text = haoyou.user;
    cell.phoneNumber.text = haoyou.tel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    haoyouModel *haoyou = listarray [indexPath.row];
    NSLog(@"haoyou.tel:%@",haoyou.tel);
    if (self.Delegate && [self.Delegate respondsToSelector:@selector(friendspassTrendValues:)]) {
        [self.Delegate friendspassTrendValues:haoyou.tel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
