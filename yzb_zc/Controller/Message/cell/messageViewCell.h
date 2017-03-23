//
//  messageViewCell.h
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface messageViewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *time;

@property(nonatomic, strong) UIView *view;
@end
