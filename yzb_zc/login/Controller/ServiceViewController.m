//
//  ServiceViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ServiceViewController.h"
#import "serviceViewCell.h"
#import "IdcarViewController.h"
#import "friendsViewController.h"
#import "snearViewController.h"
@interface ServiceViewController ()<snearViewControllerDelagate,friendsViewControllerDelagate>{
    UITableView *_tableView;
    NSArray *titlearray;
}
@property(nonatomic,strong) UITextField *PhoneNum;//手机号
@property(nonatomic,strong) UIButton *QuedButton;//下一步按钮
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"云证保";
    [self setupView];
    //    设置 状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapviewjianpanLick)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)tapviewjianpanLick{
    HIDEKEYBOARD;
}
//- (void)viewWillAppear:(BOOL)animated{
//    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
//}
-(void)viewDidDisappear:(BOOL)animated{

}


- (void)setupView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [view addSubview:phoneView];
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(self.view.top).offset(30);
        make.width.equalTo(screen_width);
        make.height.equalTo(50);
    }];
    
    
    self.PhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(30, 15, screen_width - 50, 30)];
    NSString *older = @"输入服务商手机号码";
    NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:older];
    [placeholer addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older.length)];
    [placeholer addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older.length)];
    self.PhoneNum.attributedPlaceholder = placeholer;
    
    self.PhoneNum.clearsOnBeginEditing = YES;
//    self.PhoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PhoneNum.keyboardType = UIKeyboardTypePhonePad;
    [phoneView addSubview:self.PhoneNum];
    
    ///确定按钮
    self.QuedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QuedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.QuedButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.QuedButton.layer.cornerRadius = 18.0;
    self.QuedButton.layer.masksToBounds = YES;
    self.QuedButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
//    [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_unpress@2x(1).png"] forState:UIControlStateNormal];
    //    [self.qeudiinganniuButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateDisabled];
    [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateNormal];
     [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateHighlighted];
//     self.QuedButton.backgroundColor = RGB(253, 139, 142);
    
//    
//    self.QuedButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
//    self.QuedButton.layer.shadowOpacity = 0.5;
//    self.QuedButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.QuedButton.titleLabel.font =  [UIFont systemFontOfSize:screen_width / 22];
    [self.view addSubview:self.QuedButton];
    [self.QuedButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(40);
        make.top.equalTo(220);
        make.width.equalTo(screen_width - 80);
        make.height.equalTo(screen_width / 8);
    }];
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(30, 85, screen_width - 60, 1)];
    hen.backgroundColor = [RGB(213, 213, 213)colorWithAlphaComponent:0.5];
    [self.view addSubview:hen];
    
    
    [self.QuedButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundColor:[UIColor whiteColor]];
    sendButton.layer.cornerRadius = 2.0f;
    sendButton.layer.borderColor = RGB(252, 174, 176).CGColor;
    sendButton.layer.borderWidth = 1.0;
    [sendButton setTitle:@"附近服务商" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:screen_width / 24];
    [sendButton setTitleColor:RGB(252, 174, 176) forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(view1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    [sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(25);
        make.top.equalTo(120);
        make.width.equalTo(100);
        make.height.equalTo(25);
    }];

    
    UIButton *sendButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton1 setBackgroundColor:[UIColor whiteColor]];
    sendButton1.layer.cornerRadius = 2.0f;
    sendButton1.layer.borderColor = RGB(252, 174, 176).CGColor;
    sendButton1.layer.borderWidth = 1.0;
    [sendButton1 setTitle:@"好友服务商" forState:UIControlStateNormal];
    sendButton1.titleLabel.font = [UIFont boldSystemFontOfSize:screen_width / 24];
    [sendButton1 setTitleColor:RGB(252, 174, 176) forState:UIControlStateNormal];
    [sendButton1 addTarget:self action:@selector(view2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton1];
    [sendButton1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 100 - 25);
        make.top.equalTo(120);
        make.width.equalTo(100);
        make.height.equalTo(25);
    }];
    
}
/// 附近服务商
- (void)view1Click{
    HIDEKEYBOARD;
    snearViewController *snear = [[snearViewController alloc]init];
    snear.Delegate = self;
    [self.navigationController pushViewController:snear animated:YES];
}
/// 好友服务商
- (void)view2Click{
    HIDEKEYBOARD;
    friendsViewController *friends = [[friendsViewController alloc]init];
    friends.Delegate = self;
    [self.navigationController pushViewController:friends animated:YES];
}

///通过代理传值把电话号码传回当前页面(附近服务商)
- (void)passTrendValues:(NSString *)values{
    self.PhoneNum.text = values;
}
///通过代理传值把电话号码传回当前页面(好友服务商)
- (void)friendspassTrendValues:(NSString *)values{
    self.PhoneNum.text = values;
}

#define 下一步
- (void)loginClick:(UIButton *)sender{
    HIDEKEYBOARD;
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];
}

///防止多次点击
- (void)todoSomethingss:(id)sender{

    if ([self checkTel:self.PhoneNum.text]) {
        
        if (self.PhoneNum.text.length == 0) {
            [OMGToast showWithText:@"账号为空"];
            return;
        }
        [[TSCCntc sharedCntc] TheserverWithPoint:@"getTelType" andParamsDictionary:[NSString stringWithFormat:@"serverTel=%@",self.PhoneNum.text] andURL:@"Server" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"]integerValue] == 200) {
                ///如果手机号是服务商，就跳换到填真实身份证界面
                IdcarViewController *car = [[IdcarViewController alloc]init];
                car.idcarDianhuahaoma            = self.dianhuahaoma;
                car.idcarYanzhengma              = self.yanzhengma;
                car.idcarFushangdianhuahaoma     = self.PhoneNum.text;
                [self.navigationController pushViewController:car animated:YES];
                
            }else{
                
                [OMGToast showWithText:@"服务商不存在"];
            }
            
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }
}


///判断手机号
- (BOOL)checkTel:(NSString *)str

{
    if ([str length] == 0) {
        
        [OMGToast showWithText:@"手机号格式错误"];
        
        return NO;
    }
    
    NSString *regex =@"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        [OMGToast showWithText:@"手机号格式错误"];
        
        return NO;
        
    }
    return YES;
}


@end
