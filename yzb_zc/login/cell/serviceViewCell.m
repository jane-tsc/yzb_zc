//
//  serviceViewCell.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "serviceViewCell.h"

@implementation serviceViewCell

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
    
    self.phoneNumber = [UILabel new];
    self.phoneNumber.textColor = [UIColor darkGrayColor];
    self.phoneNumber.font = [UIFont systemFontOfSize:14];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton setImage:[UIImage imageNamed:@"call_nor.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.phoneButton];
    [self.phoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width - 40);
        make.top.equalTo(25);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.Image];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.phoneNumber];
    
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
    
    [self.phoneNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Image.right).offset(15);
        make.top.equalTo(self.title.bottom).offset(10);
        make.width.equalTo(screen_width -20);
        make.height.equalTo(15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
