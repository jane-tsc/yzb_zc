//
//  IdcarViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "IdcarViewController.h"
#import "Public.h"
#import "ViewController.h"
#import "TestViewController.h"
#import "JPUSHService.h"
@interface IdcarViewController ()<UITextFieldDelegate>{
    
}
@property(nonatomic,strong) UITextField *Name;//真是姓名
@property(nonatomic,strong) UITextField *IdcarNum;//身份证号
@property(nonatomic,strong) UIButton *QuedButton;//确定按钮
@end

@implementation IdcarViewController

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated{
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
- (void)tapClick{
    HIDEKEYBOARD;
}

- (void)setupView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    ///初始化登录界面
    UIView *phoneView = [[UIView alloc]init];
    [view addSubview:phoneView];
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(10);
        make.width.equalTo(screen_width);
        make.height.equalTo(70);
    }];
    self.Name = [[UITextField alloc]initWithFrame:CGRectMake(30, 23, screen_width - 40, 30)];
    NSString *older = @"真实姓名";
    self.Name.delegate = self;
    NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:older];
    [placeholer addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older.length)];
    [placeholer addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older.length)];
    self.Name.attributedPlaceholder = placeholer;
    
    self.Name.clearsOnBeginEditing = YES;
//    self.Name.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Name.keyboardType = UIKeyboardTypeDefault;
    [phoneView addSubview:self.Name];
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(30, 85, screen_width - 60, 1)];
    hen.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:hen];
    
    
    UIView *idcarView = [[UIView alloc]init];
    [self.view addSubview:idcarView];
    [idcarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(90);
        make.width.equalTo(screen_width);
        make.height.equalTo(80);
    }];
    self.IdcarNum = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, screen_width - 40, 30)];
    NSString *older1 = @"请输入身份证号";
    NSMutableAttributedString *placeholer1 = [[NSMutableAttributedString alloc]initWithString:older1];
    [placeholer1 addAttribute:NSForegroundColorAttributeName
                        value:TEXTcolor
                        range:NSMakeRange(0, older1.length)];
    [placeholer1 addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:screen_width / 24]
                        range:NSMakeRange(0, older1.length)];
    self.IdcarNum.attributedPlaceholder = placeholer1;
    self.IdcarNum.delegate = self;
    self.IdcarNum.clearsOnBeginEditing = YES;
//    self.IdcarNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.IdcarNum.keyboardType = UIKeyboardTypeDefault;
    [idcarView addSubview:self.IdcarNum];
    
    UIView *hen1 = [[UIView alloc]initWithFrame:CGRectMake(30, 160, screen_width - 60, 1)];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:hen1];
    
    ///确定按钮
    self.QuedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QuedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.QuedButton setTitle:@"确定" forState:UIControlStateNormal];
    self.QuedButton.layer.cornerRadius = 18.0;
    self.QuedButton.layer.masksToBounds = YES;
    self.QuedButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.QuedButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
//    [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_unpress@2x(1).png"] forState:UIControlStateNormal];
    //    [self.qeudiinganniuButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateDisabled];
    [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateNormal];
     [self.QuedButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateHighlighted];
//    self.QuedButton.backgroundColor = RGB(253, 139, 142);
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
    
    
    [self.QuedButton addTarget:self action:@selector(quedingClick:) forControlEvents:UIControlEventTouchUpInside];
}


#define 提交身份证页面确定按钮
- (void)quedingClick:(UIButton *)sender{
    
    HIDEKEYBOARD;
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];

}

///防止多次点击
- (void)todoSomethingss:(id)sender{

    if ([AllObject checkIdentityCardNo:self.IdcarNum.text]) {
        
        [SVProgressHUD showWithStatus:@"提交信息中" maskType:SVProgressHUDMaskTypeGradient];
        
        [[TSCCntc sharedCntc] queryWithPoint:@"registerUser" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&serverTel=%@&userName=%@&userSn=%@&authCode=%@",self.idcarDianhuahaoma,self.idcarFushangdianhuahaoma,self.Name.text,self.IdcarNum.text,self.idcarYanzhengma] andURL:@"Auth" andSuccessCompletioned:^(id object) {
            
            NSLog(@"注册时数据：%@",object);
            if ([object [@"code"] integerValue] == 200) {
                [SVProgressHUD dismiss];
                
                NSDictionary *arr = object [@"data"];
                
                ///用单列模式存储appkey
                [User shareUser].appKey                     = object [@"data"] [@"appKey"];
                [User shareUser].authToken                  = object [@"data"] [@"authToken"];
                [User shareUser].msgId                      = object [@"data"] [@"msgId"];
                [User shareUser].defaultAddressId           = object [@"data"] [@"defaultAddressId"];
                [User shareUser].delCertState               = object [@"data"] [@"delCertState"];
                [User shareUser].delFileState               = object [@"data"] [@"delFileState"];
                [User shareUser].downFileState              = object [@"data"] [@"downFileState"];
                [User shareUser].numExpires                 = object [@"data"] [@"numExpires"];
                [User shareUser].numUsed                    = object [@"data"] [@"numUsed"];
                [User shareUser].restSize                   = object [@"data"] [@"restSize"];
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
                
                ///设置极光推送的别名
                [JPUSHService setTags:[NSSet set] alias:[NSString stringWithFormat:@"%@",arr [@"msgId"]] callbackSelector:@selector(JPtuisong) object:nil];
                
                TestViewController *view = [[TestViewController alloc]init];
                [self presentViewController:view animated:YES completion:nil];
                
            }else{
                [SVProgressHUD dismissWithError:@"提交失败！"];
            }
            
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }else{
        [OMGToast showWithText:@"请输入正确身份证"];
        return;
    }
    
}

- (void)JPtuisong{
    NSLog(@"极光推送＝＝＝＝＝＝＝＝＝＝＝");
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.Name == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}


@end
