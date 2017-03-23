//
//  AppDelegate.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "CCLocationManager.h"
#import "Public.h"
#import "TestViewController.h"
#import "NewfeatureViewController.h"
#import "TFHpple.h"
#import "UIColor+RGB.h"
#import "CCLocationManager.h"
#import "LoginViewController.h"
#import "JPUSHService.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#define AppKey @"5774ba7e67e58e3f12001f13"

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>{
    
    CLLocationManager *locationmanager;
    NSInteger index;
}
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSMutableDictionary *dic;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /// 检查网络状态
    [self ChecktheNetwork];
    /// 获得本地缓存用户数据
    [self getLocalUserInfo];
    ///启动图延迟三秒进入程序
    [NSThread sleepForTimeInterval:2];
    ///清除角标
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            _latitude = locationCorrrdinate.latitude;
            _longitude = locationCorrrdinate.longitude;
            NSLog(@" 定位当前位置 经度：－%f  纬度：－－%f",_latitude,_longitude);
            
        }];
    }
    //向微信注册
    [WXApi registerApp:@"wx82f7ffec1d3cfaf5" withDescription:@"云证保"];
    ///向友盟注册
    [UMSocialData setAppKey:AppKey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx82f7ffec1d3cfaf5" appSecret:AppKey url:@"https://open.weixin.qq.com/cgi-bin/index?t=home/index&lang=zh_CN"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105435542" appKey:@"FhaJFie9A7VhAKoh" url:@"http://open.qq.com"];

///===============================================极光推送===============================================
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                       UIRemoteNotificationTypeSound |
//                                                       UIRemoteNotificationTypeAlert)
//                                           categories:nil];
    }
#else
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:@"e2308180033711fcf40b02c5" channel:@"" apsForProduction:nil];

    ////获取自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager startUpdatingLocation];
    }
    else {
        [OMGToast showWithText:@"定位功能没有打开"];
    }

    
    //得到版本的key
    NSString *key=(NSString *)kCFBundleVersionKey;
    //得到版本号
    NSString *version=[NSBundle mainBundle].infoDictionary[key];
    NSString *saveVersion=[[NSUserDefaults standardUserDefaults]objectForKey:key];
    if([version isEqualToString:saveVersion]){
        
        NSLog(@"appKey=:%@------authToken=:%@",[User shareUser].appKey,[User shareUser].authToken);
        
        if ([[User shareUser].appKey isEqualToString:@""] || [[User shareUser].authToken isEqualToString:@""])
        {
            LoginViewController *login = [[LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
            NSLog(@"进入登录");
        }
        
        [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&clientType=%@&versionCode=%@",[User shareUser].appKey,[User shareUser].authToken,@"20",@"1000000"] andURL:@"User" andSuccessCompletioned:^(id object) {
            
            NSLog(@"启动窗口返回的数据:%@",object);
            
            if ([object [@"code"] integerValue] == 200) {
                ///获取个人信息或者版本
                [self httprestWithup];
                
                self.dic = object [@"data"];
                ///200 时候进入主页
                self.window = [[UIWindow alloc] init];
                self.window.rootViewController = [[TestViewController alloc] init];
                self.window.frame = [UIScreen mainScreen].bounds;
                [self.window makeKeyAndVisible];
                NSLog(@"进入主页");
                
            }
            ///403 时候进入登录
            else if([object [@"code"] integerValue] == 403){
                
                [OMGToast showWithText:@"登录失效，请重新登录"];
                
                LoginViewController *login = [[LoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                self.window.rootViewController = nav;
                [self.window makeKeyAndVisible];
                NSLog(@"进入登录");
            }
        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        
    }else{
        //表示第一次使用当前版本
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //显示版本新特性界面
        self.window.rootViewController = [[NewfeatureViewController alloc] init];
    }
    
    return YES;

}
///==================================================检查网络情况==================================================
- (void)ChecktheNetwork{
 
   
    
         //真机测试时在同一个页面测试不同的网络的状态
    [LGReachability LGwithSuccessBlock:^(NSString *status) {
        NSLog(@"网络状态%@",status);
        self.status = status;
        if ([status isEqualToString:@"无连接"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
             NSLog(@"无网络");
        }
        else if ([status isEqualToString:@"3G/4G网络"])
        {
            NSLog(@"3G/4G流量");
        }
        else if ([status isEqualToString:@"wifi状态下"])
        {
             NSLog(@"wifi状态下");
        }
    }];
}
/**
 * 本地推送，最多支持64个
 * @param fireDate 本地推送触发的时间
 * @param alertBody 本地推送需要显示的内容
 * @param badge 角标的数字。如果不需要改变角标传-1
 * @param alertAction 弹框的按钮显示的内容（IOS 8默认为"打开",其他默认为"启动"）
 * @param notificationKey 本地推送标示符
 * @param userInfo 自定义参数，可以用来标识推送和增加附加信息
 * @param soundName 自定义通知声音，设置为nil为默认声音
 
 * IOS8新参数
 * @param region 自定义参数
 * @param regionTriggersOnce 自定义参数
 * @param category 自定义参数
 */

///收到的通知，判断账号在另一个设备上登录
/*
 2016-07-25 18:00:26.293 yzb_zc[3591:1150395] ---自定义消息---{
 content = "\U8be5\U5e10\U6237\U5df2\U7ecf\U5728\U5176\U4ed6\U8bbe\U5907\U767b\U5f55";
 "content_type" = 1;
 title = "\U767b\U5f55\U901a\U77e5";
 }
 */


////获取推送自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"---自定义消息---%@",userInfo);
    if ([userInfo [@"content_type"]integerValue]==1) {
        NSString *content = [NSString stringWithFormat:@"%@",userInfo [@"content"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下线通知"
                                                       message:content
                                                      delegate:self
                                             cancelButtonTitle:@"退出"
                                             otherButtonTitles:@"重新登录", nil];
        [alert show];
        index = 20;
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"--------------:%@",error);
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo);
}
//
///得到的内容
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

///==================================================获得本地缓存用户数据==================================================
#pragma mark - 获得本地缓存用户数据
- (void)getLocalUserInfo
{
    if ([NSUserDeFaults boolForKey:LOGINED])
    {
        NSData * userData                     = [NSUserDeFaults objectForKey:AdailyShopUser];
        User * user                           = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        [User shareUser].fingerprint               = user.fingerprint;
        [User shareUser].msgId                     = user.msgId;
        [User shareUser].appKey                    = user.appKey;
        [User shareUser].authToken                 = user.authToken;
        [User shareUser].userTel                   = user.userTel;
        [User shareUser].userName                  = user.userName;
        [User shareUser].userAvatar                = user.userAvatar;
        [User shareUser].userSex                   = user.userSex;
        [User shareUser].userSn                    = user.userSn;
        [User shareUser].defaultAddressId          = user.defaultAddressId;
        [User shareUser].addressShen               = user.addressShen;
        [User shareUser].addressShi                = user.addressShi;
        [User shareUser].addressQu                 = user.addressQu;
        [User shareUser].addressDetailed           = user.addressDetailed;
        [User shareUser].addressShenID             = user.addressShenID;
        [User shareUser].addressShiID              = user.addressShiID;
        [User shareUser].addressQuID               = user.addressQuID;
        [User shareUser].zhenshuDelete               = user.zhenshuDelete;
        [User shareUser].zhengshuchuzheng              = user.zhengshuchuzheng;
        [User shareUser].yuanwenjianxiazai               = user.yuanwenjianxiazai;
        [User shareUser].yuanwenjianDelete               = user.yuanwenjianDelete;
        [User shareUser].RenlianType               = user.RenlianType;
        [User shareUser].upExpires               = user.upExpires;
        [User shareUser].upHost               = user.upHost;
        [User shareUser].upKeyId               = user.upKeyId;
        [User shareUser].upKeySecret               = user.upKeySecret;
        [User shareUser].upPath               = user.upPath;
        [User shareUser].upSubPath               = user.upSubPath;
        [User shareUser].upToken               = user.upToken;
        [User shareUser].upCallBack               = user.upCallBack;
        [User shareUser].delCertState               = user.delCertState;
        [User shareUser].delFileState               = user.delFileState;
        [User shareUser].downFileState               = user.downFileState;
        [User shareUser].numExpires               = user.numExpires;
        [User shareUser].numUsed               = user.numUsed;
        [User shareUser].restSize               = user.restSize;
        [User shareUser].securityRestNum               = user.securityRestNum;
        [User shareUser].securityTotalNum               = user.securityTotalNum;
        [User shareUser].securityTotalSize               = user.securityTotalSize;
        [User shareUser].securityUsedNum               = user.securityUsedNum;
        [User shareUser].securityUsedSize               = user.securityUsedSize;
        [User shareUser].sizeExpires               = user.sizeExpires;
        [User shareUser].sizeUsed               = user.sizeUsed;
        [User shareUser].testRestNum               = user.testRestNum;
        [User shareUser].testTotalNum               = user.testTotalNum;
        [User shareUser].testifyType               = user.testifyType;
        [User shareUser].totalSize               = user.totalSize;
        [User shareUser].verifyType               = user.verifyType;
        [User shareUser].usedStatus               = user.usedStatus;
        
         [User shareUser].Noremind               = user.Noremind;
         [User shareUser].zhengshuchuzhengNoremind               = user.zhengshuchuzhengNoremind;
         [User shareUser].yuanwenjianxiazaiNoremind               = user.yuanwenjianxiazaiNoremind;
         [User shareUser].yuanwenjianshanchuNoremind               = user.yuanwenjianshanchuNoremind;
        
        [User saveUserInfo];
    }
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


///=====================================控制版本更新=====================================
- (void)httprestWithup{

        [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&clientType=%@&versionCode=%@",[User shareUser].appKey,[User shareUser].authToken,@"20",@"1000000"] andURL:@"User" andSuccessCompletioned:^(id object) {
            
            if ([object [@"code"] integerValue] == 200) {
                
                self.dic = object [@"data"];

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
                NSLog(@"启动窗口类");
                
                ///判断是否有更新
                if ([self.dic [@"versionUpdate"] integerValue] == 1)
                {
                    ///判断是否要强制更新 0 表示不需要强制更新
                    if ([self.dic [@"versionStatus"] integerValue] == 0)
                    {
                        NSString *html = [NSString stringWithFormat:@"%@",self.dic [@"versionDescription"]];
                        NSLog(@"html:%@",html);
                        NSString *content = [self flattenHTML:html];
                        
                        NSError *error = nil;
                        HTMLParser *parser = [[HTMLParser alloc]initWithString:html error:&error];
                        
                        if (error) {
                            NSLog(@"NSError:%@",error);
                        }
                        
                        HTMLNode *bodyNode = [parser body];
                        NSArray *inputNodes = [bodyNode findChildTags:@"<p>"];
                        for (HTMLNode *spanNode in inputNodes) {
                            if ([[spanNode getAttributeNamed:@"<p>"] isEqualToString:@"<p>"]) {
                                NSLog(@"解析的数据：%@", [spanNode rawContents]); //Answer to second question
                            }
                        }

                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新"
                                                                       message:content
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:@"确定", nil];
                        [alert show];
                        
                        index = 1;
                    }
                    //////判断是否要强制更新 1 表示要强制更新
                    else if ([self.dic [@"versionStatus"] integerValue] == 1)
                    {
                        NSString *message = [NSString stringWithFormat:@"%@",self.dic [@"versionDescription"]];
                        
                        NSString *content = [self flattenHTML:message];
                        
                        NSLog(@"string:%@",message);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新"
                                                                       message:content
                                                                      delegate:self
                                                             cancelButtonTitle:@"立即更新"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                        
                        index = 2;
                    }
                }
            }

        } andFailed:^(NSString *object) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (index == 1) {
        
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            ///跳转到app stroae
            NSURL *url = [NSURL URLWithString:self.dic [@"versionUrl"]];
            [[UIApplication sharedApplication] openURL:url];
            NSLog(@"立即更新");
        }
    }
    else if (index == 2)
    {
        if (buttonIndex == 0) {
            ///跳转到app stroae
            NSURL *url = [NSURL URLWithString:self.dic [@"versionUrl"]];
            [[UIApplication sharedApplication] openURL:url];
            NSLog(@"强制更新");
        }
    }
    else if (index == 20)
    {
        if (buttonIndex == 0) {
            exit(0);
        }
        else if (buttonIndex == 1){
            LoginViewController *login = [[LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
            ///设置极光推送的别名
            [JPUSHService setTags:NULL alias:NULL callbackSelector:@selector(JPtuisong) object:NULL];
            NSLog(@"重新登录");
        }
    }
}
- (void)JPtuisong{
    NSLog(@"清空别名");
}
///过滤html标签
- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    } // while //
    return html;
}
@end
