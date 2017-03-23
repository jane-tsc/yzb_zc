//
//  MobleViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "MobleViewCell.h"

@implementation MobleViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.image = [UIImageView new];
        
        
        self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  45, 29, 22, 22)];
        [self.contentView addSubview:self.RigthImg];
        
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:screen_width / 24];
        self.name.textColor = [UIColor darkGrayColor];

        self.time = [UILabel new];
        self.time.textColor = TEXTcolor;
        self.time.font = [UIFont systemFontOfSize:screen_width / 24];
        
        
        [self.contentView addSubview:self.RigthImg];
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.time];
        
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(21);
            make.top.equalTo(21);
            make.width.equalTo(37);
            make.height.equalTo(37);
        }];
        
        [self.name makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(19);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(15);
        }];
        
        [self.time makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(self.name.bottom).offset(10);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(15);
        }];

    }
    return self;
}
@end
