//
//  UIColor+RGB.h
//  Tour3D
//
//  Created by shaohua on 5/6/13.
//  Copyright (c) 2013 Shanghai Internet Scenes Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

+ (UIColor *)colorWithRGB:(int)rgb;
+ (UIColor *)colorWithRGB:(int)rgb alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString; // RRGGBB, length 6, no prefix
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
