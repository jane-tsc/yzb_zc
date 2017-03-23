//
//  BAResponse.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, copy, readonly) id body;

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body;

@end
