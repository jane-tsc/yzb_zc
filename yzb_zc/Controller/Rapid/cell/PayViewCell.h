//
//  PayViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"


@protocol PayViewCellDelegate <NSObject>

@optional

- (void)obtainButtonWithSelectButton:(UIButton *)button;

@end

@interface PayViewCell : UITableViewCell



@property (nonatomic,strong) UIButton *checkBtn;

@property (nonatomic,strong) UIImageView *weixinImg;

@property (nonatomic,strong) UILabel *weixinLable;

@property (nonatomic,strong) UILabel *weixinLable1;

@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,assign) id <PayViewCellDelegate> delegate;

@end
