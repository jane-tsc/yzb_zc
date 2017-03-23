//
//  securViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface securViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *password;
@property(nonatomic, strong) UILabel *fingerprint;

@property(nonatomic, strong) UILabel *shanchu;
@property(nonatomic, strong) UILabel *chuzhen;
@property(nonatomic, strong) UILabel *xiazai;
@property(nonatomic, strong) UILabel *yuanwenjianshanchu;

@property(nonatomic, strong) UIImageView *RigthImg;

- (void)configWithindexPath:(NSIndexPath *)indexPath;
@end
