//
//  addressViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface addressViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *shen;
@property(nonatomic, strong) UILabel *shi;
@property(nonatomic, strong) UILabel *xian;
@property(nonatomic, strong) UIImageView *RigthImg;

- (void)configWithindexPath:(NSIndexPath *)indexPath;


@end
