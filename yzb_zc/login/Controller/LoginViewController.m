//
//  LoginViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "LoginViewController.h"
#import "Public.h"
#import "ServiceViewController.h"
#import "ViewController.h"
#import "TestViewController.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    NSInteger   num;
    NSTimer * _timer;
}
@property (nonatomic, assign) int codeNumber; // 验证码定时数

@property(nonatomic,strong) UIView *Myview;
@property(nonatomic,strong) UITextField *PhoneNum;//手机号
@property(nonatomic,strong) UITextField *Verification;//验证码
@property(nonatomic,strong) UIButton *sendButton;//发送按钮
@property(nonatomic,strong) UIButton *qeudiinganniuButton;//确定按钮

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize]}];
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
- (void)setupView{
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    ///手机号框框
    UIView *wiarth = [[UIView alloc]initWithFrame:CGRectMake(0, 20, screen_width, 250)];
    [view addSubview:wiarth];
    
    UIView *phoneView = [[UIView alloc]init];
    [wiarth addSubview:phoneView];
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(20);
        make.width.equalTo(screen_width);
        make.height.equalTo(70);
    }];
    
    self.PhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, screen_width - 40, 30)];
    self.PhoneNum.delegate = self;
    NSString *older = @"输入手机号";
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
    
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(30, 70, screen_width - 60, 1)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [wiarth addSubview:hen];
    
    
    ///验证码框框
    UIView *yanzhengmaView = [[UIView alloc]init];
    yanzhengmaView.backgroundColor = [UIColor whiteColor];
    [wiarth addSubview:yanzhengmaView];
    [yanzhengmaView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(95);
        make.width.equalTo(screen_width);
        make.height.equalTo(80);
    }];
    self.Verification = [[UITextField alloc]initWithFrame:CGRectMake(30, 25, screen_width - 150, 30)];
    NSString *older2 = @"输入验证码";
    self.Verification.delegate = self;
    NSMutableAttributedString *placeholer2 = [[NSMutableAttributedString alloc]initWithString:older2];
    [placeholer2 addAttribute:NSForegroundColorAttributeName
                        value:TEXTcolor
                        range:NSMakeRange(0, older2.length)];
    [placeholer2 addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:screen_width / 24]
                        range:NSMakeRange(0, older2.length)];
    self.Verification.attributedPlaceholder = placeholer2;
    self.Verification.clearsOnBeginEditing = YES;
    self.Verification.keyboardType = UIKeyboardTypeDefault;
    [yanzhengmaView addSubview:self.Verification];
    
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundColor:[UIColor whiteColor]];
    self.sendButton.layer.cornerRadius = 2.0f;
    self.sendButton.layer.borderColor = RGB(252, 174, 176).CGColor;
    self.sendButton.layer.borderWidth = 1.0;
    [self.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [self.sendButton setTitleColor:RGB(252, 174, 176) forState:UIControlStateNormal];
    [yanzhengmaView addSubview:self.sendButton];
    [self.sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 105);
        make.top.equalTo(25);
        make.width.equalTo(75);
        make.height.equalTo(25);
    }];
    
    UIView *hen2 = [[UIView alloc]initWithFrame:CGRectMake(30, 150, screen_width - 60, 1)];
    hen2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [wiarth addSubview:hen2];
    
    ///确定按钮
    self.qeudiinganniuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qeudiinganniuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qeudiinganniuButton setTitle:@"确定" forState:UIControlStateNormal];
    ///设置按钮字体的偏移量
    self.qeudiinganniuButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [self.qeudiinganniuButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateNormal];
    [self.qeudiinganniuButton setBackgroundImage:[UIImage imageNamed:@"btn_press@2x.png"] forState:UIControlStateHighlighted];
    self.qeudiinganniuButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 22];
    [wiarth addSubview:self.qeudiinganniuButton];
    [self.qeudiinganniuButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(40);
        make.top.equalTo(190);
        make.width.equalTo(screen_width - 80);
        make.height.equalTo(screen_width / 8);
    }];
    
    
    [self.qeudiinganniuButton addTarget:self action:@selector(dengluClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)viewDidDisappear:(BOOL)animated{
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

#define 发送验证码
- (void)sendClick:(UIButton *)sender{
    HIDEKEYBOARD;
    
  num=60;
    
    if (self.PhoneNum.text.length == 0) {
        [OMGToast showWithText:@"请输入11位手机号"];
        return;
    }
    
    if ([AllObject verificationPhoneNumber:self.PhoneNum.text]) {
        
        [SVProgressHUD showWithStatus:@"验证码发送中。。。" maskType:SVProgressHUDMaskTypeGradient];
        ///==========getAuthCode    传的方法
        ///==========appKey=%@      拼接的字符串
        ///==========Auth           方法前面的字符
        [[TSCCntc sharedCntc] queryWithPoint:@"getAuthCode" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@",self.PhoneNum.text] andURL:@"Auth" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [self yazdjs];
            }else{
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }else{
     
        [OMGToast showWithText:@"请输入正确手机号"];
    
    }
}
///验证码倒计时
-(void)yazdjs{
    if (num==0) {
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
        
        return;
    }
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            [self.sendButton setTitle:[NSString stringWithFormat:@"(%li)后重试",(long)num] forState:UIControlStateNormal];
            [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.sendButton.layer.borderColor = [UIColor grayColor].CGColor;
            self.sendButton.userInteractionEnabled = NO;
            num--;
            [self yazdjs];
        }];
    } afterDelaySecs:1];
}

#define 确定
- (void)dengluClick1:(UIButton *)sender{
    NSLog(@"点击了确定");
     HIDEKEYBOARD;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];

}
- (void)JPtuisong{
    NSLog(@"极光推送＝＝＝＝＝＝＝＝＝＝＝");
}

///防止多次点击
- (void)todoSomethingss:(id)sender{
    
    
    
    if (self.PhoneNum.text.length == 0) {
        [OMGToast showWithText:@"账号为空"];
        return;
    }
    if (self.Verification.text.length == 0) {
        [OMGToast showWithText:@"验证码为空"];
        return;
    }
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserToken" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authCode=%@",self.PhoneNum.text,self.Verification.text] andURL:@"Auth" andSuccessCompletioned:^(id object) {
        
        NSLog(@"登录账号数据:%@",object);
        if ([object [@"code"] integerValue] == 4001) {
            //
            ///注册时把电话号码和验证码传到下一个界面
            ServiceViewController *service = [[ServiceViewController alloc]init];
            service.dianhuahaoma = self.PhoneNum.text;
            service.yanzhengma = self.Verification.text;
            [self.navigationController pushViewController:service animated:YES];
            
        }else if([object [@"code"] integerValue] == 200){
            
            NSDictionary *arr = object [@"data"];
            
            ///用单列模式存储appkey
            [User shareUser].appKey                     = object [@"data"] [@"appKey"];
            [User shareUser].authToken                  = object [@"data"] [@"authToken"];
            //            [User shareUser].msgId                      = object [@"data"] [@"msgId"];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"headimg" object:nil];
            ///设置极光推送的别名
            [JPUSHService setTags:[NSSet set] alias:[NSString stringWithFormat:@"%@",arr [@"msgId"]] callbackSelector:@selector(JPtuisong) object:nil];
            
            NSLog(@"------------- [User shareUser].appKey:%@,[User shareUser].authToken:%@",[User shareUser].appKey,[User shareUser].authToken);
            
            TestViewController *view = [[TestViewController alloc]init];
            [self presentViewController:view animated:YES completion:nil];
            
        }else if([object [@"code"] integerValue] == 3083){
            
            [OMGToast showWithText:object [@"msg"]];
            
        }else if([object [@"code"] integerValue] == 3084){
            
            [OMGToast showWithText:object [@"msg"]];
            
        }else if([object [@"code"] integerValue] == 3085){
            
            [OMGToast showWithText:object [@"msg"]];
            
        }else if([object [@"code"] integerValue] == 4022){
            
            [OMGToast showWithText:object [@"msg"]];
            return;
            
        }else{
            
            [OMGToast showWithText:object [@"msg"]];
            return;
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];

}

///点击return键时，隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.Verification == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:6];
            
            return NO;
        }
    }
    return YES;
}

@end
