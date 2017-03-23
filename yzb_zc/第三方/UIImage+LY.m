//
//  UIImage+LY.m
//  LYxinlang
//
//  Created by zuxia on 15-1-23.
//  Copyright (c) 2015年 zuxia. All rights reserved.
//

#import "UIImage+LY.h"
#import "NSString+ZC.h"

@implementation UIImage (LY)


+ (UIImage *)fullScreenImage:(NSString *)imageName{
    if(iphone5){
        imageName = [imageName fileAppend:@"-568h@2x"];
    }
  return [self imageNamed:imageName];
}
//可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height * 0.5];
}

@end
