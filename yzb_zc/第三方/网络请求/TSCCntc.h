//
//  TSCCntc.h
//  cntc
//
//  Created by 张超 on 15/7/20.
//  Copyright (c) 2015年 菜鸟同城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Public.h"

typedef void (^RequestSuccess)(id object);
typedef void (^Failed)(NSString *object);
@interface TSCCntc : NSObject


+ (instancetype)sharedCntc;

///正常域名网络请求方法
- (void)queryWithPoint:(NSString *)point andParamsDictionary:(NSString *)params andURL:(NSString *)url andSuccessCompletioned:(RequestSuccess)success andFailed:(Failed)fail;

///请求服务器网络方法
- (void)TheserverWithPoint:(NSString *)point andParamsDictionary:(NSString *)params andURL:(NSString *)url andSuccessCompletioned:(RequestSuccess)success andFailed:(Failed)fail;


+ (UIView *)setSegLine:(CGRect )frame;

+ (void)showAlartString:(NSString *)string;

///去掉textView中的html标签
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (void)setUserAddressId:(NSString *)cityId forKey:(NSString *)key;
+ (NSString *)getUserAddress:(NSString *)key;
@end
