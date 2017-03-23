//
//  messageViewCell.m
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "messageViewCell.h"

@implementation messageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setViewconment];
    }
    return self;
}

- (void)setViewconment{
 
    self.image = [[UIImageView alloc]init];
    self.image.layer.cornerRadius = self.image.frame.size.width;
    self.image.layer.masksToBounds = YES;
    
    self.name = [[UILabel alloc]init];
    self.name.textColor = [UIColor darkGrayColor];
    self.name.font = [UIFont systemFontOfSize:screen_width / 24];
    
    self.time = [[UILabel alloc]init];
    self.time.textColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.5];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.font = [UIFont systemFontOfSize:screen_width / 29];
    
    
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = RGB(249, 253, 255);
    self.view.frame = CGRectMake(0, 0, screen_width, 15);
    [self.contentView addSubview:self.view];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.time];

    [self.image makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.top).offset(20);
        make.width.equalTo(screen_width / 10);
        make.height.equalTo(screen_width / 10);
    }];

    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.right).offset(10);
        make.top.equalTo(self.top).offset(28);
        make.width.equalTo(screen_width - 50);
        make.height.equalTo(20);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.right).offset(-120);
        make.top.equalTo(self.top).offset(30);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    
    
}


@end
