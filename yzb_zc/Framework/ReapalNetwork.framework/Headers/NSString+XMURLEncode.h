//
//  NSString+XMURLEncode.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XMURLEncode)

- (NSString *)ba_encodeString;
- (NSString *)ba_decodeString;

@end
