//
//  AFNetTool.m
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

#import "AFNetTool.h"

@implementation AFNetTool

+ (BOOL)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    __block BOOL netWorkStatus = YES;
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable)
         {
             netWorkStatus = NO;
             [OMGToast showWithText:status == AFNetworkReachabilityStatusUnknown ? @"网络异常，请检查您的网络设置 ！" : @"未连接网络 ！"];
         }
         else
         {
             netWorkStatus = YES;
         }
     }];
    return netWorkStatus;
}

/// POST 提交数据
+ (void)postJSONWithUrl:(NSString *)httpUrl parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    NSLog(@"_______________________________上传:%@",parameters);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];
    [manager POST:httpUrl parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (fail) {
             fail(error);
         }
     }];
}
/// GET 提交数据
+ (void)getJSONWithUrl:(NSString * )httpUrl success:(void (^)(id json))success fail:(void (^)())fail
{
    NSLog(@"________上传:____%@",httpUrl);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:httpUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}


/// XML 请求示例
+ (void)XMLDataWithUrl:(NSString *)httpUrl success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSDictionary * dict = @{@"format": @"xml"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:httpUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}
/// 文件下载
+ (void)sessionDownloadWithUrl:(NSString *)httpUrl success:(void (^)(NSURL * fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSString *urlString = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString * cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString * path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        NSURL * fileURL = [NSURL fileURLWithPath:path];
        if (success) {
            success(fileURL);
        }
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (fail) {
            fail();
        }
    }];
    [task resume];
}
///// 文件上传
+ (void)postUploadWithUrl:(NSString *)httpUrl parameters:(NSDictionary *)parameters data:(NSData *)fileData fileField:(NSString *)fileField fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:httpUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:fileData name:fileField fileName:fileName mimeType:fileTye];
     } success:^(AFHTTPRequestOperation * operation, id responseObject) {
         NSError *error = nil;
         NSDictionary * postDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
         if (success) {
             success(postDic);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (fail) {
             fail();
         }
     }];
}

@end
