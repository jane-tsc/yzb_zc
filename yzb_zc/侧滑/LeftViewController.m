//
//  SpreadslistViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/8.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "LeftViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "spreadsViewCell.h"
#import "BaycapacityViewController.h"
#import "LoginViewController.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
    UIImageView *Headimg;
    UILabel *name;
    UILabel *phone;
    NSMutableArray * dataArr;
    NSMutableArray *imgArr;
    NSMutableArray * dataArr1;
    NSMutableArray *imgArr1;
    
}
@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableDictionary *Dictionary;


//@property (nonatomic,strong) NSDictionary *dic1;

@end

@implementation LeftViewController

- (void)refreshHeader{
   
    NSLog(@" --- - - -- - - -- -  - -- -- ceshi");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"headimg" object:nil];
    //    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = RGB(34, 34, 48);
    ///改变状态为白色
    
    self.dataArr1 = [NSMutableArray array];
    self.dataArr2 = [NSMutableArray array];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -20, screen_width, 160)];
    view.backgroundColor =RGB(34, 34, 48);
    //    view.backgroundColor = [UIColor redColor];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
//    
//    [self httpWithload];
//    [self httpkaitongNum];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickrootview:) name:@"cehuaNotification" object:nil];
    
    Headimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70, 50, 50)];
    
    NSLog(@"[User shareUser].userAvatar]:%@",[User shareUser].userAvatar);
    
    if ([AllObject isBlankString:[User shareUser].userAvatar] || [User shareUser].userAvatar.length == 0)
    {
//         Headimg.image =[UIImage imageNamed:@"tx_bg_nor@2x(1).png"];
       
        [Headimg sd_setImageWithURL:[NSURL URLWithString:[User shareUser].userAvatar] placeholderImage:nil];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURL *url = [NSURL URLWithString:[User shareUser].userAvatar];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                Headimg.image = [UIImage imageWithData:data];
            });
            
        });
    }

    Headimg.layer.cornerRadius = Headimg.frame.size.height / 2;
    Headimg.layer.masksToBounds = YES;
    Headimg.userInteractionEnabled = YES;
    [view addSubview:Headimg];
    
    name = [UILabel new];
    name.text = [User shareUser].userName;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:screen_width / 28];
    [view addSubview:name];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Headimg.right).offset(20);
        make.top.equalTo(75);
        make.width.equalTo(screen_width - 100);
        make.height.equalTo(20);
    }];
    
    phone = [UILabel new];
    phone.textColor= [UIColor whiteColor];
    phone.text = [User shareUser].userTel;
    phone.font = [UIFont systemFontOfSize:screen_width / 28];
    [view addSubview:phone];
    [phone makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Headimg.right).offset(15);
        make.top.equalTo(name.bottom).offset(5);
        make.width.equalTo(screen_width - 100);
        make.height.equalTo(20);
    }];
    
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(15, 140, screen_width - 30, 0.5)];
    hen.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:hen];
    

    UIView *edixView = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height - 80, screen_width, 60)];
    edixView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:edixView];
    
    UIImageView *exioImg = [[UIImageView alloc]init];
    exioImg.image = [UIImage imageNamed:@"close_sidebar_n.png"];
    exioImg.userInteractionEnabled = YES;
    [edixView addSubview:exioImg];
    [exioImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(22);
        make.width.equalTo(15);
        make.height.equalTo(16);
    }];
    
    UILabel *exit = [UILabel new];
    exit.text = @"退出登录";
    exit.textColor = [UIColor whiteColor];
    exit.textAlignment = NSTextAlignmentLeft;
    exit.font = [UIFont systemFontOfSize:screen_width / 28];
    exit.userInteractionEnabled = YES;
    [edixView addSubview:exit];
    [exit makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(exioImg.right).offset(15);
        make.top.equalTo(15);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitClick)];
    [exioImg addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitClick)];
    [exit addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewClick)];
    [view addGestureRecognizer:tapView];
    
    UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewClick)];
    [Headimg addGestureRecognizer:tapView1];
    
}


- (void)showTableviewUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, screen_width, screen_height - 180 -50) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(34, 34, 48);
    //    _tableView.backgroundColor = [UIColor orangeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickrootview:) name:@"cehuaNotification" object:nil];
}
- (void)clickrootview:(NSNotificationCenter *)sender{
    
    NSLog(@"进入了侧滑");

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.5f];
   
}
- (void)todoSomething:(id)sender{
    
   [self httprestWithup];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
     [self httprestWithup];
    
    [_tableView reloadData];
    NSLog(@"ttttttttttt---------------------------------------------------:%@--:%@",[User shareUser].numUsed,[User shareUser].sizeUsed);
}

///进入个人中心
- (void)ViewClick{
    MyViewController *myView = [[MyViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myView];
    //    [self.navigationController pushViewController:nav animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ///如果未开通保全次数就不显示容量
    if ([self.Dictionary [@"usedStatus"] intValue] == 0) {
        return 6;
    }else if([self.Dictionary [@"usedStatus"] intValue] == 1){
         return 7;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    spreadsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[spreadsViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cell_id];
    }
//    [cell configeWithIndexPath:indexPath withdic1:self.dic1 withdic:self.dic];
    [cell configeWithIndexPath:indexPath withdic1:self.Dictionary];
    
    dataArr = [NSMutableArray arrayWithObjects:@"保全份数",@"收件地址",@"安全设置",@"推荐给好友",@"优化建议",@"使用帮助", nil];
    imgArr = [NSMutableArray arrayWithObjects:@"address_sidebar_7_n@2x.png",@"address_1.png",@"address_2.png",@"address_sidebar_3_n",@"address_sidebar_4_n",@"address_sidebar_5_n", nil];

    dataArr1 = [NSMutableArray arrayWithObjects:@"保全份数",@"储存空间",@"收件地址",@"安全设置",@"推荐给好友",@"优化建议",@"使用帮助", nil];
    imgArr1 = [NSMutableArray arrayWithObjects:@"address_sidebar_7_n@2x.png",@"address_sidebar_6_n@2x.png",@"address_1.png",@"address_2.png",@"address_sidebar_3_n",@"address_sidebar_4_n",@"address_sidebar_5_n", nil];
    
    ///判断是否开通了保全次数
    if ([[User shareUser].usedStatus intValue] == 0 )
    {
        [dataArr1 removeAllObjects];
        [imgArr1 removeAllObjects];
        
            NSLog(@"0000----:%@",[User shareUser].usedStatus);
            cell.image.image = [UIImage imageNamed:imgArr [indexPath.row]];
            cell.title.text = dataArr [indexPath.row];
            
            if (indexPath.row == 0) {
                
                cell.titleConunt1.text = @"未购买";
                
                UILabel *lable2 = [UILabel new];
                lable2.text = @"购买";
                lable2.textAlignment = NSTextAlignmentCenter;
                lable2.font = [UIFont systemFontOfSize:11];
                lable2.textColor = [UIColor whiteColor];
                lable2.layer.cornerRadius = 3.0;
                lable2.layer.masksToBounds = YES;
                lable2.layer.borderWidth = 0.7;
                lable2.layer.borderColor = [UIColor whiteColor].CGColor;
                lable2.userInteractionEnabled = NO;
                [cell addSubview:lable2];
                [lable2 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(screen_width / 1.7);
                    make.top.equalTo(15);
                    make.width.equalTo(60);
                    make.height.equalTo(screen_width / 20);
                }];
        }
    }
    else if ([[User shareUser].usedStatus intValue] == 1)
    {
    
        [dataArr removeAllObjects];
        [imgArr removeAllObjects];
        
        NSLog(@"1111 ----:%@",[User shareUser].usedStatus);

        cell.image.image = [UIImage imageNamed:imgArr1 [indexPath.row]];
        cell.title.text = dataArr1 [indexPath.row];
            if (indexPath.row == 0) {
                
                if ([[User shareUser].numUsed intValue] == 0) {
                  
                }else if([[User shareUser].numUsed intValue] == 1){
                
                    cell.titleConunt1.text = [NSString stringWithFormat:@"%@份",[User shareUser].securityRestNum];
                    UILabel *lable2 = [UILabel new];
                    lable2.text = @"购买";
                    lable2.textAlignment = NSTextAlignmentCenter;
                    lable2.font = [UIFont systemFontOfSize:11];
                    lable2.textColor = [UIColor whiteColor];
                    lable2.layer.cornerRadius = 3.0;
                    lable2.layer.masksToBounds = YES;
                    lable2.layer.borderWidth = 0.7;
                    lable2.layer.borderColor = [UIColor whiteColor].CGColor;
                    lable2.userInteractionEnabled = NO;
                    [cell addSubview:lable2];
                    [lable2 makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(screen_width / 1.7);
                        make.top.equalTo(15);
                        make.width.equalTo(60);
                        make.height.equalTo(screen_width / 20);
                        
                    }];
                }
        
            }
            else if(indexPath.row == 1){
               
                if ([[User shareUser].sizeUsed intValue] == 0) {
                    
                    cell.titleConunt2.text = @"未购买";
                    UILabel *lable2 = [UILabel new];
                    lable2.text = @"购买";
                    lable2.textAlignment = NSTextAlignmentCenter;
                    lable2.font = [UIFont systemFontOfSize:11];
                    lable2.textColor = [UIColor whiteColor];
                    lable2.layer.cornerRadius = 3.0;
                    lable2.layer.masksToBounds = YES;
                    lable2.layer.borderWidth = 0.7;
                    lable2.layer.borderColor = [UIColor whiteColor].CGColor;
                    lable2.userInteractionEnabled = NO;
                    [cell addSubview:lable2];
                    [lable2 makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(screen_width / 1.7);
                        make.top.equalTo(15);
                        make.width.equalTo(60);
                        make.height.equalTo(screen_width / 20);
                        
                    }];
                    
                    
                }else if ([[User shareUser].sizeUsed intValue] == 1){
                
                    cell.titleConunt2.text = [NSString stringWithFormat:@"%@G/%@G",[User shareUser].securityUsedSize,[User shareUser].securityTotalSize];
                    UILabel *lable2 = [UILabel new];
                    lable2.text = @"购买";
                    lable2.textAlignment = NSTextAlignmentCenter;
                    lable2.font = [UIFont systemFontOfSize:11];
                    lable2.textColor = [UIColor whiteColor];
                    lable2.layer.cornerRadius = 3.0;
                    lable2.layer.masksToBounds = YES;
                    lable2.layer.borderWidth = 0.7;
                    lable2.layer.borderColor = [UIColor whiteColor].CGColor;
                    lable2.userInteractionEnabled = NO;
                    [cell addSubview:lable2];
                    [lable2 makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(cell.titleConunt2.right).offset(25);
                        make.left.equalTo(screen_width / 1.7);
                        make.top.equalTo(15);
                        make.width.equalTo(60);
                        make.height.equalTo(screen_width / 20);
                        
                    }];
                
                }
 
            }
            
//        }
    
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

        if (self.delegate && [self.delegate respondsToSelector:@selector(LeftViewControllerdidSelectRow:)]) {
            NSInteger row = indexPath.row;
            NSLog(@"您点击了%ld",(long)row);
            [self.delegate LeftViewControllerdidSelectRow:row];
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

- (void)deSelectCell
{
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:NO];
}

#define 退出按钮
- (void)exitClick{
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确定退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[TSCCntc sharedCntc] queryWithPoint:@"authLoginOut" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"Auth" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                
                LoginViewController *login = [[LoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            
                [User exitSign];
                NSLog(@"退出当前账号：--------:%@－-%@",[User shareUser].appKey,[User shareUser].numUsed);
                
            }else{
                [SVProgressHUD dismissWithError:object [@"msg"]];
            }
            
        } andFailed:^(NSString *object) {
             [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }];
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:quxiao];
    [alertDialog addAction:Okaction];
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
    
    NSLog(@"点击了退出按钮");
}

- (void)httprestWithup{
    
    
    [_tableView removeFromSuperview];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
       
            self.Dictionary = object [@"data"];

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

            [self showTableviewUI];
            NSLog(@"侧滑类");
//            [_tableView reloadData];
            [Headimg sd_setImageWithURL:[NSURL URLWithString:[User shareUser].userAvatar] placeholderImage:nil];
        }else{
            
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
