//
//  ViewController.m
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/11.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSLeftSlideControllerOne.h"
#import "LeftViewController.h"
#import "UIView+Extensions.h"
#import "Constants.h"
#import "addressViewController.h"
#import "SecurityViewController.h"
#import "opinionViewController.h"
#import "BaycapacityViewController.h"
#import "OpenpreservationViewController.h"
#import "MSpopView.h"
#import "BrushsuccessViewController.h"

#import "UMSocial.h"
#import "UMSocialDataService.h"
#define AppKey @"5774ba7e67e58e3f12001f13"

@interface CSLeftSlideControllerOne () <LeftViewControllerDelegate>{

    ///发送按钮弹出的POPview
    UIView *wirthView;
    UIView *blackView;
}

@property (nonatomic, strong) UIViewController *mainVC;
@property (nonatomic, strong) LeftViewController *leftVC;
@property (nonatomic, strong) NSMutableDictionary *Dictionary;

@property (nonatomic, assign) CGFloat PanGestureNowX;
@end

@implementation CSLeftSlideControllerOne

- (id)initWithLeftViewController:(UIViewController *)leftVC MainViewController:(UIViewController *)mainVC{
    self = [super init];
    if (self) {
        [self setupLeftVC:leftVC];
        [self setupMainVC:mainVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.frame = self.view.bounds;
    bg.image = [UIImage imageNamed:@"sidebar_bg"];
    [self.view insertSubview:bg atIndex:0];
    
    
//        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
//        [self.view addGestureRecognizer:tap];
    
     [self httprestWithup];
    
    //接收侧滑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLeftSlide) name:kNotificationLeftSlide object:nil];
}

//- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"进入侧滑界面＋＋＋＋＋＋＋＋＋＋＋＋");
//    [self httprestWithup];
//}


- (void)panGestureHandler:(UIPanGestureRecognizer *)PanGestureRecognizer{
//     NSLog(@"手势侧滑了－－－－－－－－－－");
//     [self httprestWithup];
    
    UIView *mainView = _mainVC.view;
    UIView *leftView = _leftVC.view;
    //判断最终位置
   
    if (PanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (mainView.x > kLeftViewW/2) {
            [UIView animateWithDuration:kDuration animations:^{
                
                mainView.x = kLeftViewW;
                leftView.x = 0;
            }];
            
            //添加遮盖
            UIButton *cover = [mainView viewWithTag:3344];
            if (!cover) {
                cover = [[UIButton alloc] initWithFrame:mainView.bounds];
                cover.tag = kcoverTag;
                [cover addTarget:self action:@selector(onClickCover:) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:cover];
            }
            
        }else{
            [UIView animateWithDuration:kDuration animations:^{
                
                mainView.x = 0;
                leftView.x = -kLeftViewW/2;
            }];
            UIButton *cover = [mainView viewWithTag:kcoverTag];
            if (cover) {
                [self onClickCover:cover];
            }
            
        }
    }
    //响应手势侧滑
    _PanGestureNowX = [PanGestureRecognizer translationInView:self.view].x;
    [PanGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    [self animateWithDuration:kDuration Transform:_PanGestureNowX mainView:mainView leftView:leftView];
    
}

- (void)animateWithDuration:(CGFloat)duration Transform:(CGFloat)offsetX mainView:(UIView *)mainView leftView:(UIView *)leftView{
    
    mainView.x += offsetX;
    leftView.x += offsetX/2;
    if (mainView.x > kLeftViewW) {
        mainView.x = kLeftViewW;
    }else if (mainView.x < 0){
        mainView.x = 0;
    }
    
    if (leftView.x > 0) {
        leftView.x = 0;
    }else if (leftView.x < -kLeftViewW/2){
        leftView.x = -kLeftViewW/2;
    }
    
    [self setAlphaWithLeftView:leftView OffsetX:leftView.x];
}

- (void)setAlphaWithLeftView:(UIView *)leftView OffsetX:(CGFloat)offsetX{
    leftView.alpha = 1 - offsetX/-(kLeftViewW/2);
}

- (void)setupMainVC:(UIViewController *)mainVC
{
    _mainVC = mainVC;
    
    [self addChildViewController:mainVC];
    [self.view addSubview:mainVC.view];
    
    UIViewController *vc = ((UINavigationController *)mainVC).childViewControllers[0];
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [vc.view addGestureRecognizer:tap];
}

- (void)setupLeftVC:(UIViewController *)leftVC
{
    _leftVC = leftVC;
    [self addChildViewController:leftVC];
    [self.view addSubview:leftVC.view];
    _leftVC.view.y = 20;
    _leftVC.view.x = -kLeftViewW/2;
    _leftVC.view.height = kLeftViewH;
    _leftVC.view.width = kLeftViewW;
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureLeft:)];
    [_leftVC.view addGestureRecognizer:tap];
    //设置左侧界面的代理
    _leftVC.delegate = self;
}
- (void)panGestureLeft:(UIPanGestureRecognizer *)PanGestureRecognizer{
    UIView *mainView = _mainVC.view;
    UIView *leftView = _leftVC.view;
    //判断最终位置
    
    if (PanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (mainView.x > kLeftViewW/2) {
            [UIView animateWithDuration:kDuration animations:^{
                
                mainView.x = kLeftViewW;
                leftView.x = 0;
            }];
            
            //添加遮盖
            UIButton *cover = [mainView viewWithTag:3344];
            if (!cover) {
                cover = [[UIButton alloc] initWithFrame:mainView.bounds];
                cover.tag = kcoverTag;
                [cover addTarget:self action:@selector(onClickCover:) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:cover];
            }
            
        }else{
            [UIView animateWithDuration:kDuration animations:^{
                
                mainView.x = 0;
                leftView.x = -kLeftViewW/2;
            }];
            UIButton *cover = [mainView viewWithTag:kcoverTag];
            if (cover) {
                [self onClickCover:cover];
            }
        }
    }
    //响应手势侧滑
    _PanGestureNowX = [PanGestureRecognizer translationInView:self.view].x;
    [PanGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    [self animateWithDuration:kDuration Transform:_PanGestureNowX mainView:mainView leftView:leftView];
}

- (void)onClickCover:(UIButton *)cover
{
    [UIView animateWithDuration:kDuration animations:^{
        _mainVC.view.x = 0;
        _leftVC.view.x = -kLeftViewW/2;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)notificationLeftSlide{
    
   
    [self httprestWithup];
    
    UIView *mainView = _mainVC.view;
    UIView *leftView = _leftVC.view;
    [UIView animateWithDuration:kDuration animations:^{
        
        mainView.x = kLeftViewW;
        leftView.x = 0;
        [self setAlphaWithLeftView:leftView OffsetX:0];
    }];
    
    
    //添加遮盖
    UIButton *cover = [mainView viewWithTag:3344];
    if (!cover) {
        cover = [[UIButton alloc] initWithFrame:mainView.bounds];
        cover.tag = kcoverTag;
        [cover addTarget:self action:@selector(onClickCover:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cover];
    }
}
//左侧界面的代理方法
#pragma mark LeftViewControllerDelegate

- (void)LeftViewControllerdidSelectRow:(LeftViewControllerRowType)LeftViewControllerRowType{
    UIButton *cover = [_mainVC.view viewWithTag:kcoverTag];
    [self onClickCover:cover];
    ///如果是试用走if
    if ([self.Dictionary [@"usedStatus"] intValue] == 0) {
        
        
        if (LeftViewControllerRowType == LeftViewControllerRowTypeOne) {
            
            OpenpreservationViewController *address = [[OpenpreservationViewController alloc]init];
            UINavigationController *nav = (UINavigationController *)_mainVC;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:address animated:NO];
            NSLog(@"保全份数");
        }
        else if (LeftViewControllerRowType == LeftViewControllerRowTypeTwo){
            addressViewController *address = [[addressViewController alloc]init];
            UINavigationController *nav = (UINavigationController *)_mainVC;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:address animated:NO];
            NSLog(@"收件地址");
            NSLog(@"现在是侧滑点击跳转的界面3333");
        }
        else if (LeftViewControllerRowType == LeftViewControllerRowTypeThree){
            SecurityViewController *securty = [[SecurityViewController alloc]init];
            UINavigationController *nav =(UINavigationController *)_mainVC;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:securty animated:NO];
            NSLog(@"安全设置");
            
        }
        else if (LeftViewControllerRowType == LeftViewControllerRowTypeFour){
            [self getfasongButton];
            NSLog(@"推荐給好友");
            
        }
        else if (LeftViewControllerRowType == LeftViewControllerRowTypeFive){
            
            opinionViewController *opinion = [[opinionViewController alloc]init];
            UINavigationController *nav = (UINavigationController *)_mainVC;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:opinion animated:NO];
            NSLog(@"优化建议");

        }
        else if (LeftViewControllerRowType == LeftViewControllerRowTypesix){
            
            NSLog(@"点击了使用帮助界面");
            BrushsuccessViewController *shualian= [[BrushsuccessViewController alloc]init];
            UINavigationController *nav = (UINavigationController *)_mainVC;
            [nav popToRootViewControllerAnimated:NO];
            [nav pushViewController:shualian animated:NO];
        }
    }
    ///正式
    else if([self.Dictionary [@"usedStatus"] intValue] == 1)
    {
    
    if (LeftViewControllerRowType == LeftViewControllerRowTypeOne) {
        
        OpenpreservationViewController *address = [[OpenpreservationViewController alloc]init];
        UINavigationController *nav = (UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:address animated:NO];
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypeTwo){
        
        BaycapacityViewController *address = [[BaycapacityViewController alloc]init];
        UINavigationController *nav = (UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:address animated:NO];
        
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypeThree){
        addressViewController *address = [[addressViewController alloc]init];
        UINavigationController *nav = (UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:address animated:NO];
        NSLog(@"现在是侧滑点击跳转的界面3333");
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypeFour){
        SecurityViewController *securty = [[SecurityViewController alloc]init];
        UINavigationController *nav =(UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:securty animated:NO];
        
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypeFive){
        NSLog(@"现在是侧滑点击跳转的界面5555");
    
        [self getfasongButton];
        
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypesix){
        opinionViewController *opinion = [[opinionViewController alloc]init];
        UINavigationController *nav = (UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:opinion animated:NO];
        NSLog(@"现在是侧滑点击跳转的界面5555");
    }
    else if (LeftViewControllerRowType == LeftViewControllerRowTypeseven){
        NSLog(@"点击了使用帮助界面");
        BrushsuccessViewController *shualian= [[BrushsuccessViewController alloc]init];
        UINavigationController *nav = (UINavigationController *)_mainVC;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:shualian animated:NO];
    }
    
    }
}
//#define kMainWindow [UIApplication sharedApplication].windows.lastObject
///发送按钮的点击事件
- (void)getfasongButton{
    
//    [kMainWindow addSubview:self.view];
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    blackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    blackView.userInteractionEnabled = YES;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *tap111= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balck2Click)];
    
    [blackView addGestureRecognizer:tap111];
    
    wirthView = [[UIView alloc]init];
    wirthView.backgroundColor = [UIColor whiteColor];
    wirthView.layer.cornerRadius = 10.0;
    wirthView.layer.masksToBounds = YES;
    [blackView addSubview:wirthView];
    [wirthView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15);
        make.top.equalTo(self.view.bottom).offset(- 165);
        make.width.equalTo(screen_width - 30);
        make.height.equalTo(150);
    }];
    
    for (int i = 0; i < 2; i++) {
        NSMutableArray *images1 = [NSMutableArray arrayWithObjects:@"qq_share@2x.png",@"wx_share@2x.png",@"email@2x.png",@"text@2x.png", nil];
        NSMutableArray *titles1 = [NSMutableArray arrayWithObjects:@"QQ好友",@"微信好友",@"邮件发送",@"短信发送", nil];
        MSpopView *btnView = [[MSpopView alloc] initWithFrame:CGRectMake(i * ((screen_width - 15) / 2) + screen_width / 10, 0, (screen_width - 40) / 4, 120) title:titles1 [i] imageStr:images1 [i]];
        btnView.tag = 300 + i;
        //
        [wirthView addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fasongpopView:)];
        [btnView addGestureRecognizer:tap];
    }
    UIView *hen1 = [[UIView alloc]init];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [wirthView addSubview:hen1];
    [hen1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(15);
        make.top.equalTo(100);
        make.width.equalTo(screen_width - 30);
        make.height.equalTo(1);
    }];
    
    UILabel *lableview = [[UILabel alloc]init];
    lableview.backgroundColor = [UIColor clearColor];
    lableview.textAlignment = NSTextAlignmentCenter;
    lableview.text = @"取消";
    lableview.textColor = RGB(167, 197, 253);
    lableview.font = [UIFont systemFontOfSize:18];
    [wirthView addSubview:lableview];
    [lableview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(hen1.bottom);
        make.width.equalTo(screen_width);
        make.height.equalTo(50);
    }];
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableviewclick2)];
    [lableview addGestureRecognizer:tapview];
}
#pragma mark -  分类按钮点击事件
-(void)fasongpopView:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 300:
        {
            UIImage *image = [UIImage imageNamed:@"banner.jpg"];
            
            NSString *shareText = @"云证保app";
            
            //标题
            [UMSocialData defaultData].extConfig.qqData.title = @"云证保";
           //点击跳转
           [UMSocialData defaultData].extConfig.qqData.url = @"http://code.cocoachina.com";
            //发送到为qq消息类型
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareText image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                                        NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
            
        }
            break;
        case 301:
        {
            ///微信好友
            //应用分享类型如果用户已经安装应用，则打开APP，如果为安装APP，则提示未安装或跳转至微信开放平台
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"微信好友" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
            
        case 302:
        {
            
            ///邮件发送
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:@"云证保证书图片" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
            
        case 303:
        {
            ///短信发送
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:@"云证保证书图片" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                    NSLog(@"分享成功！");
                }
            }];
            
            [self classPopView2];
        }
            break;
            
        default:
            break;
    }
}
///回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
///关闭POPview
- (void)classPopView2{
    
    [UIView animateWithDuration:0.5 animations:^{
        [wirthView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
}
///点击黑色区域隐藏popview
- (void)balck2Click{
    [self classPopView2];
}
///点击黑色区域隐藏popview
- (void)lableviewclick2{
    [self classPopView2];
}
- (void)httprestWithup{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            //
            
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
            
//            NSLog(@"3333333-----------------:%@",[User shareUser].numUsed);
            
        
        }else{
            
        }
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
