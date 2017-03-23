//
//  PayWcViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "PayWcViewCell.h"

@implementation PayWcViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
 
        self.image = [UIImageView new];
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        self.image.layer.cornerRadius = 20;
        self.image.layer.masksToBounds = YES;
        
        
        self.imgType = [UIImageView new];
        [self addSubview:self.imgType];
        [self.imgType makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(-13);
            make.top.equalTo(self.image.bottom).offset(-13);
            make.width.equalTo(20);
            make.height.equalTo(18);
        }];

        self.title = [UILabel new];
        self.title.textColor = [UIColor darkGrayColor];
        self.title.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.title];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(20);
            make.top.equalTo(self.top).offset(15);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(18);
        }];
        
        self.endBB = [UILabel new];
        self.endBB.textColor =TEXTcolor;
        self.endBB.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.endBB];
        [self.endBB makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(20);
            make.top.equalTo(self.title.bottom).offset(7);
            make.width.equalTo(screen_width - 180);
            make.height.equalTo(10);
        }];
        
        self.time = [UILabel new];
        self.time.textColor =TEXTcolor;
        self.time.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.time];
        [self.time makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(20);
            make.top.equalTo(self.endBB.bottom).offset(0);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
        
        self.num = [UILabel new];
        self.num.textColor =RGB(150, 177, 236);
        self.num.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.num];
        [self.num makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.right).offset( -45);
            make.top.equalTo(self.top).offset(20);
            make.width.equalTo(70);
            make.height.equalTo(20);
        }];
        
        self.typeNum = [UILabel new];
        self.typeNum.textColor =RGB(150, 177, 236);
        self.typeNum.textAlignment = NSTextAlignmentRight;
        self.typeNum.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.typeNum];
        [self.typeNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.right).offset( -85);
            make.top.equalTo(self.num.bottom);
            make.width.equalTo(70);
            make.height.equalTo(15);
        }];
        
        
        self.csBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.csBtn];
        [self.csBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 45);
            make.top.equalTo(15);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];

        
    }
    return self;
}


@end
