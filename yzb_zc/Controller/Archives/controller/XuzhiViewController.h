//
//  XuzhiViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"

@interface XuzhiViewController : BasicViewController

@property(nonatomic, copy)NSString *fileID;

@property(nonatomic, copy) NSString *storageState;///出征成功失败状态

@property(nonatomic, strong) NSDictionary *Dictionary;

@property(nonatomic, strong) UIImage *image;

@end
