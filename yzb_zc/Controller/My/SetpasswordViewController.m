//
//  SetpasswordViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/26.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "SetpasswordViewController.h"
#import "SVProgressHUD.h"
@interface SetpasswordViewController ()<UITextFieldDelegate>{
    UIView *view;
}
@property(nonatomic,strong) UITextField *password1;//密码1
@property(nonatomic,strong) UITextField *password2;//密码2
@property(nonatomic,strong) UIButton *querenBtn;//确定按钮
@end

@implementation SetpasswordViewController

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
    self.title = @"设置密码";
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    [self setuploadUI];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingchangjianpan)];
    [view addGestureRecognizer:tapview];
}

- (void)setuploadUI{
    
    UILabel *lable1 = [UILabel new];
    lable1.text = @"输入密码";
    lable1.textColor = [UIColor blackColor];
    lable1.textAlignment = NSTextAlignmentLeft;
    lable1.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable1];
    [lable1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(view.top).offset(25);
    }];
    self.password1 = [UITextField new];
    self.password1.delegate = self;
    self.password1.secureTextEntry = YES;
    NSString *older = @"请输入6位数密码";
    NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:older];
    [placeholer addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older.length)];
    [placeholer addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older.length)];
    self.password1.attributedPlaceholder = placeholer;
    self.password1.clearsOnBeginEditing = YES;
    self.password1.keyboardType = UIKeyboardTypePhonePad;
    [view addSubview:self.password1];
    [self.password1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable1.bottom).offset(5);
        make.height.equalTo(50);
        make.width.equalTo(screen_width - 60);
    }];
    
    UIView *hen1 = [UIView new];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen1];
    [hen1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(self.password1.bottom).offset(5);
        make.height.equalTo(0.5);
        make.width.equalTo(screen_width - 60);
    }];
    
    UILabel *lable2 = [UILabel new];
    lable2.text = @"确认密码";
    lable2.textColor = [UIColor blackColor];
    lable2.textAlignment = NSTextAlignmentLeft;
    lable2.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:lable2];
    [lable2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(hen1.bottom).offset(30);
    }];
    
    
    self.password2 = [UITextField new];
    self.password2.delegate = self;
    self.password2.secureTextEntry = YES;
    NSString *older1 = @"请再次输入6位数密码";
    NSMutableAttributedString *placeholer1 = [[NSMutableAttributedString alloc]initWithString:older1];
    [placeholer1 addAttribute:NSForegroundColorAttributeName
                       value:TEXTcolor
                       range:NSMakeRange(0, older1.length)];
    [placeholer1 addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:screen_width / 24]
                       range:NSMakeRange(0, older1.length)];
    self.password2.attributedPlaceholder = placeholer1;
    self.password2.clearsOnBeginEditing = YES;
    self.password2.keyboardType = UIKeyboardTypePhonePad;
    [view addSubview:self.password2];
    [self.password2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(lable2.bottom).offset(5);
        make.height.equalTo(50);
        make.width.equalTo(screen_width - 60);
    }];
    
    
    UIView *hen2 = [UIView new];
    hen2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:hen2];
    [hen2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(30);
        make.top.equalTo(self.password2.bottom).offset(5);
        make.height.equalTo(0.5);
        make.width.equalTo(screen_width - 60);
    }];
    
    
    ///确认支付按钮
    self.querenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.querenBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.querenBtn.layer.cornerRadius = 15.0;
    [self.querenBtn setBackgroundColor:RGB(251, 140, 142)];
    ///給按钮添加阴影
    self.querenBtn.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.querenBtn.layer.shadowOpacity = 0.5;
    self.querenBtn.layer.shadowOffset = CGSizeMake(1, 6);
    
    self.querenBtn.titleLabel.font = [UIFont systemFontOfSize:screen_width /24];
    [view addSubview:self.querenBtn];
    [self.querenBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 4);
        make.top.equalTo(hen2.bottom).offset(50);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(screen_width / 11);
    }];
    [self.querenBtn addTarget:self action:@selector(querenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - 确认按钮
- (void)querenBtnClick:(UIButton *)sender{
   
    HIDEKEYBOARD;
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];

    NSLog(@"确认按钮");
}

///防止多次点击
- (void)todoSomethingss:(id)sender{
 

    if (self.password1.text.length == 0) {
        
        [OMGToast showWithText:@"密码不能为空"];
        return;
    }
    if (self.password2.text.length == 0) {
        [OMGToast showWithText:@"再次输入密码不能为空"];
        return;
    }
    if ([self.password1.text isEqualToString:self.password2.text]) {
        
        [[TSCCntc sharedCntc] queryWithPoint:@"setSafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,self.password2.text] andURL:@"Safe" andSuccessCompletioned:^(id object) {
            
            NSLog(@"设置密码数据：%@",object);
            if ([object [@"code"] integerValue] == 200) {
                
                [SVProgressHUD showSuccessWithStatus:@"提交成功" duration:2.0];
                
                ///给个成功的状态
                [User shareUser].RenlianType = 1;
                [User saveUserInfo];
                
                if ([self.Type isEqualToString:@"100"]) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败！请重试" duration:2.0];
            }
            
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误" duration:2.0];
        }];
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" duration:2.0];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.password1 == textField || self.password2 == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:6];
            
            return NO;
        }
    }
    return YES;
}
- (void)yingchangjianpan{
    HIDEKEYBOARD;
}
@end
