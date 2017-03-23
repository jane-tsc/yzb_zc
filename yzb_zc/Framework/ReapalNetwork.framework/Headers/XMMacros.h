//
//  BAMacros.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#define BA_STRONG(obj) __typeof__(obj)
#define BA_WEAK(obj) __typeof__(obj) __weak
#define BA_WEAK_SELF BA_WEAK(self)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#define BA_IOS_SDK_AVAILABLE 1
#else
#define BA_IOS_SDK_AVAILABLE 0
#endif


#ifdef DEBUG
#define debug(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define debug(format, ...)
#endif

#ifndef kDefaultBaseURL
#define kDefaultBaseURL

static NSString * const kDefaultBaseURLString = @"http://api.reapal.com/";

#endif