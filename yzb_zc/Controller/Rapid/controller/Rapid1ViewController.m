//
//  RapidViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "Rapid1ViewController.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extensions.h"
#import "rapidViewCell.h"
#import "HYActivityView.h"
#import "PayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MyMD5.h"
#import "PayWCViewController.h"
#import "ZCMTBtnView.h"
#import "ZCpopView.h"
#import "ZZPhotoKit.h"
#import "ImmViewController.h"
#import "BaycapacityViewController.h"
#import "OpenpreservationViewController.h"
#import "WsqMD5Util.h"

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface Rapid1ViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    
    UILabel *lableNum;///
    UITableView *_tableView;
    
    //图片2进制路径
    NSString* filePath;
    UIImage *headingImage;
    NSString *imageName;
    UIImageView *imae;
    UILabel *lable;
    UIView *wirthView;
    UIView *blackView;
    
    UIView *wirthView1;
    UIView *blackView1;
    UIView *OneView;
    
    NSData *fileData;
    
    int integerdex;
    NSDictionary *moviesDic;
    
    NSString *imagespath;
    
}
@property (nonatomic, strong) NSMutableArray * selectedArr;

@property(nonatomic, strong) UIButton *PaymentButton;///立即代管
@property(nonatomic, strong) UILabel * name;
@property(nonatomic, strong) UILabel * idcarNumber;
@property(nonatomic, strong) UILabel * price;
@property (nonatomic, strong) HYActivityView *activityView;

@property(nonatomic, strong) NSMutableArray *photoarray;

@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic,strong) UIButton *queren;///确认

/// 外层滚动视图
@property (nonatomic, strong) UIScrollView * allScrollView;

@end

@implementation Rapid1ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self httprestWithup];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //修改为导航栏一下开始显示
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    ///infor_n_r.png
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"notice@2x.png" highLightImage:@"notice@2x.png" target:self action:@selector(onClickRigthItem)];
    
//    self.title = self.baoquanType;
    self.title = @"快速保全";
    
    ///外层滚动视图
    self.allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    self.allScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.allScrollView];
    self.allScrollView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplick)];
    [self.view addGestureRecognizer:tap];
    
    self.imageArray = [NSMutableArray array];
    _selectedArr    = [NSMutableArray array];
    self.photoarray = [NSMutableArray array];
    //////===============OSS 临时授权
    [self OSSshouquanappkey:[User shareUser].appKey OSSwithauthtoken:[User shareUser].authToken];
   
    
    [self setupView];
    [self refreshTableview];
    
    ///一进入这个界面就调用这个方法，触发popview视图
    [self getUpwithpopView];
    ///出现POP视图
    [self showclassPopView];
}
- (void)refreshTableview{
    [self setupView];
    NSLog(@"____________________%li",(unsigned long)self.imageArray.count);
    [_tableView reloadData];
    [self.allScrollView reloadInputViews];
}
- (void)taplick{
    [self classPopView];
    HIDEKEYBOARD;
}
- (void)setupView{
    NSInteger num = _imageArray.count;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, screen_width, 45 + (_imageArray.count == 0 ? 0 : 90 * num))];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.allScrollView addSubview:_tableView];
   _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    OneView = [[UIView alloc]init];
    OneView.backgroundColor = [UIColor whiteColor];
    [self.allScrollView addSubview:OneView];
    
    [OneView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(_tableView.bottom);
        make.width.equalTo(screen_width);
        make.height.equalTo(_imageArray.count >= 6 ? 270 : 320);
    }];
    
    UIView *henxian = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screen_width, 1)];
    henxian.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [OneView addSubview:henxian];
    if (_imageArray.count < 6) {
        ///addwj_bq_n@2x.png
        imae = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 70, 70)];
        imae.image = [UIImage imageNamed:@"组-16@2x.png"];
        imae.userInteractionEnabled = YES;
        [OneView addSubview:imae];
        UITapGestureRecognizer *imtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFlderClick)];
        [imae addGestureRecognizer:imtap];
    }
    if ([self.imageArray count] >= 6) {
        [imae setHidden:YES];
    } else {
        [imae setHidden:NO];
    }
    
    UILabel *baoquanMessage = [[UILabel alloc]init];
    baoquanMessage.textAlignment = NSTextAlignmentLeft;
    baoquanMessage.text = @"保全信息";
    baoquanMessage.textColor = [UIColor blackColor];
    baoquanMessage.font = [UIFont boldSystemFontOfSize:screen_width / 22];
    [OneView addSubview:baoquanMessage];
    [baoquanMessage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        if (_imageArray.count >= 6) {
            make.top.equalTo(OneView.top).offset(10);
        } else {
            make.top.equalTo(imae.bottom).offset(15);
        }
        make.width.equalTo(screen_width -20);
        make.height.equalTo(15);
    }];
    
    UIView *hen = [[UIView alloc]init];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [OneView addSubview:hen];
    [hen makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(baoquanMessage.bottom).offset(20);
        make.width.equalTo(screen_width - 40);
        make.height.equalTo(1);
    }];
    
    _name = [[UILabel alloc]init];
    _name.text = [User shareUser].userName;
    _name.textColor= [UIColor darkGrayColor];
    _name.textAlignment = NSTextAlignmentLeft;
    _name.font =[UIFont systemFontOfSize:screen_width / 24];
    [OneView addSubview:_name];
    [_name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(hen.bottom).offset(20);
        make.width.equalTo(100);
        make.height.equalTo(15);
    }];
    
    _idcarNumber = [[UILabel alloc]init];
    _idcarNumber.text = [User shareUser].userSn;
    _idcarNumber.textColor= [UIColor darkGrayColor];
    _idcarNumber.textAlignment = NSTextAlignmentRight;
    _idcarNumber.font =[UIFont systemFontOfSize:screen_width / 24];
    [OneView addSubview:_idcarNumber];
    [_idcarNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - screen_width / 2 - 20);
        make.top.equalTo(hen.bottom).offset(20);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(15);
    }];
    
    UIView *hen1 = [[UIView alloc]init];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [OneView addSubview:hen1];
    [hen1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(_idcarNumber.bottom).offset(20);
        make.width.equalTo(screen_width - 40);
        make.height.equalTo(1);
    }];
    
    ///确认支付按钮
    self.PaymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.PaymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.PaymentButton setTitle:@"确认" forState:UIControlStateNormal];
    self.PaymentButton.layer.cornerRadius = 15.0;
    [self.PaymentButton setBackgroundColor:RGB(251, 140, 142)];
    self.PaymentButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.PaymentButton.layer.shadowOpacity = 0.5;
    self.PaymentButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.PaymentButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [OneView addSubview:self.PaymentButton];
    [self.PaymentButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(hen1.bottom).offset(30);
        make.width.equalTo(screen_width / 2.5);
        make.height.equalTo(screen_width / 11);
    }];
    [self.PaymentButton addTarget:self action:@selector(PaymentButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ///计算出高度
    self.allScrollView.contentSize = CGSizeMake(screen_width , 400 + (45 + 90 * num));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *OneView1 = [[UIView alloc]init];
    OneView1.backgroundColor = [UIColor whiteColor];
    
    lableNum = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width - 40, 44.5)];
    lableNum.text = [NSString stringWithFormat:@"保全文件 (%lu/6)",(unsigned long)[self.imageArray count]];
    lableNum.textColor = [UIColor blackColor];
    lableNum.font = [UIFont boldSystemFontOfSize:screen_width / 24];
    [OneView1 addSubview:lableNum];
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(20, 45, screen_width, 0.5)];
    hen.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [OneView1 addSubview:hen];
    return OneView1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ///根据数组的图片来设置个数
    return self.imageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"rapidViewCell";
    rapidViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[rapidViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfriller];
    }
    
    NSDictionary * dic = self.imageArray [indexPath.row];
    NSLog(@"dic --------++++++++:%@",dic);
    
    cell.zhengshuName.text = [dic objectForKey:@"textName"];
    cell.zhengshuName.delegate = self;
    cell.zhengshuName.tag = indexPath.row + 10000;
    
    cell.heading.image = [dic objectForKey:@"image"];
//    cell.imgType.image = [UIImage imageNamed:@"save_pic_2_n.png"];
    NSString *str = [dic objectForKey:@"filePath"];
    cell.title.text = str;
    double zhao = [[dic objectForKey:@"zhao"] floatValue];

    cell.megaNum.text = [NSString stringWithFormat:@"(%.2lfM)",zhao];
    [cell.checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkBtn.tag = indexPath.row + 500;
    [cell.forkBtn addTarget:self action:@selector(forkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.forkBtn.tag = indexPath.row + 100;
    
     ///如果是试用的话就显示价格 usedStatus = 0    不然就不显示价格
    if ([[User shareUser].usedStatus integerValue] == 0) {
        
        if ([_selectedArr containsObject:dic]) {
            cell.isSelected = YES;
        } else {
            cell.isSelected  = NO;
        }
    }
    ///正式
    else if ([[User shareUser].usedStatus integerValue] == 1)
    {
            if ([_selectedArr containsObject:dic]) {
                cell.isSelected = YES;
            } else {
                cell.isSelected = NO;
            }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

//当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
//这对于想要加入撤销选项的应用程序特别有用
//可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
//要防止文字被改变可以返回NO
//这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中



- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger index                   =   textField.tag - 10000;
    NSDictionary * dic                = _imageArray [index];
    
    NSMutableDictionary * dictionary  = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:textField.text forKey:@"textName"];
    _imageArray [index]               = dictionary;
    if ([_selectedArr containsObject:dic]) {
        _selectedArr [[_selectedArr indexOfObject:dic]] = dictionary;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    HIDEKEYBOARD;///输入完后隐藏键盘
    
    NSInteger index                   =   textField.tag - 10000;
    NSDictionary * dic                = _imageArray [index];
    
    NSMutableDictionary * dictionary  = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:textField.text forKey:@"textName"];
    _imageArray [index]               = dictionary;
    if ([_selectedArr containsObject:dic]) {
        _selectedArr [[_selectedArr indexOfObject:dic]] = dictionary;
    }
    
    [OneView removeFromSuperview];
    [_tableView removeFromSuperview];
    [self refreshTableview];
}


#pragma mark -复选框的点击事件
- (void)checkClick:(UIButton *)sender
{
    
     HIDEKEYBOARD;
    
    ///如果是试用状态时 就不能勾选文件代管
    if ([[User shareUser].usedStatus integerValue] == 0) {
        
        [OMGToast showWithText:@"试用不支持"];
        return;
    }
    else if([[User shareUser].usedStatus integerValue] == 1)
    {
        
        NSDictionary * dic  = self.imageArray [sender.tag - 500];
        if (sender.selected == NO) {
            if ([_selectedArr containsObject:dic]) {  // 存在
                
            } else { // 不存在
                [_selectedArr addObject:dic];
            }
        }
        else
        {
            if ([_selectedArr containsObject:dic]) {  // 存在
                [_selectedArr removeObject:dic];
            } else {  // 不存在
                
            }
        }
        [OneView removeFromSuperview];
        [_tableView removeFromSuperview];
        [self refreshTableview];
        
    }
}

#pragma mark - 删除文件
- (void)forkBtnClick:(UIButton *)sender{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSDictionary * dic  = self.imageArray [sender.tag - 100];
    
    if ([_selectedArr containsObject:dic]) {
        [_selectedArr removeObject:dic];
        [OneView removeFromSuperview];
        [_tableView removeFromSuperview];
    }
    
    [self.imageArray removeObject:dic];
    [OneView removeFromSuperview];
    [_tableView removeFromSuperview];
    
//    [self performSelector:@selector(refreshTableview) withObject:nil afterDelay:.5];
     [self refreshTableview];
}

#pragma mark - 添加文件
- (void)addFlderClick{
    HIDEKEYBOARD;
    ///如果点击了一次就不能点击
    imae.userInteractionEnabled = NO;
    if ([[User shareUser].usedStatus integerValue] == 0) {
        ///点击这个按钮弹出POP视图
        [self showclassPopView];
        
    }
    else if ([[User shareUser].usedStatus integerValue] == 1)
    {
    ///剩余次数self.Dictionary [@"securityRestNum"]
    NSString *SecurityRestNum = [User shareUser].securityRestNum;
    NSInteger shengNum = [SecurityRestNum intValue];
    ///选了的数量
    NSInteger arrayNum = self.imageArray.count;

    NSInteger num = shengNum - arrayNum;
    
    if (num == 0) {
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"次数不足，请前往开通" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            OpenpreservationViewController *bayca = [[OpenpreservationViewController alloc]init];
            bayca.rapType = @"700";
            [self.navigationController pushViewController:bayca animated:YES];
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }else{
        ///点击这个按钮弹出POP视图
        [self showclassPopView];
    }
}
    NSLog(@"添加文件");
}
#pragma mark - 确认支付按钮
- (void)PaymentButtonButtonClick:(UIButton *)sender{
    
    HIDEKEYBOARD;
    
    
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.imageArray.count == 0)
    {
        [OMGToast showWithText:@"请选择保全文件！"];
        
    }
    else
    {
        ///没有文件代管
        if (self.selectedArr.count == 0) {
            NSMutableArray *httpArray = [NSMutableArray array];
            for (NSDictionary * dic in _imageArray) {
                
                ///保全档案名
                NSString *archiveName = [dic objectForKey:@"textName"];
                ///文件哈希值
                NSString *fileHash = [dic objectForKey:@"md5"];
                ///文件原名
                NSString *fileName = [dic objectForKey:@"filePath"];
                ///文件字节大小
                NSString *fileSize = [dic objectForKey:@"buffered"];
                ///文件后缀
                NSString *fileExt = [fileName pathExtension];
                
                ///保存到字典
                NSDictionary *dic = @{@"archiveName":archiveName,@"fileHash":fileHash,@"fileName":fileName,@"fileSize":fileSize,@"fileExt":fileExt,@"fileStorage":@NO};
                ///保存到数组
                [httpArray addObject:dic];
            }
            
          
        
         ///判断备注名是否有没有输入的
            BOOL isHave = NO;
            for (NSDictionary * dic in _imageArray) {
                if ([dic [@"textName"] length] == 0) {
                    isHave             = YES;
                }
            }
            if (isHave == YES) {
                [OMGToast showWithText:@"请输入保全证书名称"];
                return;
            }
            
            ///数组转json
            NSString *jsonarray = [httpArray JSONString];
            
            NSLog(@"sss----%@", jsonarray);
            
            [SVProgressHUD showWithStatus:@"保全中，请稍等" maskType:SVProgressHUDMaskTypeGradient];
            
            [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&data=%@",[User shareUser].appKey,[User shareUser].authToken,jsonarray] andURL:@"Security" andSuccessCompletioned:^(id object) {
                
                NSLog(@"obj:%@",object);
                
                if ([object [@"code"] integerValue] == 200) {
                    [SVProgressHUD dismiss];
                    
                    ImmViewController *paywc = [[ImmViewController alloc]init];
                    paywc.Dictionary = object [@"data"];
                    paywc.payType = @"1";
                    paywc.num = self.imageArray.count;
                    paywc.imageArray = self.imageArray;
                    [self.navigationController pushViewController:paywc animated:YES];
                    
                }else{
                    [SVProgressHUD dismiss];
                    [OMGToast showWithText:object [@"msg"]];
                    return;
                    
                }
                
            } andFailed:^(NSString *object) {
                 [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
        }
        
        ///勾选了文件代管
        else
        {
            NSLog(@"勾选了文件代管");
            
            BOOL isHave = NO;
            for (NSDictionary * dic in _selectedArr) {
                if ([dic [@"textName"] length] == 0) {
                    isHave             = YES;
                }
            }
            if (isHave == YES) {
                [OMGToast showWithText:@"请输入保全证书名称"];
                return;
            }
            
            NSMutableArray *httpArray = [NSMutableArray array];
            
            for (int i = 0; i<self.selectedArr.count; i++)
            {
                
                ///保全档案名
                NSString *archiveName = [[self.selectedArr objectAtIndex:i] objectForKey:@"textName"];
                ///文件哈希值
                NSString *fileHash = [[self.selectedArr objectAtIndex:i] objectForKey:@"md5"];
                ///文件原名
                NSString *fileName = [[self.selectedArr objectAtIndex:i] objectForKey:@"filePath"];
                ///文件字节大小
                NSString *fileSize = [[self.selectedArr objectAtIndex:i] objectForKey:@"buffered"];
                ///文件后缀
                NSString *fileExt = [fileName pathExtension];
                ///文件地址
                NSString *filePathlujin = [[self.selectedArr objectAtIndex:i] objectForKey:@"filePathlujin"];
                
                
                NSDictionary *dic = @{@"archiveName":archiveName,@"fileHash":fileHash,@"fileName":fileName,@"fileSize":fileSize,@"fileExt":fileExt,@"fileStorage":@YES,@"path":filePathlujin};
                
                NSLog(@"dic:-----------------------////////____________:%@",dic);
                
                [httpArray addObject:dic];
            }
            
            NSString *jsonarray = [httpArray JSONString];
            
            ///首先要判断是否购买了空间
            if ([[User shareUser].sizeUsed intValue] == 0)
            {
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"请购买存储空间服务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                    bayca.rapType = @"700";
                    [self.navigationController pushViewController:bayca animated:YES];
                    
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
                
            }
            ///购买了空间
            else{
            
                [SVProgressHUD showWithStatus:@"正在调取保全，请稍等" maskType:SVProgressHUDMaskTypeGradient];
                
                [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&data=%@",[User shareUser].appKey,[User shareUser].authToken,jsonarray] andURL:@"Security" andSuccessCompletioned:^(id object) {
                    
                    NSLog(@"object :%@",object);
                    
                    if ([object [@"code"] integerValue] == 200) {
                        
                        [SVProgressHUD dismiss];

                        PayWCViewController *pay = [[PayWCViewController alloc]init];
                        pay.Dictionary = object [@"data"];
                        pay.imageArray = self.imageArray;
                        [self.navigationController pushViewController:pay animated:YES];
                        
                        
                    }///保全次数不足时，提醒他前往开通次数
                    else if ([object [@"code"] intValue] == 4013){
                        [SVProgressHUD dismiss];
                        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            OpenpreservationViewController *bayca = [[OpenpreservationViewController alloc]init];
                            bayca.rapType = @"700";
                            [self.navigationController pushViewController:bayca animated:YES];
                            
                        }];
                        // 添加操作（顺序就是呈现的上下顺序）
                        [alertDialog addAction:quxiao];
                        [alertDialog addAction:Okaction];
                        // 呈现警告视图
                        [self presentViewController:alertDialog animated:YES completion:nil];
                        
                    }///保全空间不足，提醒他前往开通空间
                    else if ([object [@"code"] intValue] == 4014){
                        [SVProgressHUD dismiss];
                        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                            bayca.rapType = @"700";
                            [self.navigationController pushViewController:bayca animated:YES];
                            
                        }];
                        // 添加操作（顺序就是呈现的上下顺序）
                        [alertDialog addAction:quxiao];
                        [alertDialog addAction:Okaction];
                        // 呈现警告视图
                        [self presentViewController:alertDialog animated:YES completion:nil];
                        
                    }
                    ///单个文件不能超过100M
                    else if ([object [@"code"] intValue] == 4032){
                        [SVProgressHUD dismiss];
                        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                     
                        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        // 添加操作（顺序就是呈现的上下顺序）
                        [alertDialog addAction:Okaction];
                        // 呈现警告视图
                        [self presentViewController:alertDialog animated:YES completion:nil];
                        
                    }

                    else{
                        [SVProgressHUD dismiss];
                        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        // 添加操作（顺序就是呈现的上下顺序）
                        //                    [alertDialog addAction:quxiao];
                        [alertDialog addAction:Okaction];
                        // 呈现警告视图
                        [self presentViewController:alertDialog animated:YES completion:nil];
                    }
                    
                } andFailed:^(NSString *object) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
            
            }
        }
    }
}


///字典转数组
- (NSString* ) dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#define kMainWindow [UIApplication sharedApplication].windows.lastObject
///跳转到消息中心
- (void)onClickRigthItem
{
    
    
    ///点击之后不能点击
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
//    [kMainWindow addSubview:self.view];

    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    blackView.userInteractionEnabled = YES;
    [self.view addSubview:blackView];
    
    wirthView = [[UIView alloc]init];
    wirthView.backgroundColor = [UIColor whiteColor];
    wirthView.layer.cornerRadius = 10;
    wirthView.layer.masksToBounds = YES;
    [blackView addSubview:wirthView];
    [wirthView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(50);
        make.top.equalTo(self.view.top).offset(30);
        make.width.equalTo(screen_width - 100);
        make.height.equalTo(screen_height - 200);
    }];
    
    UIWebView *webView = [UIWebView new];
    webView.backgroundColor = [UIColor brownColor];
    webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [blackView addSubview:webView];
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wirthView.left).offset(20);
        make.top.equalTo(wirthView.top).offset(30);
        make.width.equalTo(screen_width - 140);
        make.height.equalTo(screen_height - 310);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@View/securityReadMe",HttpUrl]]];
    [webView loadRequest:request];
    ///确定按钮
    self.queren = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queren setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.queren setTitle:@"确认" forState:UIControlStateNormal];
    self.queren.layer.cornerRadius = 15.5;
    [self.queren setBackgroundColor:RGB(251, 140, 142)];
    self.queren.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.queren.layer.shadowOpacity = 0.5;
    self.queren.layer.shadowOffset = CGSizeMake(1, 6);
    self.queren.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [wirthView addSubview:self.queren];
    [self.queren makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 4 - 15);
        make.top.equalTo(wirthView.bottom).offset(-50);
        make.width.equalTo(screen_width / 3);
        make.height.equalTo(screen_width / 11);
    }];
    [self.queren addTarget:self action:@selector(querenClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"电子保全");
}
#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载webview");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败");
}
- (void)querenClick:(UIButton *)sender{
    ///点击确认之后能点击
     self.navigationController.navigationBar.userInteractionEnabled = YES;
    [blackView removeFromSuperview];
    [wirthView removeFromSuperview];
}
///关闭POPview
- (void)classPopView{
    ///关闭了POPview就可以点击了，
    imae.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        wirthView1.frame = CGRectMake(0, screen_height + 90, screen_width, 64);
        blackView1.frame = CGRectMake(0, screen_height + screen_height + 64, screen_width, screen_height);
    }];
}
///显示POPview
- (void)showclassPopView{
    [UIView animateWithDuration:0.5 animations:^{
        wirthView1.frame = CGRectMake(0, screen_height - 64, screen_width, 128);
        blackView1.frame = CGRectMake(0, - 64, screen_width, screen_height + 64);
    }];
}
///点击黑色区域隐藏popview
- (void)balck1Click{
    [self classPopView];
}

#define kMainWindow [UIApplication sharedApplication].windows.lastObject
///弹出POP视图
- (void)getUpwithpopView{
    blackView1 = [[UIView alloc]init];
    blackView1.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    blackView1.userInteractionEnabled = YES;
    [kMainWindow addSubview:blackView1];
    
    UITapGestureRecognizer *tap111= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balck1Click)];
    [blackView1 addGestureRecognizer:tap111];
    wirthView1 = [[UIView alloc]init];
    wirthView1.backgroundColor = [UIColor whiteColor];
    [blackView1 addSubview:wirthView1];
    for (int i = 0; i < 3; i++) {
            NSMutableArray *images1 = [NSMutableArray arrayWithObjects:@"zhaoxiang3.png",@"tupian3.png",@"yinping3", nil];
            NSMutableArray *titles1 = [NSMutableArray arrayWithObjects:@"拍照",@"图片",@"视频", nil];
            ZCpopView *btnView = [[ZCpopView alloc] initWithFrame:CGRectMake(i * screen_width / 3, screen_height - 64, screen_width / 3, 128) title:titles1 [i] imageStr:images1 [i]];
            btnView.tag = 100 + i;
            [blackView1 addSubview:btnView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popView:)];
            [btnView addGestureRecognizer:tap];
    }
}

#pragma mark -  分类按钮点击事件
-(void)popView:(UITapGestureRecognizer *)sender{
    NSLog(@"tag:%ld",sender.view.tag);
    switch (sender.view.tag) {
        case 100:
        {
            if (self.imageArray.count == 6) {
                
                [OMGToast showWithText:@"最多选6个！"];
                return;
            }else{
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                 [self presentViewController:imagePicker animated:YES completion:nil];
                
                integerdex = 0;
            }
            [self classPopView];
        }
            break;
            
        case 101:
        {
            if (self.imageArray.count == 6) {
                
                [OMGToast showWithText:@"最多选6个！"];
                return;
            }else{
                
                //                ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
                //                photoController.selectPhotoOfMax = 6;
                //
                //                [photoController showIn:self result:^(id responseObject){
                //
                //                    NSArray *array = (NSArray *)responseObject;
                //
                //                    [self.photoarray addObjectsFromArray:array];
                //                    NSLog(@"相册图片：-------- :%@",array);
                //
                //                    [self refreshTableview];
                //
                //                }];
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                integerdex = 1;
                
                NSLog(@"点击图片");
            }
            
            [self classPopView];
        }
            break;
        case 102:
        {
            
            if (self.imageArray.count == 6) {
                
                [OMGToast showWithText:@"最多选6个！"];
                return;
            }else{
               UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
               imagePicker.delegate = self;
//               imagePicker.allowsEditing = YES;
               imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
               imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
               [self presentViewController:imagePicker animated:YES completion:nil];
                
                integerdex = 2;

            }
            [self classPopView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate  // 选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [SVProgressHUD showWithStatus:@"选取中" maskType:SVProgressHUDMaskTypeGradient];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        NSLog(@"--选取的是图片-----------");
        if (integerdex == 0)
        {
            NSLog(@"拍照返回的图片:－－－－－－－－－－－－－－－－－－－－－－－%@",info);
            NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
            ///得到路径和图片
            if ([type isEqualToString:@"public.image"]) {

                UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                NSData *dataImage;
                if (UIImagePNGRepresentation(image) == nil)
                {
                    dataImage = UIImageJPEGRepresentation(image, 0.5f);
                }
                else
                {
                    dataImage = UIImagePNGRepresentation(image);
                }
                ///根据当前时间的到图片名称
                NSString * fileName    = [self getFileName];
                
                //这里将图片放在沙盒的documents文件夹中
                NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                //文件管理器
                NSFileManager *fileManager = [NSFileManager defaultManager];
                //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]] contents:dataImage attributes:nil];
                //得到选择后沙盒中图片的完整路径
                NSString *filePaths = [[NSString alloc]initWithFormat:@"%@/%@.jpg",DocumentsPath,fileName];
                
                [dataImage writeToFile:filePaths atomically:YES];
                
                NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePaths];
                NSLog(@"array:－－%@",array);
                
                NSArray *documentsPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *document = [documentsPathArr lastObject];
                NSLog(@"document：－－%@", document);
            
                ///把图片保存到相册中
                ALAssetsLibrary *librarydata = [[ALAssetsLibrary alloc]init];
                [librarydata writeImageDataToSavedPhotosAlbum:dataImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    NSLog(@"assetURL:%@",assetURL);
                    ///
                    NSURL *urlname = assetURL;
                    NSLog(@"－－ 拍照urlname:%@",urlname);
                    __block  NSString * imagePath;
                    __block NSUInteger buffered;
                    __block  NSString *buff;
                    __block NSString *s;
                    __block double size;
                    __block NSData *data;
                    ///md5 加密
                   __block NSString *md5image;
                    // 如何判断已经转化了,通过是否存在文件路径
                    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                    if (urlname) {
                        // 主要方法
                        [assetLibrary assetForURL:urlname resultBlock:^(ALAsset *asset) {
                            ALAssetRepresentation *rep = [asset defaultRepresentation];
                            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                            buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                            NSLog(@"－－ 拍照buffered------------:%lu",(unsigned long)buffered);
                            data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                            imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:fileName];
                            [data writeToFile:imagePath atomically:YES];
                            
                            md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                            NSLog(@"md5image:%@",md5image);
                            
                            s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                            
                            float floatString = [s floatValue];
                            
                            size = floatString / (1024 * 1024);
                            
                            NSLog(@"－－ 拍照size:%.2lf",size);
                            
                            buff = [NSString stringWithFormat:@"%.2lf",size];
                            
                            NSLog(@"－－ 拍照图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                            
                            
                            [[TSCCntc sharedCntc] queryWithPoint:@"getPriceBySize" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&bytes=%lu",[User shareUser].appKey,[User shareUser].authToken,(unsigned long)data.length] andURL:@"Security" andSuccessCompletioned:^(id object) {
                                
                                if ([object [@"code"] integerValue] == 200) {
                                    [SVProgressHUD dismiss];
                                    
                                    NSDictionary *Dictionary = [object objectForKey:@"data"];
                                    
                                    NSLog(@"Dictionary-----------:%@",Dictionary);
                                    
                                    NSString *price = [Dictionary objectForKey:@"amount"];
                                    
                                    //image  图片
                                    //filePath   图片路径
                                    //zhao    显示在cell上的M
                                    //price   算出来的价格
                                    //restnumber    没算出来的多少k
                                    //
                                    
                                    NSLog(@"image:%@-----filePath:%@-----M值: ---%f－－－price：%@----md5image:%@----textName:%@----filePathlujin:%@",image,fileName,size,price,md5image,@"",imagePath);
                                    
                                    NSDictionary *dic = @{@"image":image,@"filePath":fileName,@"zhao":buff,@"price":price,@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s};
                                    
                                    [self.imageArray addObject:dic];
                                    
 ///================================清除沙盒路径============================
                                    [AllObject clearCacheWithFilePath:imagePath];
                                    
                                    [_tableView removeFromSuperview];
                                    [OneView removeFromSuperview];
                                    
                                    [self refreshTableview];
                                    
                                }else{
                                    [SVProgressHUD dismiss];
                                    [OMGToast showWithText:object[@"msg"]];
                                }
                                
                            } andFailed:^(NSString *object) {
                                [SVProgressHUD showErrorWithStatus:@"网络错误"];
                            }];
                            
                        } failureBlock:nil];
                    }
                    
                    if (error) {
                         NSLog(@"保存相册失败！");
                    }else{
                        
                         NSLog(@"保存相册成功！");
                    }
                }];

            };
        }
        else if (integerdex == 1)
        {
            NSLog(@"相册返回的图片:－－－－－－－－－－－－－－－－－－－－－－－%@",info);
            NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
            ///得到路径和图片
            if ([type isEqualToString:@"public.image"]) {
                //先把图片转成NSDatas
                UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                
                ///得到图片原来的名称
                __block NSString *imagesss;
                __block double size;
                
                NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    imagesss = [representation filename];
                    NSLog(@"图片名称＋＋＋＋＋＋＋＋＋＋＋＋＋::%@",imagesss);

                    NSURL *urlname = [info objectForKey:@"UIImagePickerControllerReferenceURL"];

                    __block NSData *data;
                    __block NSString *md5image;
                    __block  NSString * imagePath;
                    __block NSUInteger buffered;
                    __block  NSString *buff;
                    __block NSString *s;
                    // 如何判断已经转化了,通过是否存在文件路径
                    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                    // 创建存放原始图的文件夹--->OriginalPhotoImages
                    NSFileManager * fileManager1 = [NSFileManager defaultManager];
                    if (![fileManager1 fileExistsAtPath:KOriginalPhotoImagePath]) {
                        [fileManager1 createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    if (urlname) {
                        // 主要方法
                        [assetLibrary assetForURL:urlname resultBlock:^(ALAsset *asset) {
                            ALAssetRepresentation *rep = [asset defaultRepresentation];
                            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                            buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                            NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                            data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                            imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                            [data writeToFile:imagePath atomically:YES];

                            NSLog(@"data.length -:%lu",(unsigned long)data.length);
                            
                            md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                            NSLog(@"md5image:%@",md5image);

                            s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                            
                            float floatString = [s floatValue];
                            
                            size = floatString / (1024 * 1024);
                            
                            NSLog(@"size:%.2lf",size);
                            
                            buff = [NSString stringWithFormat:@"%.2lf",size];
                            
                            NSLog(@"图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                           
                        } failureBlock:nil];
                    }
 
                    [[TSCCntc sharedCntc] queryWithPoint:@"getPriceBySize" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&bytes=%lu",[User shareUser].appKey,[User shareUser].authToken,(unsigned long)data.length] andURL:@"Security" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            [SVProgressHUD dismiss];
                            
                            NSDictionary *Dictionary = [object objectForKey:@"data"];
                            
                            NSLog(@"Dictionary-----------:%@",Dictionary);
                            
                            NSString *price = [Dictionary objectForKey:@"amount"];
                            
                            //image  图片
                            //filePath   图片路径
                            //zhao    显示在cell上的M
                            //price   算出来的价格
                            //restnumber    没算出来的多少k
                            //
                            
                        ///根据哈希值判断能不能重选
                            NSString *Md5is;
                            for (NSDictionary *dicMd5 in self.imageArray) {
                                Md5is = dicMd5 [@"md5"];
                                NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++Md5is:%@",Md5is);
                            }
                            
                            if ([Md5is isEqualToString:md5image])
                            {
                                NSLog(@"md5相同");
                                NSLog(@"数组里面的md5 :%@ \n  选中图片的md5：%@",Md5is,md5image);
                            }
                            else
                            {
                                NSDictionary *dic = @{@"image":image,@"filePath":imagesss,@"zhao":buff,@"price":price,@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s};
                                
                                [self.imageArray addObject:dic];
                                
                            }
                            
///================================清除沙盒路径============================
                            [AllObject clearCacheWithFilePath:imagePath];
                            
                            [_tableView removeFromSuperview];
                            [OneView removeFromSuperview];
                            
                            [self refreshTableview];
                            
                        }else{
                            [SVProgressHUD dismiss];
                            [OMGToast showWithText:object[@"msg"]];
                        }
                        
                    } andFailed:^(NSString *object) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                };
                
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:imageURL
                               resultBlock:resultblock
                 
                              failureBlock:nil];
            }
    }
    //  返回的视频
    
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
    {
         NSLog(@"--选取的是视频-----------");
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"url:%@",videoUrl);
        //获取视频第一帧图片
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoUrl];
        UIImage  *image = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        player = nil;//释放player
        
        ///得到图片原来的名称
        __block NSString *imagesss;
        __block double size;
        
        NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSLog(@"imageURL:%@",imageURL);
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            imagesss = [representation filename];
            __block NSData *data;
            __block NSString *md5image;
            __block  NSString * imagePath;
            __block NSUInteger buffered;
            __block  NSString *buff;
            __block NSString *s;
            // 如何判断已经转化了,通过是否存在文件路径
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            // 创建存放原始图的文件夹--->OriginalPhotoImages
            NSFileManager * fileManager1 = [NSFileManager defaultManager];
            if (![fileManager1 fileExistsAtPath:KVideoUrlPath]) {
                [fileManager1 createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (imageURL) {
                // 主要方法
                [assetLibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                    buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                    NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                    data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                    imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                    [data writeToFile:imagePath atomically:YES];
                    //
                    NSLog(@"data.length -:%lu",(unsigned long)data.length);
                    ///md5 加密
                    md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                    ///计算图片大小
                    s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                    
                    float floatString = [s floatValue];
                    
                    size = floatString / (1024 * 1024);
                    
                    NSLog(@"size:%.2lf",size);
                    buff = [NSString stringWithFormat:@"%.2lf",size];
                    
                     NSLog(@"视频的图片++++++++++++++++++++++:%@",image);
                    NSLog(@"视频的名字++++++++++++++++++++++:%@",imagesss);
                    NSLog(@"视频的大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@",buff);
                    NSLog(@"视频的md5++++++++++++++++++++++:%@",md5image);
                    NSLog(@"视频的路径++++++++++++++++++++++:%@",imagePath);
                    NSLog(@"视频的s++++++++++++++++++++++:%@",s);
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"getPriceBySize" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&bytes=%lu",[User shareUser].appKey,[User shareUser].authToken,(unsigned long)data.length] andURL:@"Security" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            [SVProgressHUD dismiss];
                            
                            NSDictionary *Dictionary = [object objectForKey:@"data"];
                            
                            NSLog(@"Dictionary-----------:%@",Dictionary);
                            
                            NSString *price = [Dictionary objectForKey:@"amount"];
                            
                            //image  图片
                            //filePath   图片路径
                            //zhao    显示在cell上的M
                            //price   算出来的价格
                            //restnumber    没算出来的多少k
                            //
                            
                            ///根据哈希值判断能不能重选
                            NSString *Md5is;
                            for (NSDictionary *dicMd5 in self.imageArray) {
                                Md5is = dicMd5 [@"md5"];
                                NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++Md5is:%@",Md5is);
                            }
                            
                            if ([Md5is isEqualToString:md5image])
                            {
                                NSLog(@"md5相同");
                                NSLog(@"数组里面的md5 :%@ \n  选中图片的md5：%@",Md5is,md5image);
                            }
                            else
                            {
                                if ([md5image isKindOfClass:[NSNull class]] || md5image == nil) {
                                    [OMGToast showWithText:@"MD5值无效"];
                                }else{
                                   
                                    NSDictionary *dic = @{@"image":image,@"filePath":imagesss,@"zhao":buff,@"price":price,@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s};
                                    
                                    [self.imageArray addObject:dic];

                                }

                            }
                            
///================================清除沙盒路径============================
                            [AllObject clearCacheWithFilePath:imagePath];
                            
                            [_tableView removeFromSuperview];
                            [OneView removeFromSuperview];
                            
                            [self refreshTableview];
                            
                        }else{
                            [SVProgressHUD dismiss];
                            [OMGToast showWithText:object[@"msg"]];
                        }
                        
                    } andFailed:^(NSString *object) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
  
                    
                } failureBlock:nil];
            }
        
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
         
                      failureBlock:nil];
        
    }
    else{
        
        NSLog(@"info:%@",info);
    }
 
}

#pragma mark - 把图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存成功");
}


- (UIImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [OMGToast showWithText:@"取消选择"];
    [SVProgressHUD dismiss];
    return;
}


-(void)changeIconImage:(UIButton *)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    // 允许编辑
    imagePicker.allowsEditing = YES;
    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)getFileName
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyyMMddHHmmss";
    NSString * str              = [formatter stringFromDate:[NSDate date]];
    NSString * fileName         = [NSString stringWithFormat:@"%@.png", str];
    return fileName;
}
- (void)NavigationBackItemClick{
    HIDEKEYBOARD;
    [self.navigationController popViewControllerAnimated:YES];
}
/// oss 授权
- (void)OSSshouquanappkey:(NSString *)appkey OSSwithauthtoken:(NSString *)authtoken{
    
    ///获取临时授权
    [[TSCCntc sharedCntc] queryWithPoint:@"getOssAppToken" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",appkey,authtoken] andURL:@"UpAuth" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            [User shareUser].upExpires = object [@"data"] [@"upExpires"];
            [User shareUser].upHost = object [@"data"] [@"upHost"];
            [User shareUser].upKeyId = object [@"data"] [@"upKeyId"];
            [User shareUser].upKeySecret = object [@"data"] [@"upKeySecret"];
            [User shareUser].upPath = object [@"data"] [@"upPath"];
            [User shareUser].upSubPath = object [@"data"] [@"upSubPath"];
            [User shareUser].upToken = object [@"data"] [@"upToken"];
            [User saveUserInfo];
            
        }else{
            [OMGToast showWithText:@"授权失败！"];
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}
///获取用户信息
- (void)httprestWithup{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        NSLog(@"进入刷新了数据");
        
        if ([object [@"code"] integerValue] == 200) {
            [User shareUser].defaultAddressId           = object [@"data"] [@"defaultAddressId"];
            [User shareUser].delCertState               = object [@"data"] [@"delCertState"];
            [User shareUser].delFileState               = object [@"data"] [@"delFileState"];
            [User shareUser].downFileState              = object [@"data"] [@"downFileState"];
            [User shareUser].numExpires                 = object [@"data"] [@"numExpires"];
            [User shareUser].numUsed                    = object [@"data"] [@"numUsed"];
            [User shareUser].restSize                    = object [@"data"] [@"restSize"];
            [User shareUser].securityRestNum            = object [@"data"] [@"securityRestNum"];
            [User shareUser].securityTotalNum           = object [@"data"] [@"securityTotalNum"];
            [User shareUser].securityTotalSize          = object [@"data"] [@"securityTotalSize"];
            [User shareUser].securityUsedNum            = object [@"data"] [@"securityUsedNum"];
            [User shareUser].securityUsedSize           = object [@"data"] [@"securityUsedSize"];
            [User shareUser].sizeExpires                = object [@"data"] [@"sizeExpires"];
            [User shareUser].sizeUsed                   = object [@"data"] [@"sizeUsed"];
            [User shareUser].testRestNum                = object [@"data"] [@"testRestNum"];
            [User shareUser].testTotalNum               = object [@"data"] [@"testTotalNum"];
            [User shareUser].testifyType                = object [@"data"] [@"testifyType"];
            [User shareUser].totalSize                  = object [@"data"] [@"totalSize"];
            [User shareUser].usedStatus                 = object [@"data"] [@"usedStatus"];
            [User shareUser].userAvatar                 = object [@"data"] [@"userAvatar"];
            [User shareUser].userName                   = object [@"data"] [@"userName"];
            [User shareUser].userSex                    = object [@"data"] [@"userSex"];
            [User shareUser].userSn                     = object [@"data"] [@"userSn"];
            [User shareUser].userTel                    = object [@"data"] [@"userTel"];
            [User shareUser].verifyType                 = object [@"data"] [@"verifyType"];
            
            [User saveUserInfo];
            
            
            NSLog(@"剩余次数:%@ －－剩余空间容量：%@",[User shareUser].securityRestNum,[User shareUser].restSize);
            
        }else{
            
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

//点击return 按钮 去掉
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    HIDEKEYBOARD;
    return YES;
}


@end

