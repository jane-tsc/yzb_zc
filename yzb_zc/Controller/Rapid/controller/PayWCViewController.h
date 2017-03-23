//
//  PayWCViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface PayWCViewController : BasicViewController

@property(nonatomic, strong) NSMutableArray *ListArray;

@property(nonatomic, strong) NSDictionary *Dictionary;

@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) NSDictionary *yanzhenDic;
///单个文件的图片和文件ID
@property(nonatomic, copy)   NSString *finder;
@property(nonatomic, strong) UIImage *image;

@property(nonatomic, copy)   NSString *paytype;

@end
