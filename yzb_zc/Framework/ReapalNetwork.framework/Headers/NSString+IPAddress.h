//
//  NSString+IPAddress.h
//  XMPayAndRedeemSDK
//
//  Created by Tammy on 16/4/25.
//  Copyright © 2016年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IPAddress)

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSDictionary *)getIPAddresses;

@end
