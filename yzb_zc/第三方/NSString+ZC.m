//
//  NSString+ZC.m
//  傻子笑了。
//
//  Created by zuxia on 15-4-7.
//  Copyright (c) 2015年 zuxia. All rights reserved.
//

#import "NSString+ZC.h"

@implementation NSString (ZC)

- (NSString *)fileAppend:(NSString *)append{
    
    NSString *ext=[self pathExtension];
    
    NSString *imgName=[self stringByDeletingPathExtension];
    
    imgName=[imgName stringByAppendingString:@"-568h@2x"];
    
    return [self stringByAppendingPathExtension:ext];
}

@end
