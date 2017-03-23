//
//  rapidViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface rapidViewCell : UITableViewCell<UITextFieldDelegate>


@property (nonatomic,strong)UIImageView *heading;
@property (nonatomic,strong)UIImageView *imgType;

@property (nonatomic,strong)UILabel *title;

@property (nonatomic,strong)UILabel *megaNum;

@property (nonatomic,strong)UILabel *pricecell;

@property (nonatomic,strong)UITextField *zhengshuName;

@property (nonatomic,strong) UIButton *checkBtn;

@property (nonatomic,strong) UIButton *forkBtn;

@property (nonatomic, assign) BOOL isSelected;


@end
