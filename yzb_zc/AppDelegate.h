//
//  AppDelegate.h
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "LGReachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) double latitude; ///经度
@property (nonatomic, assign) double longitude;///纬度

///判断网络状态
@property (nonatomic,copy) NSString *status;
@end

