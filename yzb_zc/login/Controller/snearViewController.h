//
//  snearViewController.h
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"
#import "Public.h"

@protocol snearViewControllerDelagate <NSObject>

-(void)passTrendValues:(NSString *)values;

@end

@interface snearViewController : BasicViewController

@property (retain,nonatomic) id <snearViewControllerDelagate> Delegate;

@end
