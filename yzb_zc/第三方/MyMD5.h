//
//  MyMD5.h
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface MyMD5 : NSObject {
    
}
/*****
 2011.09.15
 创建： shen
 MD5 加密
 *****/
+(NSString *) md5: (NSString *) inPutText ;


+ (NSString*)getMD5WithData:(NSData *)data;

///base64 加密
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

///base64  解密
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;


+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
