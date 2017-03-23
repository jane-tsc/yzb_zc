//
//  spreadsViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/7/8.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "spreadsViewCell.h"

@implementation spreadsViewCell

- (void)configeWithIndexPath:(NSIndexPath *)indexPath withdic1:(NSMutableDictionary *)dic{

    self.image = [[UIImageView alloc]init];
    [self addSubview:self.image];
    [self.image makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(16);
        make.width.equalTo(15);
        make.height.equalTo(15);
    }];
    
    self.title = [UILabel new];
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont systemFontOfSize:screen_width / 28];
    [self addSubview:self.title];
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.right).offset(20);
        make.top.equalTo(0);
        make.height.equalTo(self.height);
    }];
    
            self.titleConunt1 = [UILabel new];
            self.titleConunt1.textColor = [UIColor whiteColor];
            self.titleConunt1.font = [UIFont systemFontOfSize:screen_width / 28];
            self.titleConunt1.textAlignment = NSTextAlignmentRight;
            [self addSubview:self.titleConunt1];
            [self.titleConunt1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.title.right).offset(20);
                make.top.equalTo(0);
                make.height.equalTo(self.height);
            }];
  
    
            self.titleConunt2 = [UILabel new];
            self.titleConunt2.textColor = [UIColor whiteColor];
            self.titleConunt2.textAlignment = NSTextAlignmentRight;
            self.titleConunt2.font = [UIFont systemFontOfSize:screen_width / 28];
            [self addSubview:self.titleConunt2];
            [self.titleConunt2 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.title.right).offset(20);
                make.top.equalTo(0);
                make.height.equalTo(self.height);
            }];

}

@end
