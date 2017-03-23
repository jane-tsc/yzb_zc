//
//  SearchViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "SearchViewController.h"
#define TAGSEAR 120
#import "ArchiveViewCell.h"
#import "fileListModel.h"
#import "dirListModel.h"
#import "DetailsViewController.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{

    UIImageView * searchBackground;
    UISearchBar * searbar;
    UITableView *_tableView;
     UIView *hiddenView;///没有数据界面
    
}
@property (nonatomic, strong) NSMutableArray *searchResults;/**<搜索结果数据源*/
@end

@implementation SearchViewController

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
    self.searchResults = [NSMutableArray array];
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    
    [self searchUpview];
    [self hiddenSubview];
    [self fireshTableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [(UIImageView *)[self.navigationController.navigationBar viewWithTag:TAGSEAR] setHidden:NO];
    [super viewWillAppear:YES];
    
    [searbar becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [searchBackground removeFromSuperview];
    [(UIImageView *)[self.navigationController.navigationBar viewWithTag:TAGSEAR] setHidden:YES];
    [super viewWillDisappear:YES];
}
- (void)searchUpview{
    ///中间搜索部分
    searchBackground = [[UIImageView alloc] initWithFrame:CGRectMake(30, 9, screen_width - 90, 25)];
    searchBackground.tag = TAGSEAR;
    searchBackground.layer.cornerRadius = 4;
    searchBackground.userInteractionEnabled = YES;
    searchBackground.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:searchBackground];
    searbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screen_width - 90, 25)];
    searbar.backgroundColor = [UIColor clearColor];
    searbar.placeholder = @"档案名称";
    [searchBackground addSubview:searbar];
    searbar.delegate = self;
    searbar.searchBarStyle = UISearchBarStyleMinimal;
    
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelButtonClick)];
    rigthButton.tintColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = rigthButton;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
     _tableView.hidden = YES;
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
    title.text = @"暂无档案信息";
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

///键盘上搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    HIDEKEYBOARD;
    
     [SVProgressHUD showWithStatus:@"搜索中..." maskType:SVProgressHUDMaskTypeGradient];
    [[TSCCntc sharedCntc] queryWithPoint:@"getListBySearch" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&searchKey=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,searchBar.text,@"2",@"2"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            [self.searchResults removeAllObjects];///搜索前先清除数组
            
            NSDictionary *Dictionary = [object objectForKey:@"data"];
            
             [self.searchResults addObjectsFromArray:[fileListModel objectArrayWithKeyValuesArray:Dictionary [@"fileList"]]];
            
            [self fireshTableview];
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

///刷新表格
- (void)fireshTableview{
    
    if (self.searchResults.count == 0)
    {
        hiddenView.hidden = NO;
        _tableView.hidden = YES;
    }
    else
    {
        hiddenView.hidden = YES;
        _tableView.hidden = NO;
    }
    [_tableView reloadData];
}

///取消按钮
- (void)CancelButtonClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.searchResults.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *cellidflent = @"cell";
        ArchiveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
        if (cell == nil) {
            cell = [[ArchiveViewCell alloc]init];
        }
        
        fileListModel *fileListmodel = [self.searchResults objectAtIndex:indexPath.row];
        
        ///根据后缀名去判断显示图片类型
        if ([fileListmodel.fileType isEqualToString:@"10"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanwendang.png"];
            
        }
        else if([fileListmodel.fileType isEqualToString:@"20"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquantupian.png"];
        }
        else if ([fileListmodel.fileType isEqualToString:@"30"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanyingping.png"];
        }
        else if ([fileListmodel.fileType isEqualToString:@"40"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanshiping.png"];
        }
        else if ([fileListmodel.fileType isEqualToString:@"50"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanqita.png"];
        }
//        
//        ///根据后缀名去判断小图片类型
//        if ([fileListmodel.fileType isEqualToString:@"10"])
//        {
//            cell.fileimagetype.image = [UIImage imageNamed:@"baoquanwendang.png"];
//            
//        }
//        else if([fileListmodel.fileType isEqualToString:@"20"])
//        {
//            cell.fileimagetype.image = [UIImage imageNamed:@"baoquantupian.png"];
//        }
//        else if ([fileListmodel.fileType isEqualToString:@"30"])
//        {
//            cell.fileimagetype.image = [UIImage imageNamed:@"baoquanyingping.png"];
//        }
//        else if ([fileListmodel.fileType isEqualToString:@"40"])
//        {
//            cell.fileimagetype.image = [UIImage imageNamed:@"baoquanshiping.png"];
//        }
//        else if ([fileListmodel.fileType isEqualToString:@"50"])
//        {
//            cell.fileimagetype.image = [UIImage imageNamed:@"baoquanqita.png"];
//        }
    
        ///usedStatus ＝＝ 0  显示试用字段
        if ([fileListmodel.usedStatus intValue] == 0) {
            ///试用字体
            cell.lableTrial.text = @"试用";
            cell.lableTrial.backgroundColor = RGB(246, 142, 140);
        }
        else
        {
            
            
        }
        cell.name.text = fileListmodel.archiveName;
        
        cell.time.text = fileListmodel.securityTime;
        cell.version.text = fileListmodel.remarks;
        if ([fileListmodel.storageState integerValue] == 1) {
            cell.save.text = @"已代管";
            ///給已代管的文件加边逛
            cell.save.layer.borderColor = RGB(135, 166, 242).CGColor;
            cell.save.layer.borderWidth = 1.0;
            cell.save.layer.cornerRadius = 2.0;
            cell.save.layer.masksToBounds = YES;
            cell.save.textColor =RGB(135, 166, 242);
        }else{
            
        }
        
        if ([fileListmodel.storageState integerValue] == 1) {
//            cell.baoquanSuccess.text = @"成功";
        }else{
            
            //            cell.baoquan.textColor = RGB(252, 174, 176);
            //            cell.baoquan.text = @"失败";
            //            [cell.retryButton setBackgroundImage:[UIImage imageNamed:@"sx_n@2x.png"] forState:UIControlStateNormal];///失败按钮
        }
        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fileListModel *model = [self.searchResults objectAtIndex:indexPath.row];
    DetailsViewController *details = [[DetailsViewController alloc]init];
    details.fileid = model.certId;
    details.chenggongType = @"1";
    details.labletitle = model.archiveName;
    [self.navigationController pushViewController:details animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
@end
