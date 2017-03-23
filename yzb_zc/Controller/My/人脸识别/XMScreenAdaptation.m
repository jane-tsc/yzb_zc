//
//  ScreenAdaptation.m
//  UsedCar
//
//  Created by abel on 15/7/22.
//  Copyright © 2015年 abel. All rights reserved.
//

#import "XMScreenAdaptation.h"

@implementation XMScreenAdaptation

+ (CGRect)adapterRectByWidth:(CGRect)rect {
    return (CGRect){rect.origin.x * [self adapterMultipleByWidth],rect.origin.y * [self adapterMultipleByWidth], rect.size.width * [self adapterMultipleByWidth], rect.size.height * [self adapterMultipleByWidth]};
}

+ (CGFloat)adapterMultipleByWidth {
    return [UIApplication sharedApplication].keyWindow.bounds.size.width / 320.0;
}

@end
