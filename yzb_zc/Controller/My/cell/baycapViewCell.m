//
//  baycapViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/7/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "baycapViewCell.h"
#define CELLHEIFGT 55
@implementation baycapViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lable1 = [UILabel new];
        _lable1.textColor              = [UIColor darkGrayColor];
        _lable1.font                   = [UIFont systemFontOfSize:screen_width / 24];
        _lable1.textAlignment          = NSTextAlignmentLeft;
        [self addSubview:_lable1];
        [_lable1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(30);
            make.height.equalTo(CELLHEIFGT);
            make.top.equalTo(0);
            make.width.equalTo(110);
        }];

        _lable2 = [UILabel new];
        _lable2.textColor              = [UIColor darkGrayColor];
        _lable2.font                   = [UIFont systemFontOfSize:screen_width / 24];
        _lable2.textAlignment          = NSTextAlignmentLeft;
        [self addSubview:_lable2];
        [_lable2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lable1.right).offset(10);
            make.height.equalTo(CELLHEIFGT);
            make.top.equalTo(0);
            make.width.equalTo(100);
        }];
        
        _buybtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buybtn2 setTitleColor:RGB(254, 185, 187) forState:UIControlStateNormal];
        _buybtn2.titleLabel.font = [UIFont systemFontOfSize:13];
        _buybtn2.layer.cornerRadius = 3.0;
        _buybtn2.layer.masksToBounds = YES;
        _buybtn2.layer.borderWidth = 1.0;
        _buybtn2.layer.borderColor = RGB(254, 185, 187).CGColor;
        [self addSubview:_buybtn2];
        [_buybtn2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 85);
            make.top.equalTo(17.5);
            make.width.equalTo(60);
            make.height.equalTo(20);
        }];
        
        
    }
    return self;
}

@end
