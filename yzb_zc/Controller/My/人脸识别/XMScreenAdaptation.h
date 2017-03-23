//
//  ScreenAdaptation.h
//  UsedCar
//
//  Created by abel on 15/7/22.
//  Copyright © 2015年 abel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMScreenAdaptation : NSObject

+ (CGRect)adapterRectByWidth:(CGRect)rect;

+ (CGFloat)adapterMultipleByWidth;

@end
