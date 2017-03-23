//
//  FordetailsViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface FordetailsViewCell : UITableViewCell
- (void)initWithIndexpath:(NSIndexPath *)indexpath;


@property (nonatomic, strong) UILabel *beianNum;
@property (nonatomic, strong) UILabel *danganName;
@property (nonatomic, strong) UILabel *baoquanType;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *phone;

@property (nonatomic, strong) UILabel *addressArea;
@property (nonatomic, strong) UILabel *addressDetail;

@property (nonatomic, strong) UILabel *cailiao1;

@property (nonatomic, strong) UIButton *Modifybtn;


@end
