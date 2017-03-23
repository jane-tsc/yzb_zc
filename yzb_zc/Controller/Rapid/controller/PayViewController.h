//
//  PayViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"
#import "WXApi.h"

@protocol PayViewControllerDelagate <NSObject>

-(void)wxPaywithType:(NSString *)Type;

@end

@interface PayViewController : BasicViewController

@property(nonatomic,copy) NSString *Nactitle;

@property(nonatomic,copy) NSString *Payprice;

@property(nonatomic, strong) NSDictionary *data;

@property(nonatomic, strong) NSMutableArray *ListArray;

@property(nonatomic, strong) NSDictionary *Dictionary;

@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) UIImage *image;

@property(nonatomic, copy) NSString *payType;

@property(nonatomic, copy) NSString *rapType;

@property(nonatomic, copy) NSString *NoywjType;

@property(nonatomic, copy) NSString *ywjType;

@property (retain,nonatomic) id <PayViewControllerDelagate> Delegate;



@end
