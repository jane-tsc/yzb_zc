//
//  TSCCntc.m
//  cntc
//
//  Created by 张超 on 15/7/20.
//  Copyright (c) 2015年 菜鸟同城. All rights reserved.
//

#import "TSCCntc.h"

@interface TSCCntc ()<NSURLConnectionDataDelegate>
{

    
}
@property (nonatomic, strong) NSMutableData *receiveData;
@end

@implementation TSCCntc

+ (instancetype)sharedCntc{
    //实例化对象
    static dispatch_once_t token;
    static TSCCntc *_request;
    dispatch_once(&token, ^{
        _request = [[TSCCntc alloc] init];
    });
    return _request;
}

- (void)queryWithPoint:(NSString *)point andParamsDictionary:(NSString *)params andURL:(NSString *)ur andSuccessCompletioned:(RequestSuccess)success andFailed:(Failed)fail{
    
    //第一步，创建url
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = [NSString stringWithFormat:@"%@%@/%@",HttpUrl,ur,point];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];
    
    
    NSLog(@"_______________Path:%@",path);
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    NSLog(@"url:%@",url);
    [request setHTTPMethod:@"POST"];
    
    NSString *str = params;
    NSLog(@" ===  %@",params);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    request.timeoutInterval = 30;
    //第三步，连接服务器
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            if(connectionError){
                NSString *errorString = connectionError.localizedDescription;
                fail(errorString);
            }else{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode==200){
                    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                    NSLog(@" 服务器 返回数据 %@",json);
                    //回传数据
                    success(json);
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }else if(httpResponse.statusCode == 500){
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    fail(@"访问服务器出现错误");
                }else{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    fail(@"出现网络错误");
                }
            }
            
        });
    }];
}


+ (UIView *)setSegLine:(CGRect)frame{

    UIView* segView = [[UIView alloc] initWithFrame:frame];
    segView.backgroundColor = SEGCOLOR;
    return segView;
}

+ (void)showAlartString:(NSString *)string{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

///去掉textView中的html标签
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+ (void)setUserAddressId:(NSString *)cityId forKey:(NSString *)key{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityId forKey:key];
    [userDefaults synchronize];
    
}
+ (NSString *)getUserAddress:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

///请求服务器网络方法
- (void)TheserverWithPoint:(NSString *)point andParamsDictionary:(NSString *)params andURL:(NSString *)urle andSuccessCompletioned:(RequestSuccess)success andFailed:(Failed)fail;
{

    //第一步，创建url
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = [NSString stringWithFormat:@"%@%@/%@",FuWuQiUrl,urle,point];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    NSLog(@"url:%@",url);
    [request setHTTPMethod:@"POST"];
    
    NSString *str = params;
    NSLog(@" ===  %@",params);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    request.timeoutInterval = 30;
    //第三步，连接服务器
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(connectionError){
                NSString *errorString = connectionError.localizedDescription;
                fail(errorString);
            }else{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode==200){
                    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@" 服务器 返回数据 %@",json);
                    //回传数据
                    success(json);
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }else if(httpResponse.statusCode == 500){
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    fail(@"访问服务器出现错误");
                }else{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    fail(@"出现网络错误");
                }
            }
            
        });
    }];


}

@end
