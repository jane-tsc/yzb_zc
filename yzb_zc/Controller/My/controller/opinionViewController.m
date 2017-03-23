//
//  opinionViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "opinionViewController.h"
#import "ViewController.h"
@interface opinionViewController ()<UITextViewDelegate>{
    UIView *view;
    UITextView *textview;
}
@property(nonatomic,strong) UIButton *QuedButton;//确定修改
@end

@implementation opinionViewController

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
    self.title = @"优化意见";
    UITapGestureRecognizer *viewClickTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClickTap)];
    [self.view addGestureRecognizer:viewClickTap];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor = RGB(249, 253, 255);
    [self.view addSubview:view];
    
    [self setupView];
}

- (void)setupView{

    ///初始化UITextView
    textview = [[UITextView alloc] initWithFrame:CGRectMake(20, 35 , screen_width - 40 , 300)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.scrollEnabled = NO;
    textview.editable = YES;
    textview.delegate = self;
    textview.font = [UIFont fontWithName:@"Arial" size:screen_width / 24];
    textview.returnKeyType = UIReturnKeyDefault;///键盘类型
    textview.textAlignment = NSTextAlignmentLeft;
    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    textview.keyboardType = UIKeyboardTypeDefault;
    textview.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    textview.text = @"请输入您的意见和建议";
    textview.layer.cornerRadius = 8.0;
    textview.layer.masksToBounds = YES;
    textview.layer.borderWidth = 0.3;
    textview.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [view addSubview:textview];
    
    
    ///确定按钮
    self.QuedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QuedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.QuedButton setTitle:@"确认" forState:UIControlStateNormal];
    self.QuedButton.layer.cornerRadius = 15.5;
    [self.QuedButton setBackgroundColor:RGB(251, 140, 142)];
    self.QuedButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.QuedButton.layer.shadowOpacity = 0.5;
    self.QuedButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.QuedButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.QuedButton];
    [self.QuedButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(screen_height - 160);
        make.width.equalTo(screen_width / 2.4);
        make.height.equalTo(screen_width / 11);
    }];
    [self.QuedButton addTarget:self action:@selector(querenxiugaiClick1:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 确实修改点击事件
- (void)querenxiugaiClick1:(UIButton *)sender{

    HIDEKEYBOARD;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];
    
    NSLog(@"您点击了确认修改按钮");
}

///防止多次点击
- (void)todoSomethingss:(id)sender{
    
    /// 优化建议
    [[TSCCntc sharedCntc] queryWithPoint:@"setAdvice" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&adviceContent=%@",[User shareUser].appKey,[User shareUser].authToken,textview.text] andURL:@"Advice" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            [[self navigationController] popViewControllerAnimated:YES];
            
            [OMGToast showWithText:@"提交成功"];
        }else{
            [OMGToast showWithText:object[@"msg"]];
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
         [textview resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)viewClickTap{
    HIDEKEYBOARD;
}
@end
