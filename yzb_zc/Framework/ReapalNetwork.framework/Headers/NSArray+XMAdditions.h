//
//  NSArray+XMAdditions.h
//  BANetworking
//
//  Created by Tammy on 15/9/6.
//  Copyright © 2015年 Tammy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (XMAdditions)

- (instancetype)ba_mappedArrayWithBlock:(id (^)(id obj))block;
- (instancetype)ba_filteredArrayWithBlock:(BOOL (^)(id obj))block;
- (id)ba_reducedValueWithInitialValue:(id)initialValue block:(id (^)(id reduced, id obj))block;
- (id)ba_reducedValueWithBlock:(id (^)(id reduced, id obj))block;
- (id)ba_firstObjectPassingTest:(BOOL (^)(id obj))block;
+ (instancetype)ba_arrayFromRange:(NSRange)range;

@end
