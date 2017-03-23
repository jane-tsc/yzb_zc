//
//  WLZShareController.h
//  WLZShareView
//
//  Created by lijiarui on 15/11/11.
//  Copyright © 2015年 lijiarui qq:81995383. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLZBlockButton.h"
#import "Public.h"
@interface WLZShareController : UIViewController




- (void)addItem:(NSString *)title icon:(NSString *)icon   block:(void (^)(WLZBlockButton *))block ;


-(void)show;

@end
