//
//  ACPayPwdAlert.h
//  ACPayPwdView
//
//  Created by ablett on 16/6/16.
//  Copyright © 2016年 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface ACPayPwdAlert : UIView

@property (copy, nonatomic) NSString *title;                        ///< 标题
@property (assign, nonatomic) NSUInteger length;                    ///< 密码长度
@property (copy, nonatomic) void (^completeAction)(NSString *text); ///< 回调 Block

- (void)show;

@end
