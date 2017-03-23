//
//  NSDate+XMAdditions.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XMAdditions)

+ (NSDate *)ba_dateFromUTCDateString:(NSString *)dateString;
+ (NSDate *)ba_dateFromUTCDateTimeString:(NSString *)dateTimeString;

- (NSString *)ba_UTCDateString;
- (NSString *)ba_UTCDateTimeString;

@end
