//
//  SecurityViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "SecurityViewController.h"
#import "securViewCell.h"
#import "UIColor+RGB.h"
#import "BrushsuccessViewController.h"
#import "SetpasswordViewController.h"
#import "ValidationsetViewController.h"
#import "TouchIDViewController.h"


@interface SecurityViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    UITableView *_tableView;
    NSInteger rowIndex;
}

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(249, 253, 255);
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"安全设置";
    [self setWithTableView];
    
     NSLog(@" --\n- 密码验证:%d---\n--指纹验证:%d --\n--证书删除;%d ---\n--证书出证;%d  －－－\n：原文件下载：%d-----\n---原文件删除：%d",[User shareUser].RenlianType,[User shareUser].fingerprint,[User shareUser].zhenshuDelete,[User shareUser].zhengshuchuzheng,[User shareUser].yuanwenjianxiazai,[User shareUser].yuanwenjianDelete);
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [_tableView reloadData];///进入这个页面刷新页面
}

- (void)setWithTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, screen_width, screen_height - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(247, 253, 255);
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    securViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[securViewCell alloc]init];
    }
    [cell configWithindexPath:indexPath];
    
    ///验证方式
    ///密码验证
    if ([User shareUser].RenlianType == 0) {
        cell.password.text = @"未设置";
    }else if ([User shareUser].RenlianType == 1){
        cell.password.text = @"已设置";
    }
    
    ///指纹验证
    if ([User shareUser].fingerprint == 0) {
        cell.fingerprint.text = @"未设置";
    }else if ([User shareUser].fingerprint == 1){
        cell.fingerprint.text = @"已设置";
    }else if ([User shareUser].fingerprint == 2){
        cell.fingerprint.text = @"不启用";
    }
    
    
    ///证书删除
    if ([User shareUser].zhenshuDelete == 0) {
        cell.shanchu.text = @"未设置";
    }else if ([User shareUser].zhenshuDelete == 10){
        cell.shanchu.text = @"不启用";
    }
    else if ([User shareUser].zhenshuDelete == 20){
        cell.shanchu.text = @"刷脸验证";
    }
    else if ([User shareUser].zhenshuDelete  == 30){
        cell.shanchu.text = @"密码验证";
    }
    else if ([User shareUser].zhenshuDelete  == 40){
        cell.shanchu.text = @"指纹验证";
    }
    
    
    ///证书出征
    if ([User shareUser].zhengshuchuzheng == 0) {
        cell.chuzhen.text = @"未设置";
    }else if ([User shareUser].zhengshuchuzheng == 10){
        cell.chuzhen.text = @"不启用";
    }else if ([User shareUser].zhengshuchuzheng  == 20){
        cell.chuzhen.text = @"刷脸验证";
    }else if ([User shareUser].zhengshuchuzheng == 30){
        cell.chuzhen.text = @"密码验证";
    }else if ([User shareUser].zhengshuchuzheng  == 40){
        cell.chuzhen.text = @"指纹验证";
    }
    
    
    ///源文件下载
    if ([User shareUser].yuanwenjianxiazai == 0) {
        cell.xiazai.text = @"未设置";
    }else if ([User shareUser].yuanwenjianxiazai == 10){
        cell.xiazai.text = @"不启用";
    }else if ([User shareUser].yuanwenjianxiazai == 20){
        cell.xiazai.text = @"刷脸验证";
    }else if ([User shareUser].yuanwenjianxiazai == 30){
        cell.xiazai.text = @"密码验证";
    }else if ([User shareUser].yuanwenjianxiazai == 40){
        cell.xiazai.text = @"指纹验证";
    }

    ///源文件删除
    if ([User shareUser].yuanwenjianDelete == 0) {
        cell.yuanwenjianshanchu.text = @"未设置";
    }else if ([User shareUser].yuanwenjianDelete == 10){
        cell.yuanwenjianshanchu.text = @"不启用";
    }else if ([User shareUser].yuanwenjianDelete == 20){
        cell.yuanwenjianshanchu.text = @"刷脸验证";
    }else if ([User shareUser].yuanwenjianDelete == 30){
        cell.yuanwenjianshanchu.text = @"密码验证";
    }else if ([User shareUser].yuanwenjianDelete == 40){
        cell.yuanwenjianshanchu.text = @"指纹验证";
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }else{
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }else{
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            ///进入设置密码界面
            if ([User shareUser].RenlianType == 0) {
                
                SetpasswordViewController *setuppassword = [[SetpasswordViewController alloc]init];
                [self.navigationController pushViewController:setuppassword animated:YES];
                
            }
            else if ([User shareUser].RenlianType == 1)
            {
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"密码验证"
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"重置",nil];
                
                [actionSheet showInView:self.view];
                
                rowIndex = 20;

            }
                
            }
            ///指纹验证
            else if(indexPath.row == 2)
            {
                if ([User shareUser].fingerprint == 0) {
                    TouchIDViewController *thou = [[TouchIDViewController alloc]init];
                    [self.navigationController pushViewController:thou animated:YES];
                }else{
                
                }
            }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {

                UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"证书删除"
                                              delegate:self
                                              cancelButtonTitle:@"不启用"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"启用指纹验证",@"启用密码验证",nil];
                
                [actionSheet showInView:self.view];
                
                rowIndex = 1;
        }
        else if (indexPath.row == 2)
        {
                UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"证书出证"
                                              delegate:self
                                              cancelButtonTitle:@"不启用"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"启用指纹验证",@"启用密码验证",nil];
                
                [actionSheet showInView:self.view];
                rowIndex = 2;
        }
        else if (indexPath.row == 3)
        {
                UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"原文件下载"
                                              delegate:self
                                              cancelButtonTitle:@"不启用"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"启用指纹验证",@"启用密码验证",nil];
                
                [actionSheet showInView:self.view];
                
                rowIndex = 3;

        }
        else if (indexPath.row == 4)
        {

                UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"原文件删除"
                                              delegate:self
                                              cancelButtonTitle:@"不启用"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"启用指纹验证",@"启用密码验证",nil];
                
                [actionSheet showInView:self.view];
                
                rowIndex = 4;
        }
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (rowIndex == 1)
    {
        switch (buttonIndex) {
            case 0:
            {
                if ([User shareUser].fingerprint == 0) {
                    [OMGToast showWithText:@"请先设置指纹验证"];
                }else{
                
                    NSLog(@"指纹验证");
                    ///   10  不启用     20 启用    30密码     40指纹
                    [[TSCCntc sharedCntc] queryWithPoint:@"setDelCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delCertState=%@",[User shareUser].appKey,[User shareUser].authToken,@"40"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            [OMGToast showWithText:@"修改成功"];
                            NSString *string = object[@"data"] [@"delCertState"];
                            [User shareUser].zhenshuDelete = [string intValue];
                            [User saveUserInfo];
                            [self fireshTabbleView];
                        }else{
                            [OMGToast showWithText:object[@"msg"]];
                        }
                    } andFailed:^(NSString *object) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                }
            }
                break;
                
            case 1:
            {
                
                if ([User shareUser].RenlianType == 0){
                    
                    [OMGToast showWithText:@"请先设置密码验证"];
                }else{
                
                NSLog(@"密码验证");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDelCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delCertState=%@",[User shareUser].appKey,[User shareUser].authToken,@"30"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    NSLog(@"object:%@",object);
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string =object[@"data"] [@"delCertState"];
                        [User shareUser].zhenshuDelete = [string intValue];
                        [User saveUserInfo];
                        
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
               }
            }
                break;
              
            case 2:
            {
                if ([User shareUser].RenlianType == 0 && [User shareUser].fingerprint == 0){
                    
                    [OMGToast showWithText:@"请先设置验证方式"];
                }else {
                
                NSLog(@"取消");
                ///   10  不启用     20 启用    30密码     40指纹
                 [[TSCCntc sharedCntc] queryWithPoint:@"setDelCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delCertState=%@",[User shareUser].appKey,[User shareUser].authToken,@"10"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                
                                    if ([object [@"code"] integerValue] == 200) {
                                        [OMGToast showWithText:@"修改成功"];
                                        NSString *string =object[@"data"] [@"delCertState"];
                                        [User shareUser].zhenshuDelete = [string intValue];
                                        [User saveUserInfo];
                
                                        [self fireshTabbleView];
                                    }else{
                                        [OMGToast showWithText:object[@"msg"]];
                                    }
                                } andFailed:^(NSString *object) {
                                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                                }];
                }
            }
                break;
            default:
                break;
        }
    }
    else if (rowIndex == 2)
    {
        switch (buttonIndex) {
            case 0:
            {
                if ([User shareUser].fingerprint == 0) {
                    [OMGToast showWithText:@"请先设置指纹验证"];
                }else{
                NSLog(@"证书出征");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setTestifyType" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&testifyType=%@",[User shareUser].appKey,[User shareUser].authToken,@"40"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string =object [@"data"][@"testifyType"];
                        [User shareUser].zhengshuchuzheng = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
              }
            }
                break;
            case 1:
            {
                if ([User shareUser].RenlianType == 0){
                    
                    [OMGToast showWithText:@"请先设置密码验证"];
                }else{
                ///  10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setTestifyType" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&testifyType=%@",[User shareUser].appKey,[User shareUser].authToken,@"30"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string =object [@"data"][@"testifyType"];
                        [User shareUser].zhengshuchuzheng = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
               }
            }
                break;
                
            case 2:
            {
                if ([User shareUser].RenlianType == 0 && [User shareUser].fingerprint == 0){
                    
                    [OMGToast showWithText:@"请先设置验证方式"];
                }else {
                ///  10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setTestifyType" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&testifyType=%@",[User shareUser].appKey,[User shareUser].authToken,@"10"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string =object [@"data"][@"testifyType"];
                        [User shareUser].zhengshuchuzheng = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
            default:
                break;
        }
    }
    
    else if (rowIndex == 3)
    {
        switch (buttonIndex) {
            case 0:
            {
                if ([User shareUser].fingerprint == 0) {
                    [OMGToast showWithText:@"请先设置指纹验证"];
                }else{
                NSLog(@"原文件下载");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDownCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&downFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"40"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string = object[@"data"][@"downFileState"];
                        [User shareUser].yuanwenjianxiazai = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
            case 1:
            {
                if ([User shareUser].RenlianType == 0){
                    
                    [OMGToast showWithText:@"请先设置密码验证"];
                }else{
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDownCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&downFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"30"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *String = object[@"data"][@"downFileState"];
                        [User shareUser].yuanwenjianxiazai = [String intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
              }
            }
                break;
            case 2:
            {
                if ([User shareUser].RenlianType == 0 && [User shareUser].fingerprint == 0){
                    
                    [OMGToast showWithText:@"请先设置验证方式"];
                }else {
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDownCertState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&downFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"10"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *String = object[@"data"][@"downFileState"];
                        [User shareUser].yuanwenjianxiazai = [String intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else if (rowIndex == 4)
    {
        switch (buttonIndex) {
            case 0:
            {
                if ([User shareUser].fingerprint == 0) {
                    [OMGToast showWithText:@"请先设置指纹验证"];
                }else{
                NSLog(@"原文件删除");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDelFileState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"40"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string =object [@"data"][@"delFileState"];
                        [User shareUser].yuanwenjianDelete = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
                
                
            case 1:
            {
                if ([User shareUser].RenlianType == 0){
                    
                    [OMGToast showWithText:@"请先设置密码验证"];
                }else{
                NSLog(@"原文件删除");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDelFileState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"30"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                         NSString *string =object [@"data"][@"delFileState"];
                        [User shareUser].yuanwenjianDelete = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
                
                
            case 2:
            {
                if ([User shareUser].RenlianType == 0 && [User shareUser].fingerprint == 0){
                    
                    [OMGToast showWithText:@"请先设置验证方式"];
                }else {
                NSLog(@"原文件删除");
                ///   10  不启用     20 启用    30密码     40指纹
                [[TSCCntc sharedCntc] queryWithPoint:@"setDelFileState" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&delFileState=%@",[User shareUser].appKey,[User shareUser].authToken,@"10"] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        NSString *string = object [@"data"][@"delFileState"];
                        [User shareUser].yuanwenjianDelete = [string intValue];
                        [User saveUserInfo];
                        [self fireshTabbleView];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                }
            }
                break;
            default:
                break;
        }
    }
    else if (rowIndex == 20)
    {
        switch (buttonIndex) {
            case 0:
            {
                ValidationsetViewController *valida = [[ValidationsetViewController alloc]init];
                [self.navigationController pushViewController:valida animated:YES];
                NSLog(@"重置按钮");
            }
                break;
                
            case 1:
            {
                 NSLog(@"取消按钮");
            }
                break;
            default:
                break;
        }
    }
}
///刷新表格
- (void)fireshTabbleView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tableView reloadData];
        
    });
}

#pragma mark - 确实修改点击事件
- (void)querenxiugaiClick1:(UIButton *)sender{
    NSLog(@"您点击了确认修改按钮");
}

@end
