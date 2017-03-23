//
//  senarViewCell.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "senarViewCell.h"

@implementation senarViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configeSubViews];
    }
    return self;
    
}

- (void)configeSubViews{

    self.Image = [UIImageView new];
    self.Image.backgroundColor = [UIColor orangeColor];
    self.Image.layer.cornerRadius = 20;
    self.Image.layer.masksToBounds = YES;
    
    self.title = [UILabel new];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textColor = [UIColor darkGrayColor];
    
    self.address = [UILabel new];
    self.address.textColor = [UIColor darkGrayColor];
    self.address.font = [UIFont systemFontOfSize:14];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton setImage:[UIImage imageNamed:@"call_nor.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.phoneButton];
    [self.phoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 40);
        make.top.equalTo(25);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];

    self.Num = [UILabel new];
    self.Num.font = [UIFont systemFontOfSize:11];
    self.Num.textColor = RGB(159, 182, 232);

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.Image];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.address];
    [self.contentView addSubview:self.Num];
    
    [self.Image makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(20);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Image.right).offset(15);
        make.top.equalTo(20);
        make.width.equalTo(screen_width -20);
        make.height.equalTo(15);
    }];
    
    [self.address makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Image.right).offset(15);
        make.top.equalTo(self.title.bottom).offset(10);
        make.width.equalTo(screen_width -20);
        make.height.equalTo(15);
    }];
    
    [self.Num makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 40);
        make.top.equalTo(self.phoneButton.bottom).offset(5);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
}


@end
