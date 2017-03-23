//
//  YidongViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/7/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "YidongViewController.h"
#import "ArchiveViewCell.h"
#import "fileListModel.h"
#import "dirListModel.h"
#import "YidongViewCell.h"
#import "XTPopView.h"
#import "SearchViewController.h"
#import "mobileViewController.h"
#import "SecurityViewController.h"

@interface YidongViewController ()<UITableViewDataSource,UITableViewDelegate,selectIndexPathDelegate,WJTouchIDDelegate>{
    UITableView *_tableView;
    UIImageView *Newfolder;
    UIImageView *Newfolder1;
    UIView *view;
    XTPopView *view1;
    NSString *list;///将数组转成的json字符串
}
@property(nonatomic,strong) UIButton *newfolderButton;///新建文件夹按钮
@property(nonatomic,strong) UIButton *deleteButton;///删除按钮
///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
///文件
@property(nonatomic,strong) NSMutableArray *fileList;

@property (nonatomic, strong) NSMutableArray * selectedArr;

@property (nonatomic, strong) NSMutableArray * deleteArr;

@property (nonatomic, strong) WJTouchID *touchID;///指纹验证
@end

@implementation YidongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    设置 状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.dirList = [NSMutableArray array];
    _selectedArr    = [NSMutableArray array];
    _deleteArr = [NSMutableArray array];
    self.fileList = [NSMutableArray array];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  screen_width, screen_height + 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:view];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    UILabel *navtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, screen_width, 44)];
    navtitle.text =@"选择一个文件";
    navtitle.userInteractionEnabled = YES;
    navtitle.textColor = [UIColor blackColor];
    navtitle.font = [UIFont systemFontOfSize:NacFontsize];
    navtitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:navtitle];
    
    UIButton *quanxuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [quanxuan setTitle:@"全选" forState:UIControlStateSelected];
    [quanxuan setTitle:@"全不选" forState:UIControlStateNormal];
    quanxuan.selected = YES;
    [quanxuan setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    quanxuan.titleLabel.font = [UIFont systemFontOfSize:screen_width / 22];
    quanxuan.frame = CGRectMake(5, 30, 70, 30);
    [quanxuan addTarget:self action:@selector(NavigationquanxuanClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:quanxuan];
    
    UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [quxiao setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    quxiao.titleLabel.font = [UIFont systemFontOfSize:screen_width / 22];
    quxiao.frame = CGRectMake(screen_width - 60, 30, 50, 30);
    [quxiao addTarget:self action:@selector(NavigationquxiaoClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:quxiao];
    
    [self setwithup];
    [self httprestsTableviewFiledirId:self.dirld sort:@"1" listBy:@"0"];
    
    NSLog(@"self.dirld:%@",self.dirld);
}

///刷新把表格
- (void)refreshTableview{
    
    [_tableView reloadData];
    
    [self httprestsTableviewFiledirId:self.dirld sort:@"1" listBy:@"0"];
}
- (void)viewWillAppear:(BOOL)animated{
    ///一进入这个界面就刷新数据
    [self httprestsTableviewFiledirId:self.dirld sort:@"1" listBy:@"0"];
    ///已进入这个界面就隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    ///一离开这个界面就不隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
}

//取消按钮事件
- (void)NavigationquxiaoClick{
    [self.navigationController popViewControllerAnimated:YES];
}

///列举文件与目录  －－－1＝时间排序      2=文件名排序
- (void)httprestsTableviewFiledirId:(NSString *)dirId sort:(NSString *)sort listBy:(NSString *)listBy{
    
    NSLog(@"dirId:%@",dirId);
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFilePath" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,dirId,sort,listBy] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            //            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            ///首先先清除数组内容
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            //            [self.fileList addObjectsFromArray:[fileListModel objectArrayWithKeyValuesArray:dic [@"fileList"]]];
            //            [self.dirList addObjectsFromArray:[dirListModel objectArrayWithKeyValuesArray:dic [@"dirList"]]];
            
            [self.fileList addObjectsFromArray:dic [@"fileList"]];
            [self.dirList addObjectsFromArray:dic [@"dirList"]];
            
            NSLog(@"self.fileList:%lu---self.dirList:%lu",(unsigned long)self.fileList.count,(unsigned long)self.dirList.count);
            
            [_tableView reloadData];
            
        }else {
            
            //            [SVProgressHUD dismiss];
            
            [self.dirList removeAllObjects];
            [self.fileList removeAllObjects];
            
            [_tableView reloadData];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD dismiss];
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)setwithup{
    
    UIView *viewhen = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5, screen_width, 70)];
    viewhen.backgroundColor = [UIColor whiteColor];
    [view addSubview:viewhen];
    
    Newfolder = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16.5, 37, 37)];
    Newfolder.image = [UIImage imageNamed:@"add_nor.png"];
    [viewhen addSubview:Newfolder];
    Newfolder.userInteractionEnabled = YES;
    UITapGestureRecognizer *newtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newfolderClick)];
    [Newfolder addGestureRecognizer:newtap];
    
    Newfolder1 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 16.5, 37, 37)];
    Newfolder1.image = [UIImage imageNamed:@"add_change.png"];
    [viewhen addSubview:Newfolder1];
    Newfolder1.userInteractionEnabled = YES;
    UITapGestureRecognizer *newtap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newfolderClick1)];
    [Newfolder1 addGestureRecognizer:newtap1];
    
    
    ///search_bq.png
    UIImageView *searchBackground = [[UIImageView alloc]initWithFrame:CGRectMake(130, 22.5, screen_width - 145, 27)];
    searchBackground.layer.cornerRadius = 2;
    searchBackground.userInteractionEnabled = YES;
    searchBackground.image =[UIImage imageNamed:@"search_bq.png"];
    [viewhen addSubview:searchBackground];
    UITapGestureRecognizer *tapsousuo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sousuoClick)];
    [searchBackground addGestureRecognizer:tapsousuo];
    
    ///底部按钮视图
    UIView *foottherView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height - 64, screen_width, 64)];
    foottherView.backgroundColor = [UIColor whiteColor];
    [view addSubview:foottherView];
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [foottherView addSubview:hen];
    ///新建文件夹按钮
    self.newfolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.newfolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newfolderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.newfolderButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
    [self.newfolderButton setTitle:@"移动" forState:UIControlStateNormal];
    self.newfolderButton.layer.cornerRadius = 15.0;
    [self.newfolderButton setBackgroundColor:[UIColor whiteColor]];
    self.newfolderButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    self.newfolderButton.layer.borderWidth = 1.0;
    self.newfolderButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [foottherView addSubview:self.newfolderButton];
    [self.newfolderButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 12);
    }];
    [self.newfolderButton addTarget:self action:@selector(yidongClick:) forControlEvents:UIControlEventTouchUpInside];
    /// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    ///删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.layer.cornerRadius = 15.0;
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
    [self.deleteButton setBackgroundColor:[UIColor whiteColor]];
    self.deleteButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    self.deleteButton.layer.borderWidth = 1.0;
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [foottherView addSubview:self.deleteButton];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.right).offset( - 30 -  screen_width / 3);
        make.top.equalTo(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 12);
    }];
    [self.deleteButton addTarget:self action:@selector(shanchuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 128, screen_width, screen_height - 192) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
        YidongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
        if (cell == nil) {
            cell = [[YidongViewCell alloc]init];
        }
        
        //        dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row];
        
        NSDictionary *dic = self.dirList [indexPath.row];
        
        //        cell.RigthImg.image = [UIImage imageNamed:@"next_n@2x.png"];
        cell.image.image = [UIImage imageNamed:@"file_n@2x.png"];
        cell.dirName.text = dic [@"dirName"];
        cell.dirTime.text = dic [@"dirTime"];
        
        [cell.checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.checkBtn.tag = indexPath.row + 800;
        
        if ([_selectedArr containsObject:dic]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected  = NO;
        }
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellidflent = @"cell";
        YidongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
        if (cell == nil) {
            cell = [[YidongViewCell alloc]init];
        }
        
        //        fileListModel *fileListmodel = [self.fileList objectAtIndex:indexPath.row];
        
        NSDictionary *dic = self.fileList [indexPath.row];
        
        
        [cell.checkBtn addTarget:self action:@selector(fileListcheckClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.checkBtn.tag = indexPath.row + 1000;

        ///根据后缀名去判断显示图片类型
        if ([dic [@"fileType"] isEqualToString:@"10"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanwendang.png"];
            
        }
        else if([dic [@"fileType"] isEqualToString:@"20"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquantupian.png"];
        }
        else if ([dic [@"fileType"] isEqualToString:@"30"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanyingping.png"];
        }
        else if ([dic [@"fileType"] isEqualToString:@"40"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanshiping.png"];
        }
        else if ([dic [@"fileType"] isEqualToString:@"50"])
        {
            cell.fileimage.image = [UIImage imageNamed:@"baoquanqita.png"];
        }
        cell.name.text = dic [@"archiveName"];
        cell.time.text = dic [@"securityTime"];
        cell.version.text = dic [@"remarks"];
        if ([dic [@"storageState"] integerValue] == 1) {
            cell.save.text = @"已代管";
            ///給已代管的文件加边逛
            cell.save.layer.borderColor = RGB(135, 166, 242).CGColor;
            cell.save.layer.borderWidth = 1.0;
            cell.save.layer.cornerRadius = 2.0;
            cell.save.layer.masksToBounds = YES;
            cell.save.textColor = RGB(135, 166, 242);
        }else{
            
        }
        
        
        if ([_selectedArr containsObject:dic]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected  = NO;
        }
        
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark -复选框的点击事件
-(void)checkClick:(UIButton *)sender
{
    HIDEKEYBOARD;
    NSDictionary * dic  = self.dirList [sender.tag - 800];
    if (sender.selected == NO) {
        if ([_selectedArr containsObject:dic]) {  // 存在
            
            
        } else { // 不存在就添加
            
            [_selectedArr addObject:dic];
        }
    }
    else
    {
        if ([_selectedArr containsObject:dic]) {  // 存在就删除
            
            [_selectedArr removeObject:dic];
            
        } else {  // 不存在
            
        }
    }
    [self refreshTableview];
    
    NSLog(@"_selectedArr.count:------%lu---%@",(unsigned long)_selectedArr.count,_selectedArr);
}
#pragma mark -复选框的点击事件
-(void)fileListcheckClick:(UIButton *)sender
{
    HIDEKEYBOARD;
    NSDictionary * dic  = self.fileList [sender.tag - 1000];
    if (sender.selected == NO) {
        if ([_selectedArr containsObject:dic]) {  // 存在
            
        } else { //不存在就添加
            
            [_selectedArr addObject:dic];
        }
    }
    else
    {
        if ([_selectedArr containsObject:dic]) {  // 存在就删除
            
            [_selectedArr removeObject:dic];
            
        } else {  // 不存在
            
        }
    }
    [self refreshTableview];
}

//全选按钮事件
- (void)NavigationquanxuanClick:(UIButton *)sender{
    
    [self refreshTableview];
/*
    全选
 */
    if (sender.selected) {
        sender.selected = NO;
        
        for (int i = 0; i < self.dirList.count; i ++) {
            
            NSDictionary *dic1 = self.dirList [i];
            [_selectedArr addObject:dic1];
        }
        for (int i = 0; i < self.fileList.count; i ++) {
            
            NSDictionary *dic2 = self.fileList [i];
            [_selectedArr addObject:dic2];
        }
        NSLog(@"全选时：_selectedArr ：%@",_selectedArr);
    }
/*
   全不选
*/
    else
    {
        sender.selected = YES;
        for (int i = 0; i < self.dirList.count; i ++) {
            
            NSDictionary *dic1 = self.dirList [i];
            [_selectedArr removeObject:dic1];
        }
        for (int i = 0; i < self.fileList.count; i ++) {
            
            NSDictionary *dic2 = self.fileList [i];
            [_selectedArr removeObject:dic2];
        }
        
         NSLog(@"全不选时：_selectedArr ：%@",_selectedArr);
    }
}
///移动按钮
- (void)yidongClick:(UIButton *)sender{
    
    if (self.selectedArr.count == 0 || [self.selectedArr isKindOfClass:[NSNull class]]) {
        
        [OMGToast showWithText:@"请先选择文件"];
        
    }else{
        
        ///的到拼接的数据
        NSString *dirid;
        NSString *fileid;
        NSString *diridlistType;
        NSString *fileidlistType;
        
        for (int i = 0; i< _selectedArr.count; i ++) {
            
            if ([[[_selectedArr objectAtIndex:i]objectForKey:@"listType"] integerValue]== 1)
            {
                dirid = [[_selectedArr objectAtIndex:i] objectForKey:@"dirId"];
                diridlistType = [[_selectedArr objectAtIndex:i] objectForKey:@"listType"];
                
                NSDictionary *dic = @{@"id":dirid,@"listBy":diridlistType};
                
                [self.deleteArr addObject:dic];
            }
            else if ([[[_selectedArr objectAtIndex:i]objectForKey:@"listType"] integerValue]== 2)
            {
                fileid = [[_selectedArr objectAtIndex:i] objectForKey:@"certId"];
                fileidlistType = [[_selectedArr objectAtIndex:i] objectForKey:@"listType"];
                
                NSDictionary *dic = @{@"id":fileid,@"listBy":fileidlistType};
                
                [self.deleteArr addObject:dic];
            }
        }
        
        ///将数组转化成json
        list = [self.deleteArr JSONString];
        NSLog(@"list -----------------------------------------:%@",list);
        NSLog(@"count :%lu",(unsigned long)self.deleteArr.count);
        
        mobileViewController *mobile = [[mobileViewController alloc]init];
        mobile.fileid = list;
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.deleteArr.count];
        mobile.arrayCount = count;
        mobile.mobileType = @"10";
        [self.navigationController pushViewController:mobile animated:YES];
        
        
    }
}
///删除按钮
- (void)shanchuClick:(UIButton *)sender{
    
    NSLog(@"删除证书文件的状态：%d",[User shareUser].zhenshuDelete);
        
        if (self.selectedArr.count == 0 || [self.selectedArr isKindOfClass:[NSNull class]]) {
            
            [OMGToast showWithText:@"请先选择文件"];
            
        }else{
            
            NSString *dirid;
            NSString *fileid;
            NSString *diridlistType;
            NSString *fileidlistType;
            
            for (int i = 0; i< _selectedArr.count; i ++) {
                
                if ([[[_selectedArr objectAtIndex:i]objectForKey:@"listType"] integerValue]== 1)
                {
                    dirid = [[_selectedArr objectAtIndex:i] objectForKey:@"dirId"];
                    diridlistType = [[_selectedArr objectAtIndex:i] objectForKey:@"listType"];
                    
                    NSDictionary *dic = @{@"id":dirid,@"listBy":diridlistType};
                    
                    [self.deleteArr addObject:dic];
                }
                else if ([[[_selectedArr objectAtIndex:i]objectForKey:@"listType"] integerValue]== 2)
                {
                    fileid = [[_selectedArr objectAtIndex:i] objectForKey:@"certId"];
                    fileidlistType = [[_selectedArr objectAtIndex:i] objectForKey:@"listType"];
                    
                    NSDictionary *dic = @{@"id":fileid,@"listBy":fileidlistType};
                    
                    [self.deleteArr addObject:dic];
                }
            }
            
            ///将数组转化成json
            list = [self.deleteArr JSONString];
            NSLog(@"list -----------------------------------------:%@",list);
            
            if ([User shareUser].zhenshuDelete == 0) {
                
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"为了您的数据安全，请开启安全验证" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    SecurityViewController *secur = [[SecurityViewController alloc]init];
                    [self.navigationController pushViewController:secur animated:YES];
                    
                    NSLog(@"确定");
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
            }
            /// 这个是不启用的操作
            else if([User shareUser].zhenshuDelete  == 10)
            {
                
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"是否删除" message:@"删除后文件或文件夹将不存在" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"delFileOrDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&list=%@",[User shareUser].appKey,[User shareUser].authToken,list] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            
                            [SVProgressHUD dismissWithSuccess:@"删除成功"];
                            
                            [self refreshTableview];
                        }else{
                            
                            [OMGToast showWithText:@"删除失败！请重试"];
                            return;
                        }
                        
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD dismiss];
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];

            }
            ///这个是密码验证
            else if ([User shareUser].zhenshuDelete  == 30){
               
                ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
                pwdAlert.title = @"请输入验证密码";
                [pwdAlert show];
                pwdAlert.completeAction = ^(NSString *pwd) {
                    NSLog(@"输入的密码:%@", pwd);
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"verifySafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,pwd] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                        NSLog(@"删除证书验证密码数据:%@",object);
                        if ([object [@"code"] integerValue] == 200) {
                            
                            NSDictionary *dic = object [@"data"];
                            
                            if ([dic [@"result"] integerValue] == 1) {
                                
                                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"删除后文件或文件夹将不存" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"取消");
                                }];
                                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    [[TSCCntc sharedCntc] queryWithPoint:@"delFileOrDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&list=%@",[User shareUser].appKey,[User shareUser].authToken,list] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                                        
                                        if ([object [@"code"] integerValue] == 200) {
                                            
                                            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//                                            NSLog(@"self.file:%@--self.die:%@-self.selectarry:%@",self.fileList,self.dirList,self.selectedArr);
                                            [self refreshTableview];
                                        }else{
                                            
                                            [SVProgressHUD showErrorWithStatus:@"删除失败，请重试！"];
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
                                
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                            }

                        }else{
                            [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                };
            }
            ///这个是指纹验证
            else if ([User shareUser].zhenshuDelete == 40){
            
                WJTouchID *touchid = [[WJTouchID alloc]init];
                self.touchID = touchid;
                touchid.delegate = self;
                touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
                [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                
            }
    }

}

/**
 *  TouchID验证成功就删除证书
 *
 *  (English Comments) Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认删除证书？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[TSCCntc sharedCntc] queryWithPoint:@"delFileOrDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&list=%@",[User shareUser].appKey,[User shareUser].authToken,list] andURL:@"Cert" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                
                [self refreshTableview];

            }else{
                
                [SVProgressHUD showErrorWithStatus:@"删除失败，请重试！"];
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
    
    NSLog(@"line 37: %@",WJNotice(@"TouchID验证成功", @"TouchID验证成功"));
}
/**
 *  TouchID验证失败
 *
 *  (English Comments) Authentication Failure
 */
- (void) WJTouchIDAuthorizeFailure {
    NSLog(@"line 46: %@",WJNotice(@"TouchID验证失败", @"TouchID验证失败") );
    [SVProgressHUD showErrorWithStatus:@"TouchID验证失败" duration:2.0];
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
        UITextField *userEmail = alertDialog.textFields.firstObject;
        NSLog(@"提示框输入框的值%@",userEmail.text);
        if (userEmail.text.length != 0) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,self.dirld,userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [OMGToast showWithText:@"添加成功"];
                    [self refreshTableview];
                }else{
                    [OMGToast showWithText:object[@"msg"]];
                }
                
            } andFailed:^(NSString *object) {
                 [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
        }else{
            [OMGToast showWithText:@"新增文件夹失败！"];
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
///一点击搜索框调入搜索界面
- (void)sousuoClick{
    SearchViewController *search = [[SearchViewController alloc]init];
    search.fileList = self.fileList;
    search.dirList  = self.dirList;
    [self.navigationController pushViewController:search animated:YES];
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
@end
