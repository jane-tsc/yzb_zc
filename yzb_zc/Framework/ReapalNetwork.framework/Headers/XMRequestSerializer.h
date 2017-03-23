//
//  BARequestSerializer.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMRequest;

@class XMMultipartFormData;

extern NSString * const XMRequestSerializerHTTPHeaderKeyAuthorization;
extern NSString * const XMRequestSerializerHTTPHeaderKeyUserAgent;
extern NSString * const XMRequestSerializerHTTPHeaderKeyContentType;
extern NSString * const XMRequestSerializerHTTPHeaderKeyContentLength;

@interface XMRequestSerializer : NSObject

- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request relativeToURL:(NSURL *)baseURL;
- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request multipartData:(XMMultipartFormData *)multipartData relativeToURL:(NSURL *)baseURL;

- (id)valueForHTTPHeader:(NSString *)header;

- (void)setValue:(NSString *)value forHTTPHeader:(NSString *)header;
- (void)setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken;
- (void)setAuthorizationHeaderWithAPIKey:(NSString *)key secret:(NSString *)secret;
- (void)setUserAgentHeader:(NSString *)userAgent;

- (XMMultipartFormData *)multipartFormDataFromRequest:(XMRequest *)request;

@end
