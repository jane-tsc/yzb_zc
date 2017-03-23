//
//  mobileOneViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/21.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "mobileOneViewController.h"
#import "MobleViewCell.h"
#import "dirListModel.h"
#import "fileListModel.h"
#import "ArchiveViewCell.h"
#import "XTPopView.h"
@interface mobileOneViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,selectIndexPathDelegate>{
    
    UITableView *_tableView;
    UIButton * _rightbutton;
    UIImageView *Newfolder;
    UIImageView *Newfolder1;
    XTPopView *xtpopView;
}
@property(nonatomic,strong) UIButton *newfolderButton;///新建文件夹按钮
@property(nonatomic,strong) UIButton *mobileButton;///新建文件夹按钮
///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
///文件
@property(nonatomic,strong) NSMutableArray *fileList;
@end

@implementation mobileOneViewController

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
    
    self.fileList = [[NSMutableArray alloc]init];
    self.dirList = [[NSMutableArray alloc]init];
    
    self.title = self.labletitle;
    [self setupView];
    [self httprestsTableviewFile:@"1"];
}

- (void)fireshTableview{
    [_tableView reloadData];
}

///请求网络根目录  －－－1＝时间排序      2=文件名排序
- (void)httprestsTableviewFile:(NSString *)sort{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFilePath" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,self.string,sort,@"0"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            self.dirList  = [dirListModel objectArrayWithKeyValuesArray:dic [@"dirList"]];
            self.fileList = [fileListModel objectArrayWithKeyValuesArray:dic [@"fileList"]];
            
            [self fireshTableview];
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}


- (void) setupView{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 70)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];

    Newfolder1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 16.5, 37, 37)];
    Newfolder1.image = [UIImage imageNamed:@"add_change.png"];
    [view1 addSubview:Newfolder1];
    Newfolder1.userInteractionEnabled = YES;
    UITapGestureRecognizer *newtap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newfolderClick1)];
    [Newfolder1 addGestureRecognizer:newtap1];
    
    
    ///search_bq.png
    UIImageView *searchBackground = [[UIImageView alloc]initWithFrame:CGRectMake(70, 22.5, screen_width - 90, 27)];
    searchBackground.layer.cornerRadius = 2;
    searchBackground.userInteractionEnabled = YES;
    searchBackground.image =[UIImage imageNamed:@"search.png"];
    [view1 addSubview:searchBackground];
    
    UITextField  * searchtextFild = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, screen_width - 90, 30)];
    searchtextFild.backgroundColor = [UIColor clearColor];
    searchtextFild.clearsOnBeginEditing = YES;
    searchtextFild.returnKeyType =UIReturnKeySearch;
    searchtextFild.delegate = self;
    [searchBackground addSubview:searchtextFild];
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(3, 70.5, screen_width - 6, 1)];
    hen.alpha = 0.3;
    hen.backgroundColor = [UIColor grayColor];
    [view1 addSubview:hen];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70.5, screen_width, screen_height - 194) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(_tableView.bottom).offset(1);
        make.width.equalTo(screen_width);
        make.height.equalTo(60);
    }];
    
    ///新建文件夹按钮
    self.newfolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.newfolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newfolderButton setTitle:@"新建文件夹" forState:UIControlStateNormal];
    self.newfolderButton.layer.cornerRadius = 15.0;
    //[self.newfolderButton setBackgroundColor:[UIColor whiteColor]];
    self.newfolderButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    [self.newfolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newfolderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.newfolderButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
    self.newfolderButton.layer.borderWidth = 1.0;
    self.newfolderButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [self.view addSubview:self.newfolderButton];
    [self.newfolderButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(view.top).offset(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 11);
    }];
    [self.newfolderButton addTarget:self action:@selector(xinjianwenjianjiaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    /// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    ///移动按钮
    self.mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mobileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.mobileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mobileButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
    NSString *stringname = [NSString stringWithFormat:@"移动 (%@)",_arrayCount];
    [self.mobileButton setTitle:stringname forState:UIControlStateNormal];
    self.mobileButton.layer.cornerRadius = 15.0;
   // [self.mobileButton setBackgroundColor:RGB(167 , 197, 253)];
    self.mobileButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    self.mobileButton.layer.borderWidth = 1.0;
    self.mobileButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [self.view addSubview:self.mobileButton];
    [self.mobileButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.right).offset( - 30 -  screen_width / 3);
        make.top.equalTo(view.top).offset(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 11);
    }];
    [self.mobileButton addTarget:self action:@selector(mobileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (indexPath.section == 0) {
        dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row ];
        
        mobileOneViewController *moble = [[mobileOneViewController alloc]init];
        moble.string = dirlmodel.dirId;
        moble.labletitle = dirlmodel.dirName;
        moble.fileid = self.fileid;
         moble.arrayCount = self.arrayCount;
        [self.navigationController pushViewController:moble animated:YES];
    }
}

#pragma mark - 新建文件夹
- (void)xinjianwenjianjiaButtonClick:(UIButton *)sender{
    
    NSLog(@"新建文件夹");
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入文件名";
        textField.secureTextEntry = NO;
    }];
    
    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 读取文本框的值显示出来
        UITextField *userEmail = alertDialog.textFields.firstObject;
        userEmail.delegate = self;
        NSLog(@"提示框输入框的值%@",userEmail.text);
        if (userEmail.text.length != 0) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,self.string,userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [_tableView reloadData];
                    [self httprestsTableviewFile:@"1"];
                    
                    
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

#pragma mark - 移动
- (void)mobileButtonClick:(UIButton *)sender{
    
    NSLog(@"移动");
    
    [[TSCCntc sharedCntc] queryWithPoint:@"moveFileOrDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirPid=%@&list=%@",[User shareUser].appKey,[User shareUser].authToken,self.string,self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
             [SVProgressHUD dismissWithSuccess:@"移动文件成功" afterDelay:3.0];
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
            [_tableView reloadData];
            [self httprestsTableviewFile:@"1"];
           
            ///返回到指定界面
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [SVProgressHUD dismissWithError:object [@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}
//#define 取消按钮
//- (void)NavigationquxiaoClick{
//    NSLog(@"取消按钮");
//}

#define 排序按钮
- (void)newfolderClick1{
    CGPoint point = CGPointMake(Newfolder1.center.x,Newfolder1.frame.origin.y + 100);
    xtpopView = [[XTPopView alloc] initWithOrigin:point Width:90 Height:40 * 2 Type:XTTypeOfUpLeft Color:[UIColor blackColor]];
    xtpopView.dataArray = @[@"时间排序",@"名称排序",];
    xtpopView.fontSize = 13;
    xtpopView.row_height = 40;
    xtpopView.titleTextColor = [UIColor whiteColor];
    xtpopView.delegate = self;
    [xtpopView popView];
}
- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"您点中了按时间顺序排序");
            [self httprestsTableviewFile:@"1"];
            [xtpopView removeFromSuperview];
        }
            break;
        case 1:
        {
            NSLog(@"您点中了按文件名称排序");
            [self httprestsTableviewFile:@"2"];
            [xtpopView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 20) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else {
            return YES;
        }
    }
}

@end

