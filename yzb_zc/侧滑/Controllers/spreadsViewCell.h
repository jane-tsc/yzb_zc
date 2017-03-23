//
//  spreadsViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/7/8.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface spreadsViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic ,strong) UILabel *title;
@property(nonatomic ,strong) UILabel *titleConunt1;
@property(nonatomic ,strong) UILabel *titleConunt2;
@property(nonatomic ,strong) UIButton *buybtn1;
@property(nonatomic ,strong) UIButton *buybtn2;
- (void)configeWithIndexPath:(NSIndexPath *)indexPath withdic1:(NSMutableDictionary *)dic;

@end
