//
//  mobileViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "mobileViewController.h"
#import "MobleViewCell.h"
#import "dirListModel.h"
#import "mobileOneViewController.h"
#import "XTPopView.h"
#import "dirListModel.h"
@interface mobileViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,selectIndexPathDelegate>{

    UITableView *_tableView;
    UIButton * _rightbutton;
    UIImageView *Newfolder;
    UIImageView *Newfolder1;
    XTPopView *xtpopView;
     UIView *hiddenView;///没有数据界面
    UITextField *userEmail;
    UITextField *userEmail1;
}
@property(nonatomic,strong) UIButton *newfolderButton;///新建文件夹按钮
@property(nonatomic,strong) UIButton *mobileButton;///新建文件夹按钮
///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
@end

@implementation mobileViewController

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
    
    self.title = @"移动至";
    [self setupView];
    [self fireshTableview];
    [self httprestsTableviewFile:@"1"];
    NSLog(@"list：%@",self.fileid);
}

///刷新表格
- (void)fireshTableview{
    
    if (self.dirList.count == 0)
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

///请求网络根目录  －－－1＝时间排序      2=文件名排序
- (void)httprestsTableviewFile:(NSString *)sort{
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listFilePath" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,@"0",sort,@"1"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];

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

///键盘上搜索按钮的点击事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
   
//    [SVProgressHUD showWithStatus:@"搜索中..." maskType:SVProgressHUDMaskTypeGradient];
//    [[TSCCntc sharedCntc] queryWithPoint:@"getListBySearch" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&searchKey=%@&sort=%@&listBy=%@",[User shareUser].appKey,[User shareUser].authToken,textField.text,@"2",@"0"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
//        
//        if ([object [@"code"] integerValue] == 200) {
//            [SVProgressHUD dismiss];
//            
//            [self.dirList removeAllObjects];///搜索前先清除数组
//            
//            NSDictionary *Dictionary = [object objectForKey:@"data"];
//            
//            [self.dirList addObjectsFromArray:[dirListModel objectArrayWithKeyValuesArray:Dictionary [@"dirList"]]];
//            
//            [self fireshTableview];
//        }else{
//            [SVProgressHUD dismiss];
//            [OMGToast showWithText:object[@"msg"]];
//        }
//        
//    } andFailed:^(NSString *object) {
//        [SVProgressHUD dismissWithError:@"网络错误"];
//    }];
    
    return YES;
}

///没有数据显示的界面
- (void)hiddenSubview{
    hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 70.5, screen_width, screen_height - 134)];
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

- (void)setupView{
    
    
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
    UIImageView *searchBackground = [[UIImageView alloc]initWithFrame:CGRectMake(130, 22.5, screen_width - 145, 27)];
    searchBackground.layer.cornerRadius = 2;
    searchBackground.userInteractionEnabled = YES;
    searchBackground.image =[UIImage imageNamed:@"search_bq.png"];
    [view addSubview:searchBackground];
    
    UITextField  * searchtextFild = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, screen_width - 165, 30)];
    searchtextFild.backgroundColor = [UIColor clearColor];
    searchtextFild.clearsOnBeginEditing = YES;
    searchtextFild.returnKeyType =UIReturnKeySearch;
    searchtextFild.delegate = self;
    [searchBackground addSubview:searchtextFild];
    
//        UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screen_width - 120, 35)];
//        search.backgroundColor = [UIColor clearColor];
//        search.placeholder = @"搜一搜";
//        search.delegate = self;
//    //    search.searchBarStyle = UISearchBarStyleMinimal;
//        [searchBackground addSubview:search];
//    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(3, 71, screen_width - 6, 0.5)];
    hen.alpha = 0.3;
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:hen];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, screen_width, screen_height - 194) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,21.5, 0, 21.5);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.hidden = YES;
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(_tableView.bottom);
        make.width.equalTo(screen_width);
        make.height.equalTo(60);
    }];
    
    UIView *henx = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 0.5)];
    henx.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view1 addSubview:henx];
    
    
    ///新建文件夹按钮
    self.newfolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.newfolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newfolderButton setTitle:@"新建文件夹" forState:UIControlStateNormal];
    self.newfolderButton.layer.cornerRadius = 15.0;
    [self.newfolderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.newfolderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.newfolderButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
   // [self.newfolderButton setBackgroundColor:[UIColor whiteColor]];
    self.newfolderButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    self.newfolderButton.layer.borderWidth = 1.0;
    self.newfolderButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view1 addSubview:self.newfolderButton];
    [self.newfolderButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 11);
    }];
    [self.newfolderButton addTarget:self action:@selector(xinjianwenjianjiaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    /// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    ///移动按钮
    self.mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mobileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mobileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.mobileButton setBackgroundImage:[UIImage imageNamed:@"button_bg.png"] forState:UIControlStateHighlighted];
    NSString *stringname = [NSString stringWithFormat:@"移动 (%@)",_arrayCount];
    [self.mobileButton setTitle:stringname forState:UIControlStateNormal];
    self.mobileButton.layer.cornerRadius = 15.0;
   // [self.mobileButton setBackgroundColor:RGB(167 , 197, 253)];
    self.mobileButton.layer.borderColor = RGB(167 , 197, 253).CGColor;
    self.mobileButton.layer.borderWidth = 1.0;
    self.mobileButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view1 addSubview:self.mobileButton];
    [self.mobileButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.right).offset( - 30 -  screen_width / 3);
        make.top.equalTo(15);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 11);
    }];
    [self.mobileButton addTarget:self action:@selector(mobileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dirList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidflent = @"cell";
    MobleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidflent];
    if (cell == nil) {
        cell = [[MobleViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row ];
    cell.RigthImg.image = [UIImage imageNamed:@"next_n@2x.png"];
    cell.image.image = [UIImage imageNamed:@"file_n@2x.png"];
    cell.name.text = dirlmodel.dirName;
    cell.time.text = dirlmodel.dirTime;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    dirListModel *dirlmodel = [self.dirList objectAtIndex:indexPath.row ];
    
    mobileOneViewController *moble = [[mobileOneViewController alloc]init];
    moble.string = dirlmodel.dirId;
    moble.fileid = self.fileid;
    moble.labletitle = dirlmodel.dirName;
    moble.arrayCount = self.arrayCount;
    [self.navigationController pushViewController:moble animated:YES];
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
        userEmail = alertDialog.textFields.firstObject;
        userEmail.delegate = self;
        NSLog(@"提示框输入框的值%@",userEmail.text);
        if (userEmail.text.length != 0) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,@"0",userEmail.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [self fireshTableview];
                    [self httprestsTableviewFile:@"1"];
                    [OMGToast showWithText:@"新建文件夹成功"];
                    
                }else{
                    [OMGToast showWithText:object[@"msg"]];
                }
                
            } andFailed:^(NSString *object) {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
        }else{
            [OMGToast showWithText:@"新增文件夹失败！"];
            return;
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

    [[TSCCntc sharedCntc] queryWithPoint:@"moveFileOrDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirPid=%@&list=%@",[User shareUser].appKey,[User shareUser].authToken,@"0",self.fileid] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [_tableView reloadData];
            
            
            [OMGToast showWithText:@"移动文件夹成功"];
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            
        }else if([object [@"code"] integerValue] == 3023){
            
            [OMGToast showWithText:@"不能选择当前文件夹"];
            return;
            
        }
        else if([object [@"code"] integerValue] == 4032){
            
            [OMGToast showWithText:@"不能选择当前文件夹"];
            return;
            
        }
        else{
            [OMGToast showWithText:@"不能选择当前文件夹"];
            return;
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
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
        userEmail1 = alertDialog.textFields.firstObject;
        userEmail1.delegate = self;
        NSLog(@"提示框输入框的值%@",userEmail1.text);
        if (userEmail1.text.length != 0) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"addDir" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&dirId=%@&dirName=%@",[User shareUser].appKey,[User shareUser].authToken,@"0",userEmail1.text] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                
                if ([object [@"code"] integerValue] == 200) {
                    [OMGToast showWithText:@"添加成功"];
                    [self fireshTableview];
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

///如果是重选择文件夹过来的 ， 成功后返回到1  文件目录页去
- (void)NavigationBackItemClick{
    NSLog(@"1111");
    if ([self.mobileType isEqualToString:@"10"]) {
         NSLog(@"2222");
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    }else if([self.mobileType isEqualToString:@"20"]){
        
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (userEmail == textField || userEmail1 == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}

@end
