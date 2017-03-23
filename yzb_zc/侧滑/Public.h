//
//  Public.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//


#import "UIImage+Image.h"
#import "MBProgressHUD.h"
#import "ProgressHUD.h"
#import "MarqueeLabel.h"
#import "AllObject.h"
#import "CoreHttp.h"
#import "SVProgressHUD.h"
#import "GCD.h"
#import "TSCCntc.h"
#import "OMGToast.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "AFNetTool.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+JunCache.h"
#import "JunCache.h"
#import "ACPayPwdAlert.h"///密码输入框头文件
#import "WJTouchID.h"///指纹头文件
#import "XHPicView.h"///浏览图片的第三方

#ifndef aoyouHH_Public_h
#define aoyouHH_Public_h

#define Main_URl(s)  [NSString stringWithFormat:@"http://192.168.1.2/App/Auth/%@",s]
///正常域名请求
//#define HttpUrl @"http://192.168.1.2/App/V1/"
#define HttpUrl @"http://test.yzzdata.com/App/V1/"
///服务器请求
#define FuWuQiUrl @"http://test.yzzdata.com/App/V1/"

///导航栏上字体的大小
#define NacFontsize screen_width / 20

//define this constant if you want to AllObjectuse Masonry without the 'mas_' prefix
#define MAS_SHORTHAND   1

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"


#define appKeyid [[NSUserDefaults standardUserDefaults]objectForKey:@"appKey"]

#define TEXTcolor RGB(207, 209, 209)
#define getwidth(pors) ((pors)/640.0)*[UIScreen mainScreen].bounds.size.width
// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
///IOS8
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8
#define iphone5 ([UIScreen mainScreen].bounds.size.height)

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define navigationBarColor RGB(33, 192, 174)
#define separaterColor RGB(200, 199, 204)

#define GetFrame(X_axis,Y_axis,Width,height) CGRectMake(X_axis, Y_axis, Width, height)
#define GetColor(Red, Green, Blue, Alpha) [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:Alpha]

///导航栏通用绿色
#define GREENCOLOR [UIColor colorWithRed:80 / 255.0 green:176 / 255.0  blue:27/ 2550 alpha:1.0]

// 3.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

//重新设定view的Y值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)


//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y

//5.常用对象
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

//6.经纬度
#define LATITUDE_DEFAULT 39.983497
#define LONGITUDE_DEFAULT 116.318042

//7.
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//8.// 隐藏键盘
#define HIDEKEYBOARD [[UIApplication sharedApplication].keyWindow endEditing:YES]


#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SEGCOLOR [UIColor colorWithRed:((float)((0xcbced2 & 0xFF0000) >> 16))/255.0 green:((float)((0xcbced2 & 0xFF00) >> 8))/255.0 blue:((float)(0xcbced2 & 0xFF))/255.0 alpha:1.0]

#define NSUserDeFaults [NSUserDefaults standardUserDefaults]
#define LOGINED @"AdailyShopLogined"
#define AdailyShopUser @"AdailyShopUser"


// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]




#endif
