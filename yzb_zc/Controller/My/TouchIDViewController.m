//
//  TouchIDViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/26.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "TouchIDViewController.h"
#import "WJTouchID.h"
@interface TouchIDViewController ()<WJTouchIDDelegate>{
        UIView *view;
}
@property (nonatomic, strong) WJTouchID *touchID;
@property(nonatomic,strong) UIButton *qrBtnpassword;//确定按钮
@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"设置指纹";
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    [self setupView];
    
    
}

- (void)setupView{

    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:@"fingerprint.png"];
    [view addSubview:image];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(60);
        make.top.equalTo(50);
        make.left.equalTo(screen_width / 2 - 30);
    }];
    
    UILabel *lable = [UILabel new];
    lable.text = @"指纹密码仅对本机有效";
    lable.textColor = [UIColor darkGrayColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:screen_width / 26];
    [view addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(image.bottom).offset(40);
        make.width.equalTo(screen_width);
    }];
    
    ///确认支付按钮
    self.qrBtnpassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qrBtnpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qrBtnpassword setTitle:@"开始绑定" forState:UIControlStateNormal];
    self.qrBtnpassword.layer.cornerRadius = 15.0;
    [self.qrBtnpassword setBackgroundColor:RGB(251, 140, 142)];
    ///給按钮添加阴影
    self.qrBtnpassword.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.qrBtnpassword.layer.shadowOpacity = 0.5;
    self.qrBtnpassword.layer.shadowOffset = CGSizeMake(1, 6);
    
    self.qrBtnpassword.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.qrBtnpassword];
    [self.qrBtnpassword makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 4);
        make.top.equalTo(lable.bottom).offset(50);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(screen_width / 11);
    }];
    [self.qrBtnpassword addTarget:self action:@selector(querenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)querenBtnClick:(UIButton *)sender{
    
    WJTouchID *touchid = [[WJTouchID alloc]init];
    self.touchID = touchid;
    touchid.delegate = self;
    touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
    [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
     [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
}

/**
 *  TouchID验证成功
 *
 *  (English Comments) Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
    ///给个指纹成功的状态
    [User shareUser].fingerprint = 1;
    [User saveUserInfo];
    [SVProgressHUD showWithStatus:@"验证中" maskType:SVProgressHUDMaskTypeGradient];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"line 37: %@",WJNotice(@"TouchID验证成功", @"TouchID验证成功"));
}

- (void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    NSLog(@"返回了上一页");
}
- (void)viewDidAppear:(BOOL)animated{
   [SVProgressHUD dismiss];
     NSLog(@"返回了上一页");
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
/**
 *  取消TouchID验证 (用户点击了取消)
 *
 *  (English Comments) Authentication was canceled by user (e.g. tapped Cancel button).
 */
- (void) WJTouchIDAuthorizeErrorUserCancel {
    NSLog(@"line 54: %@",WJNotice(@"取消TouchID验证 (用户点击了取消)", @"取消TouchID验证 (用户点击了取消)"));
}

/**
 *  在TouchID对话框中点击输入密码按钮
 *
 *  (English Comments) User tapped the fallback button
 */
- (void) WJTouchIDAuthorizeErrorUserFallback {
    NSLog(@"line 63: %@",WJNotice(@"在TouchID对话框中点击输入密码按钮", @"在TouchID对话框中点击输入密码按钮"));
}

/**
 *  在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
 *
 *  (English Comments) Authentication was canceled by system (e.g. another application went to foreground).
 */
- (void) WJTouchIDAuthorizeErrorSystemCancel {
    NSLog(@"line 72: %@",WJNotice(@"在验证的TouchID的过程中被系统取消", @"在验证的TouchID的过程中被系统取消"));
}

/**
 *  无法启用TouchID,设备没有设置密码
 *
 *  (English Comments) Authentication could not start, because passcode is not set on the device.
 */
- (void) WJTouchIDAuthorizeErrorPasscodeNotSet {
    NSLog(@"line 81: %@",WJNotice(@"无法启用TouchID,设备没有设置密码", @"无法启用TouchID,设备没有设置密码"));
}

/**
 *  设备没有录入TouchID,无法启用TouchID
 *
 *  (English Comments) Authentication could not start, because Touch ID has no enrolled fingers
 */
- (void) WJTouchIDAuthorizeErrorTouchIDNotEnrolled {
    NSLog(@"line 90: %@",WJNotice(@"设备没有录入TouchID,无法启用TouchID", @"A设备没有录入TouchID,无法启用TouchID"));
}

/**
 *  该设备的TouchID无效
 *
 *  (English Comments) Authentication could not start, because Touch ID is not available on the device.
 */
- (void) WJTouchIDAuthorizeErrorTouchIDNotAvailable {
    NSLog(@"line 99: %@",WJNotice(@"该设备的TouchID无效", @"该设备的TouchID无效"));
}

/**
 *  多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
 *
 *  (English Comments) Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
 *
 */
- (void) WJTouchIDAuthorizeLAErrorTouchIDLockout {
    NSLog(@"line 109: %@",WJNotice(@"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁", @"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁"));
}

/**
 *  当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
 *
 *  (English Comments) Authentication was canceled by application (e.g. invalidate was called while authentication was inprogress).
 *
 */
- (void) WJTouchIDAuthorizeLAErrorAppCancel {
    NSLog(@"line 119: %@",WJNotice(@"当前软件被挂起取消了授权", @"当前软件被挂起取消了授权"));
}

/**
 *  当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
 *
 *  (English Comments) LAContext passed to this call has been previously invalidated.
 */
- (void) WJTouchIDAuthorizeLAErrorInvalidContext {
    NSLog(@"line 128: %@",WJNotice(@"当前软件被挂起取消了授权", @"当前软件被挂起取消了授权"));
}
/**
 *  当前设备不支持指纹识别
 *
 *  (English Comments) The current device does not support fingerprint identification
 */
-(void)WJTouchIDIsNotSupport {
    NSLog(@"line 136: %@",WJNotice(@"当前设备不支持指纹识别", @"当前设备不支持指纹识别"));
}

@end
