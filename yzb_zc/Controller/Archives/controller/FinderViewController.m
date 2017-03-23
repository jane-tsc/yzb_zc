//
//  FinderViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/20.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "FinderViewController.h"
#import "ArchiveViewCell.h"
#import "ZCMTBtnView.h"
#import "XTPopView.h"
#import "fileListModel.h"
#import "dirListModel.h"
#import "DetailsViewController.h"
#import "SearchViewController.h"
#import "YidongViewController.h"

@interface FinderViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,selectIndexPathDelegate,UITextFieldDelegate>{

    UIButton * _rightItem;
    UIButton * _leftItem;
    UITableView *_tableView;
    UIImageView *Newfolder;
    UIImageView *Newfolder1;
    XTPopView *view1;
    UIView *typeView;
    UIButton *qbBtn;
    
    UIImageView *searchBackground;
     UIView *hiddenView;///没有数据界面
}
///文件
@property(nonatomic,strong) NSMutableArray *fileList;
///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
@property (nonatomic, strong) UIView         * noView;
@end

@implementation FinderViewController

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
    self.title = self.labletitle;
    //多选按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(FinderNavigationRightItemClick)];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.fileList = [[NSMutableArray alloc]init];
    [self setViewTableView];
    [self setViewUp];
    [self httprestsTableviewFile:@"1"];
    [self hiddenSubview];
    
    NSLog(@"文件夹ID：%@",self.string);
    
}
///多选按钮
- (void)FinderNavigationRightItemClick{

    YidongViewController *yidong = [[YidongViewController alloc]init];
    yidong.dirld = self.string;
    [self.navigationController pushViewController:yidong animated:YES];
    
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
    
//    [self httprestsTableviewFile:@"1"];
}


///请求网络根目录  －－－1＝时间排序      2=文件名排序
- (void)httprestsTableviewFile:(NSString *)sort{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFilePath" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&sort=%@",[User shareUser].appKey,[User shareUser].authToken,self.string,sort] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            self.fileList = [fileListModel objectArrayWithKeyValuesArray:dic [@"fileList"]];
            self.dirList  = [dirListModel objectArrayWithKeyValuesArray:dic [@"dirList"]];
            
            [self fireshTableview];
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)setViewTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, screen_width, screen_height - 134) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
}

- (void)setViewUp{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    Newfolder = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16.5, 37, 37)];
    Newfolder.image = [UIImage imageNamed:@"add_nor.png"];
    [view addSubview:Newfolder];
    Newfolder.userInteractionEnabled = YES;
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
    
//    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(3, 71, screen_width - 6, 1)];
//    hen.alpha = 0.3;
//    hen.backgroundColor = [UIColor grayColor];
//    [view addSubview:hen];
}


///没有数据显示的界面
- (void)hiddenSubview{
    hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 71, screen_width, screen_height - 134)];
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
///一点击搜索框调入搜索界面
- (void)sousuoClick{
    SearchViewController *search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
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
        
        dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row ];
        
        cell.RigthImg.image = [UIImage imageNamed:@"next_n@2x.png"];
        cell.image.image = [UIImage imageNamed:@"file_n@2x.png"];
        cell.name.text = dirlmodel.dirName;
        cell.time.text = dirlmodel.dirTime;
        
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
    
        
        ///usedStatus ＝＝ 0  显示试用字段
        if ([fileListmodel.usedStatus intValue] == 0) {
            ///试用字体
            cell.lableTrial.text = @"试用";
            cell.lableTrial.backgroundColor = RGB(246, 142, 140);
        }
        else
        {
            
            
        }
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
        
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.section == 1)
    {
        
        fileListModel *model = [self.fileList objectAtIndex:indexPath.row];
        DetailsViewController *details = [[DetailsViewController alloc]init];
        details.fileid = model.certId;
        details.labletitle = model.archiveName;
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.section == 0)
    {
        
        FinderViewController *finder = [[FinderViewController alloc]init];
        dirListModel *model =[self.dirList objectAtIndex:indexPath.row];
        finder.labletitle = model.dirName;
        finder.string = model.dirId;
        [self.navigationController pushViewController:finder animated:YES];
    }

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
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,self.string,userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [OMGToast showWithText:@"添加成功"];
                    [self httprestsTableviewFile:@"1"];
                    [self fireshTableview];
                    
                }else{
                    [OMGToast showWithText:object[@"msg"]];
                }
                
            } andFailed:^(NSString *object) {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
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
    view1 = [[XTPopView alloc] initWithOrigin:point Width:110 Height:40 * 2 Type:XTTypeOfUpLeft Color:[UIColor blackColor]];
    view1.dataArray = @[@"时间顺序",@"名称排序",];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor whiteColor];
    view1.delegate = self;
    [view1 popView];
}
- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"您点中了按时间顺序排序");
            [self httprestsTableviewFile:@"1"];
            [view1 removeFromSuperview];
        }
            break;
        case 1:
        {
            NSLog(@"您点中了按文件名称排序");
            [self httprestsTableviewFile:@"2"];
            [view1 removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

@end
