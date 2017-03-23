//
//  UIImage+LY.h
//  LYxinlang
//
//  Created by zuxia on 15-1-23.
//  Copyright (c) 2015年 zuxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Public.h"
@interface UIImage (LY)
//加载全屏的图片
+ (UIImage *)fullScreenImage:(NSString *)imageName;

// 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;
@end
