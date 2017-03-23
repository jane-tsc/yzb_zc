//
//  ArchivesViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ArchivesViewController.h"
#import "WLZShareController.h"
#import "ArchiveViewCell.h"
#import "XTPopView.h"
#import "QKYMyTitleView.h"
#import "OMGToast.h"
#import "DetailsViewController.h"
#import "originalYESViewController.h"
#import "ZCMTBtnView.h"
#import "MyMD5.h"
#import "fileListModel.h"
#import "dirListModel.h"
#import "FinderViewController.h"
#import "SearchViewController.h"
#import "YidongViewController.h"

@interface ArchivesViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,selectIndexPathDelegate,UITextFieldDelegate>{
    UIButton * _rightItem;
    UIButton * _leftItem;
    UITableView *_tableView;
    UIImageView *Newfolder;
    UIImageView *Newfolder1;
    UIImageView *searchBackground;
    XTPopView *view1;
    UIView *typeView;
    UIButton *qbBtn;
    UIBarButtonItem *editButton;
    UIView *hiddenView;///没有数据界面
    UITextField *userEmail;
}
///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
///文件
@property(nonatomic,strong) NSMutableArray *fileList;

@property (nonatomic,strong) NSMutableDictionary *selectedDic;

@end

@implementation ArchivesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    设置 状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.dirList = [NSMutableArray array];
    self.fileList = [NSMutableArray array];
    [self fireshTableview];
    [self setNavigationItem];
    [self setViewUp];
    [self setViewTableView];
    [self hiddenSubview];
    [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];

    ///自定义导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    self.navigationItem.titleView = navView;
    qbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qbBtn.selected = YES;
    [qbBtn setTitle:@"全部" forState:UIControlStateNormal];
    [qbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qbBtn.titleLabel.font = [UIFont systemFontOfSize:NacFontsize];
    [qbBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 60, 0, -60)];
    [qbBtn setImage:[UIImage imageNamed:@"back-icon_up.png"] forState:UIControlStateNormal];
    [qbBtn setImage:[UIImage imageNamed:@"back-icon_down.png"] forState:UIControlStateSelected];
    [navView addSubview:qbBtn];
    [qbBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.left).offset(-20);
        make.top.equalTo(navView.top);
        make.width.equalTo(70);
        make.height.equalTo(30);
    }];
    [qbBtn addTarget:self action:@selector(qbBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ///点击导航栏按钮弹出popview 视图
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, - screen_height, screen_width, screen_height - 64)];
    typeView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:typeView];
    
    for (int i = 0; i < 7; i++) {
        if (i < 3) {
            NSMutableArray *images1 = [NSMutableArray arrayWithObjects:@"wenjian3.png",@"tupian3.png",@"yinyue3.png", nil];
            NSMutableArray *titles1 = [NSMutableArray arrayWithObjects:@"全部",@"图片",@"音频", nil];
            ZCMTBtnView *btnView = [[ZCMTBtnView alloc] initWithFrame:CGRectMake(i * screen_width / 3, 0, screen_width / 3, 120) title:titles1 [i] imageStr:images1 [i]];
            btnView.tag = 100 + i;
            
            [typeView addSubview:btnView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
            [btnView addGestureRecognizer:tap];
            
        }else if (i < 6){
            
            CGRect frame = CGRectMake((i-3)*screen_width/3, 150, screen_width/3, 120);
            NSMutableArray *images2 = [NSMutableArray arrayWithObjects:@"yinping3.png",@"wendang3.png",@"qita3.png", nil];
            NSMutableArray *titles2 = [NSMutableArray arrayWithObjects:@"视频",@"文档",@"其他", nil];
            ZCMTBtnView *btnView = [[ZCMTBtnView alloc] initWithFrame:frame title:titles2 [i - 3] imageStr:images2 [i - 3]];
            btnView.tag = 100 + i;
            [typeView addSubview:btnView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
            [btnView addGestureRecognizer:tap];
            
        }else if(i < 7){
            
            NSMutableArray *images3 = [NSMutableArray arrayWithObjects:@"biaoji3.png", nil];
            NSMutableArray *titles3 = [NSMutableArray arrayWithObjects:@"标记", nil];
            ZCMTBtnView *btnView = [[ZCMTBtnView alloc] initWithFrame:CGRectMake((i - 6) * screen_width / 3, 300, screen_width / 3, 120) title:titles3 [i - 6] imageStr:images3 [i - 6]];
            btnView.tag = 100 + i;
            [typeView addSubview:btnView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
            [btnView addGestureRecognizer:tap];
        }
    }
}
#pragma mark - 全部按钮
- (void)qbBtnClick:(UIButton *)sender{
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            typeView.frame = CGRectMake(0, 0, self.view.frame.size.width, screen_height - 64);
            ///这个是隐藏导航栏上的按钮    顺序是 012
//            _rightItem.hidden = YES;
//                        [[self.navigationController.navigationBar.subviews objectAtIndex:2] setHidden:YES];
        }];
        sender.selected = NO;
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
//            _rightItem.hidden = NO;
//                         [[self.navigationController.navigationBar.subviews objectAtIndex:2] setHidden:NO];
        }];
        sender.selected = YES;
    }
}
///刷新表格
- (void)fireshTableview{
    
    if (self.fileList.count == 0 && self.dirList.count == 0)
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
    
    //    ///dirId ＝ 文件类型    sort＝ 排序    listBy ＝ 文件或者目录
//    [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];
}

///列举文件与目录  －－－1＝时间排序      2=文件名排序
- (void)httprestsTableviewFiledirId:(NSString *)dirId sort:(NSString *)sort listBy:(NSString *)listBy{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFilePath" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,dirId,sort,listBy] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            ///首先先清除数组内容
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            [self.fileList addObjectsFromArray:[fileListModel objectArrayWithKeyValuesArray:dic [@"fileList"]]];
            [self.dirList addObjectsFromArray:[dirListModel objectArrayWithKeyValuesArray:dic [@"dirList"]]];
            
            NSLog(@"self.fileList:%lu---self.dirList:%lu",(unsigned long)self.fileList.count,(unsigned long)self.dirList.count);
            
            [self fireshTableview];
            
        }else {
            
            [SVProgressHUD dismiss];
            
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            [self fireshTableview];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}


///根据文件类型列举文件  －－－1＝时间排序      2=文件名排序
- (void)httprestslistFileByType:(NSString *)dirId sort:(NSString *)sort listBy:(NSString *)listBy{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFileByType" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certType=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,dirId,sort,listBy] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            ///首先先清除数组内容
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            [self.fileList addObjectsFromArray:[fileListModel objectArrayWithKeyValuesArray:dic [@"fileList"]]];
            [self.dirList addObjectsFromArray:[dirListModel objectArrayWithKeyValuesArray:dic [@"dirList"]]];
            
            NSLog(@"self.fileList:%lu---self.dirList:%lu",(unsigned long)self.fileList.count,(unsigned long)self.dirList.count);
            
            [self fireshTableview];
            
        }else {
            
            [SVProgressHUD dismiss];
            
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            [self fireshTableview];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

///一进入这个页面就刷新
- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
//    [self fireshTableview];
    
    [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];
    
    [_tableView reloadData];
}

- (void)setNavigationItem
{
    //多选按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(NavigationRightItemClick)];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (void)setViewUp{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    Newfolder = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16.5, 37, 37)];
    Newfolder.image = [UIImage imageNamed:@"add_nor.png"];
    [view addSubview:Newfolder];
    Newfolder.userInteractionEnabled = YES;
    Newfolder.hidden = NO;
    UITapGestureRecognizer *newtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newfolderClick)];
    [Newfolder addGestureRecognizer:newtap];
    
    Newfolder1 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 16.5, 37, 37)];
    Newfolder1.image = [UIImage imageNamed:@"add_change.png"];
    [view addSubview:Newfolder1];
    Newfolder1.userInteractionEnabled = YES;
    UITapGestureRecognizer *newtap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newfolderClick1)];
    [Newfolder1 addGestureRecognizer:newtap1];
    
    
    ///search_bq.png
    searchBackground = [[UIImageView alloc]initWithFrame:CGRectMake(130, 22.5, screen_width - 145, 27)];
    searchBackground.layer.cornerRadius = 2;
    searchBackground.userInteractionEnabled = YES;
    searchBackground.image =[UIImage imageNamed:@"search_bq.png"];
    [view addSubview:searchBackground];
    UITapGestureRecognizer *tapsousuo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sousuoClick)];
    [searchBackground addGestureRecognizer:tapsousuo];

    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(3, 70, screen_width - 6, 0.5)];
    hen.alpha = 0.3;
    hen.backgroundColor = [UIColor grayColor];
    [view addSubview:hen];
}
///一点击搜索框调入搜索界面
- (void)sousuoClick{
    SearchViewController *search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

///没有数据显示的界面
- (void)hiddenSubview{
    hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, screen_width, screen_height - 134)];
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

- (void)setViewTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, screen_width, screen_height - 134) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dirList.count;
    }else if (section == 1){
        return self.fileList.count;
    }
    return 0;
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
    
    if (indexPath.section == 0) {
        
        static NSString *cellidflent = @"cell";
        ArchiveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
        if (cell == nil) {
            cell = [[ArchiveViewCell alloc]init];
        }
        
        dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row];
        
        cell.RigthImg.image = [UIImage imageNamed:@"next_n@2x.png"];
        cell.image.image = [UIImage imageNamed:@"file_n@2x.png"];
        cell.dirName.text = dirlmodel.dirName;
        cell.dirTime.text = dirlmodel.dirTime;
        
        return cell;
    }
    else
    {
        static NSString *cellidflent = @"cell";
        ArchiveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
        if (cell == nil) {
            cell = [[ArchiveViewCell alloc]init];
        }
        
        fileListModel *fileListmodel = [self.fileList objectAtIndex:indexPath.row];
        
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
            cell.fileimage.image = [UIImage imageNamed:@"baoquanyinpin.png"];
            
        }
        else if ([fileListmodel.fileType isEqualToString:@"40"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanshiping.png"];
        }
        else if ([fileListmodel.fileType isEqualToString:@"50"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanqita.png"];
        }
        
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
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (!tableView.editing) {
        
        ///这个是点击文件夹
        if (indexPath.section == 0)
        {
            FinderViewController *finder = [[FinderViewController alloc]init];
            dirListModel *model =[self.dirList objectAtIndex:indexPath.row];
            finder.labletitle = model.dirName;
            finder.string = model.dirId;
            [self.navigationController pushViewController:finder animated:YES];
        }
        ///这个是点击文件
        else if (indexPath.section == 1)
        {
            fileListModel *model = [self.fileList objectAtIndex:indexPath.row];
            DetailsViewController *details = [[DetailsViewController alloc]init];
            details.fileid = model.certId;
            //                details.chenggongType = @"1";
            details.labletitle = model.archiveName;
            [self.navigationController pushViewController:details animated:YES];
            
        }
        
    }
    
    
    //
    //        fileListModel *model = [self.fileList objectAtIndex:indexPath.row];
    //        DetailsViewController *details = [[DetailsViewController alloc]init];
    //        details.fileid = model.certId;
    //        details.labletitle = model.archiveName;
    //        [self.navigationController pushViewController:details animated:YES];
    
}

-(NSMutableDictionary*)selectedDic{
    if (_selectedDic==nil) {
        _selectedDic = [[NSMutableDictionary alloc]init];
    }
    return _selectedDic;
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"进入了搜索框");
    HIDEKEYBOARD;///点search按钮隐藏按钮
}

#pragma mark 多选按钮
- (void)NavigationRightItemClick{

    YidongViewController *yidong = [[YidongViewController alloc]init];
    yidong.dirld = @"0";
    [self.navigationController pushViewController:yidong animated:YES];
}

#define 加载失败重新刷新
- (void)refreshclick:(UIButton *)sender{
    NSLog(@"刷新按钮");
}

#define 新建文件夹按钮
- (void)newfolderClick{
    NSLog(@"新建文件夹按钮");
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件名";
        textField.secureTextEntry = NO;
    }];
    
    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 读取文本框的值显示出来
        userEmail = alertDialog.textFields.firstObject;
        userEmail.delegate = self;
        NSLog(@"提示框输入框的值%@",userEmail.text);
        if (userEmail.text.length != 0) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,@"0",userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [OMGToast showWithText:@"添加成功"];
                    
                     [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];
                    
//                    [self fireshTableview];
                }else{
                    [OMGToast showWithText:object[@"msg"]];
                }
                
            } andFailed:^(NSString *object) {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"新增文件夹失败"];
        }
    }];
    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:Okaction];
    [alertDialog addAction:quxiao];
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}
#define 排序按钮
- (void)newfolderClick1{
    CGPoint point = CGPointMake(Newfolder1.center.x,Newfolder1.frame.origin.y + 100);
    view1 = [[XTPopView alloc] initWithOrigin:point Width:90 Height:40 * 2 Type:XTTypeOfUpLeft Color:[UIColor blackColor]];
    view1.dataArray = @[@"时间排序",@"名称排序",];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor whiteColor];
    view1.delegate = self;
    [view1 popView];
}

#pragma mark - 排序
- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"您点中了按时间顺序排序");
            [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];
            [view1 removeFromSuperview];
        }
            break;
        case 1:
        {
            NSLog(@"您点中了按文件名称排序");
            [self httprestsTableviewFiledirId:@"0" sort:@"2" listBy:@"0"];
            [view1 removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

#pragma mark -  分类按钮点击事件
-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    NSLog(@"tag:%ld",sender.view.tag);
    switch (sender.view.tag) {
        case 100:
        {
            NSLog(@"全部");
            [qbBtn setTitle:@"全部" forState:UIControlStateNormal];
            [self httprestsTableviewFiledirId:@"0" sort:@"1" listBy:@"0"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = NO;
            
            Newfolder1.frame = CGRectMake(75, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(130, 22.5, screen_width - 145, 27);
        }
            break;
            
        case 101:
        {
            NSLog(@"图片");
            [qbBtn setTitle:@"图片" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"20" sort:@"1" listBy:@"2"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        case 102:
        {
            NSLog(@"音频");
            [qbBtn setTitle:@"音频" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"30" sort:@"1" listBy:@"2"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        case 103:
        {
            NSLog(@"视频");
            [qbBtn setTitle:@"视频" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"40" sort:@"1" listBy:@"2"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        case 104:
        {
            
            NSLog(@"文档");
            [qbBtn setTitle:@"文档" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"10" sort:@"1" listBy:@"2"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        case 105:
        {
            NSLog(@"其它");
            [qbBtn setTitle:@"其它" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"50" sort:@"1" listBy:@"2"];
            
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        case 106:
        {
            NSLog(@"标记");
            [qbBtn setTitle:@"标记" forState:UIControlStateNormal];
            [self httprestslistFileByType:@"60" sort:@"1" listBy:@"2"];
            [UIView animateWithDuration:0.3 animations:^{
                typeView.frame = CGRectMake(0, - screen_height, screen_width, screen_height - 64);
            }];
            qbBtn.selected = YES;
            _rightItem.hidden = NO;
            Newfolder.hidden = YES;
            Newfolder1.frame = CGRectMake(15, 16.5, 37, 37);
            searchBackground.frame = CGRectMake(70, 22.5, screen_width - 90, 27);
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    NSLog(@"您点击了键盘上search按钮");
    return YES;
}

#pragma mark - 转换为JSON
- (NSData *)JSONData
{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self JSONObject] options:kNilOptions error:nil];
}

- (id)JSONObject
{
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]]) {
        return self;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    
    return self.keyValues;
}

- (NSString *)JSONString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (userEmail == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}

@end
