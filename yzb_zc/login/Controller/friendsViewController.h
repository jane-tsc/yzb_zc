//
//  friendsViewController.h
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"
#import "Public.h"

@protocol friendsViewControllerDelagate <NSObject>

-(void)friendspassTrendValues:(NSString *)values;

@end


@interface friendsViewController : BasicViewController


@property (retain,nonatomic) id <friendsViewControllerDelagate> Delegate;

@end
