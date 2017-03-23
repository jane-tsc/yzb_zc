//
//  myViewCell.h
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *headimg;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *sex;
@property(nonatomic, strong) UILabel *idcar;
@property(nonatomic, strong) UILabel *phone;

@property(nonatomic, strong) UIImageView *RigthImg;

- (void)configWithindexPath:(NSIndexPath *)indexPath;

@end
