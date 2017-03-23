//
//  ResultsViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"

@interface ResultsViewController : BasicViewController

@property(nonatomic, strong) NSDictionary *Dictionary;
@property(nonatomic, strong) UIImage *image;

@property(nonatomic, strong) NSDictionary *data;

@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, copy) NSString *shibaiType;
@end
