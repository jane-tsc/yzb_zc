//
//  AFNetTool.h
//  AFNetWorkDemo
//
//  Created by JUN on 15/6/25.
//  Copyright (c) 2015年 com.adaxi.AdailyShop. All rights reserved.
/* A Da Xi of Chongqing Science and Technology Co., Ltd. is a high-tech enterprise specialized in software development and its affiliated sales of electronic products. Is a professional engaged in software development, software customization, software implementation of high-tech enterprises.
The company has a number of long-term professional engaged in software development, software customization of professional personnel, with strong technology development strength, the full range of government and business information needs.
Company's purpose: scientific and technological innovation, excellence, pioneering and enterprising, pragmatic and efficient.
Business philosophy: people-oriented, integrity, mutual benefit.
Service tenet: "the first-class technology, the first-class product, the thoughtful customer service" is our tenet. "Customer satisfaction" is our eternal pursuit.
Main business: website development and maintenance, software outsourcing, software customization development, system maintenance, OA office systems, mobile APP customization, micro channel two development, etc..
The language used include: JAVA/JSF/JSP,.NET, VB/VBA, OC, Swift, PHP, etc..
The company's business goal is to become a leader in the software development market, innovative technology, developed a series of popular consumer favorite software. */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Public.h"

@interface AFNetTool : NSObject

/// 检测网络状态  可以先判断网络再进行网络请求
+ (BOOL)netWorkStatus;

/// GET 请求
+ (void)getJSONWithUrl:(NSString * )httpUrl success:(void (^)(id json))success fail:(void (^)())fail;

/// POST 请求
+ (void)postJSONWithUrl:(NSString *)httpUrl parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;

/// XML 请求示例
+ (void)XMLDataWithUrl:(NSString *)httpUrl success:(void (^)(id xml))success fail:(void (^)())fail;

/// 文件下载 fileURL 下载后的本地文件路径
+ (void)sessionDownloadWithUrl:(NSString *)httpUrl success:(void (^)(NSURL * fileURL))success fail:(void (^)())fail;

/// 文件上传
/////////////// httpUrl:地址        parameters:需要额外传递的参数          fileData:文件流          fileField:文件在服务器数据库的字段      fileTye:文件类型(例:image/png)         fileName:文件名

+ (void)postUploadWithUrl:(NSString *)httpUrl parameters:(NSDictionary *)parameters data:(NSData *)fileData fileField:(NSString *)fileField fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;


@end
