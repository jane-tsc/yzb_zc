//
//  ImmediatelyViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"

@interface ImmViewController : BasicViewController

@property(nonatomic, strong) NSMutableArray *ListArray;

@property(nonatomic, strong) NSDictionary *Dictionary;

@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, copy)  NSString *payType;

@property(nonatomic, assign) NSInteger num;

@end
