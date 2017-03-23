//
//  ValidationsetViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/26.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ValidationsetViewController.h"
#import "SVProgressHUD.h"
#import "SetpasswordViewController.h"
@interface ValidationsetViewController ()<UITextFieldDelegate>{

        UIView *view;
    NSInteger   num;
    NSTimer * _timer;
}
@property(nonatomic,strong) UITextField *Name;///姓名
@property(nonatomic,strong) UITextField *SnName;///身份证号
@property(nonatomic,strong) UILabel *Phone;///手机号
@property(nonatomic,strong) UITextField *yzNum;///验证码
@property(nonatomic,strong) UIButton *sendButton;//发送按钮
@property(nonatomic,strong) UIButton *qrBtnpassword;//确定按钮
@end

@implementation ValidationsetViewController

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
    self.title = @"重置密码";
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    [self setuploadUI];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingchangjianpan)];
    [view addGestureRecognizer:tapview];

}

- (void)setuploadUI{
    
    UILabel *lable1 = [UILabel new];
    lable1.text = @"姓名";
    lable1.textColor = [UIColor blackColor];
    lable1.textAlignment = NSTextAlignmentLeft;
    lable1.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable1];
    [lable1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(view.top).offset(25);
        make.width.equalTo(70);
        make.height.equalTo(50);
    }];
    self.Name = [UITextField new];
    self.Name.delegate = self;
    NSString *older = @"请输入真实姓名";
    NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:older];
    [placeholer addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older.length)];
    [placeholer addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older.length)];
    self.Name.attributedPlaceholder = placeholer;
    self.Name.clearsOnBeginEditing = YES;
    self.Name.font = [UIFont systemFontOfSize:screen_width / 24];
    self.Name.keyboardType = UIKeyboardTypeDefault;
    self.Name.returnKeyType=UIReturnKeyDefault;
    [view addSubview:self.Name];
    [self.Name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable1.right).offset(25);
        make.top.equalTo(view.top).offset(25);
        make.height.equalTo(50);
        make.width.equalTo(screen_width - 120);
    }];
    UIView *hen1 = [UIView new];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen1];
    [hen1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable1.bottom).offset(10);
        make.width.equalTo(screen_width - 60);
        make.height.equalTo(0.5);
    }];
    
    
    UILabel *lable2 = [UILabel new];
    lable2.text = @"身份证";
    lable2.textColor = [UIColor blackColor];
    lable2.textAlignment = NSTextAlignmentLeft;
    lable2.font = [UIFont systemFontOfSize:screen_width/ 22];
    [view addSubview:lable2];
    [lable2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(hen1.bottom).offset(20);
        make.width.equalTo(70);
        make.height.equalTo(50);
    }];
    self.SnName = [UITextField new];
    self.SnName.delegate = self;
    NSString *older1 = @"请输入真实身份证号码";
    NSMutableAttributedString *placeholer1 = [[NSMutableAttributedString alloc]initWithString:older1];
    [placeholer1 addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older1.length)];
    [placeholer1 addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older1.length)];
    self.SnName.attributedPlaceholder = placeholer1;
    self.SnName.clearsOnBeginEditing = YES;
    self.SnName.font = [UIFont systemFontOfSize:screen_width / 24];
    self.SnName.keyboardType = UIKeyboardTypeDefault;
    [view addSubview:self.SnName];
    [self.SnName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable2.right).offset(25);
        make.top.equalTo(hen1.bottom).offset(20);
        make.height.equalTo(50);
        make.width.equalTo(screen_width - 120);
    }];
    UIView *hen2 = [UIView new];
    hen2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen2];
    [hen2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable2.bottom).offset(10);
        make.width.equalTo(screen_width - 60);
        make.height.equalTo(0.5);
    }];
    
    
    UILabel *lable3 = [UILabel new];
    lable3.text = @"手机号码";
    lable3.textColor = [UIColor blackColor];
    lable3.textAlignment = NSTextAlignmentLeft;
    lable3.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable3];
    [lable3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(hen2.bottom).offset(20);
        make.width.equalTo(70);
        make.height.equalTo(50);
    }];

    self.Phone = [UILabel new];
    self.Phone.text = [User shareUser].userTel;
    self.Phone.textColor = [UIColor blackColor];
    self.Phone.textAlignment = NSTextAlignmentLeft;
    self.Phone.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.Phone];
    [self.Phone makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable3.right).offset(30);
        make.top.equalTo(hen2.bottom).offset(20);
        make.height.equalTo(50);
    }];

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundColor:[UIColor whiteColor]];
    self.sendButton.layer.cornerRadius = 2.0f;
    self.sendButton.layer.borderColor = RGB(252, 174, 176).CGColor;
    self.sendButton.layer.borderWidth = 1.0;
    [self.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [self.sendButton setTitleColor:RGB(252, 174, 176) forState:UIControlStateNormal];
    [view addSubview:self.sendButton];
    [self.sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 95);
        make.top.equalTo(hen2.bottom).offset(30);
        make.width.equalTo(65);
        make.height.equalTo(25);
    }];
    [self.sendButton addTarget:self action:@selector(sendButtonLick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hen3 = [UIView new];
    hen3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen3];
    [hen3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable3.bottom).offset(10);
        make.width.equalTo(screen_width - 60);
        make.height.equalTo(0.5);
    }];
    
    
    
    
    UILabel *lable4 = [UILabel new];
    lable4.text = @"验证码";
    lable4.textColor = [UIColor blackColor];
    lable4.textAlignment = NSTextAlignmentLeft;
    lable4.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable4];
    [lable4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(hen3.bottom).offset(25);
        make.width.equalTo(70);
        make.height.equalTo(50);
    }];
    self.yzNum = [UITextField new];
    self.yzNum.delegate = self;
    NSString *older4 = @"输入验证码";
    NSMutableAttributedString *placeholer4 = [[NSMutableAttributedString alloc]initWithString:older4];
    [placeholer4 addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older4.length)];
    [placeholer4 addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older4.length)];
    self.yzNum.attributedPlaceholder = placeholer4;
    self.yzNum.clearsOnBeginEditing = YES;
    self.yzNum.font = [UIFont systemFontOfSize:screen_width / 24];
    self.yzNum.keyboardType = UIKeyboardTypePhonePad;
    [view addSubview:self.yzNum];
    [self.yzNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable4.right).offset(25);
        make.top.equalTo(hen3.bottom).offset(25);
        make.height.equalTo(50);
        make.width.equalTo(screen_width - 120);
    }];
    UIView *hen4 = [UIView new];
    hen4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen4];
    [hen4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable4.bottom).offset(10);
        make.width.equalTo(screen_width - 60);
        make.height.equalTo(0.5);
    }];
    
    ///确认支付按钮
    self.qrBtnpassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qrBtnpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qrBtnpassword setTitle:@"确认" forState:UIControlStateNormal];
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
        make.top.equalTo(hen4.bottom).offset(50);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(screen_width / 11);
    }];
    [self.qrBtnpassword addTarget:self action:@selector(querenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
///发送验证码
- (void)sendButtonLick:(UIButton *)sender{
    HIDEKEYBOARD;
    
    num = 60;
    
    [SVProgressHUD showWithStatus:@"验证码发送中。。。" maskType:SVProgressHUDMaskTypeGradient];
    ///==========getAuthCode    传的方法
    ///==========appKey=%@      拼接的字符串
    ///==========Auth           方法前面的字符
    [[TSCCntc sharedCntc] queryWithPoint:@"getAuthCode" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&actType=%@",self.Phone.text,@"2"] andURL:@"Auth" andSuccessCompletioned:^(id object) {
        NSLog(@"重置密码的到的验证码数据：%@",object);
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self yazdjs];
        }else{
            [SVProgressHUD showErrorWithStatus:@"发送失败！"];
        }
    } andFailed:^(NSString *object) {
       [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
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
             self.sendButton.layer.borderColor = [UIColor grayColor].CGColor;
            [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.sendButton.userInteractionEnabled = NO;
            num--;
            [self yazdjs];
        }];
    } afterDelaySecs:1];
}
//确定按钮
- (void)querenBtnClick:(UIButton *)sender{

    HIDEKEYBOARD;
    NSLog(@"点击了确认按钮");
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];
 
}

///防止多次点击
- (void)todoSomethingss:(id)sender{

    if (self.Name.text.length == 0) {
        [OMGToast showWithText:@"请输入真实姓名"];
        return;
    }
    if (self.SnName.text.length == 0) {
        [OMGToast showWithText:@"请输入真实身份证"];
        return;
    }
    if (self.yzNum.text.length == 0) {
        [OMGToast showWithText:@"请输入验证码"];
        return;
    }
    if ([AllObject checkIdentityCardNo:self.SnName.text]) {
        
        [[TSCCntc sharedCntc] queryWithPoint:@"validateUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&userName=%@&userSn=%@&authCode=%@",[User shareUser].appKey,[User shareUser].authToken,self.Name.text,self.SnName.text,self.yzNum.text] andURL:@"Safe" andSuccessCompletioned:^(id object) {
            
            NSLog(@"提交用户姓名，身份证时数据：%@",object);
            if ([object [@"code"] integerValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"验证成功" duration:2.0];
                SetpasswordViewController *set = [[SetpasswordViewController alloc]init];
                set.Type = @"100";
                [self.navigationController pushViewController:set animated:YES];
            }
            else if([object [@"code"] integerValue] == 3083)
            {
                [SVProgressHUD showErrorWithStatus:object[@"msg"] duration:2.0];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:object[@"msg"] duration:2.0];
            }
            
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误" duration:2.0];
        }];
        
    }else{
        [OMGToast showWithText:@"输入身份证又误！"];
        return;
    }

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
    
    if (self.SnName == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 18) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    
    if (self.yzNum == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}
- (void)yingchangjianpan{
    HIDEKEYBOARD;
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    HIDEKEYBOARD;
    return YES;
}
@end
