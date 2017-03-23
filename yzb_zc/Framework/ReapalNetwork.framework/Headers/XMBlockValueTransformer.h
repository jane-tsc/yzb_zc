//
//  BABlockValueTransformer.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^XMValueTransformationBlock) (id value);

@interface XMBlockValueTransformer : NSValueTransformer

- (instancetype)initWithBlock:(XMValueTransformationBlock)block;

+ (instancetype)transformerWithBlock:(XMValueTransformationBlock)block;

@end
