//
//  ArchiveViewCell.m
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/7.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ArchiveViewCell.h"

@implementation ArchiveViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.image = [UIImageView new];
        self.fileimage = [UIImageView new];
        self.fileimagetype = [UIImageView new];
        
        self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  50, 29, 22, 22)];
        [self.contentView addSubview:self.RigthImg];
        
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:screen_width / 24];
        self.name.textColor = [UIColor darkGrayColor];
        
        self.dirName = [UILabel new];
        self.dirName.font = [UIFont systemFontOfSize:screen_width / 24];
        self.dirName.textColor = [UIColor darkGrayColor];
        
        self.version = [UILabel new];
        self.version.textColor = TEXTcolor;
        self.version.font = [UIFont systemFontOfSize:screen_width / 28];
        
        self.time = [UILabel new];
        self.time.textColor = TEXTcolor;
        self.time.font = [UIFont systemFontOfSize:screen_width / 24];
        
        self.dirTime = [UILabel new];
        self.dirTime.textColor = TEXTcolor;
        self.dirTime.font = [UIFont systemFontOfSize:screen_width / 24];
        
        ///试用按钮
        self.lableTrial = [UILabel new];
//        beizhu = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 50, 20)];
        self.lableTrial.textAlignment = NSTextAlignmentCenter;
        self.lableTrial.textColor = [UIColor whiteColor];
        self.lableTrial.font =[UIFont systemFontOfSize:screen_width / 28];
     
        
        self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.retryButton];
        [self.retryButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 46);
            make.top.equalTo(20);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        self.baoquan = [UILabel new];
        self.baoquan.textColor = RGB(176, 196, 253);
        self.baoquan.font = [UIFont boldSystemFontOfSize:screen_width / 28];
        self.baoquan.textAlignment = NSTextAlignmentRight;
        
        self.baoquanSuccess = [UILabel new];
        self.baoquanSuccess.textColor = RGB(176, 196, 253);
        self.baoquanSuccess.font = [UIFont boldSystemFontOfSize:screen_width / 28];
        self.baoquanSuccess.textAlignment = NSTextAlignmentRight;
        
        
        self.baoquanNum = [UILabel new];
        self.baoquanNum.textColor = RGB(176, 196, 253);
        self.baoquanNum.font = [UIFont boldSystemFontOfSize:screen_width / 28];
        self.baoquanNum.textAlignment = NSTextAlignmentRight;
        
        self.save = [[UILabel alloc]init];
        self.save.font = [UIFont systemFontOfSize:screen_width / 28];
        self.save.textAlignment = NSTextAlignmentCenter;
        
        
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.fileimage];
        [self.contentView addSubview:self.fileimagetype];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.version];
        [self.contentView addSubview:self.retryButton];
        [self.contentView addSubview:self.baoquan];
        [self.contentView addSubview:self.baoquanNum];
        [self.contentView addSubview:self.save];
        [self.contentView addSubview:self.dirName];
        [self.contentView addSubview:self.dirTime];
        [self.contentView addSubview:self.baoquanSuccess];
        [self.contentView addSubview:self.lableTrial];
        
        
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(21);
            make.top.equalTo(21);
            make.width.equalTo(45);
            make.height.equalTo(45);
        }];
        
        [self.fileimage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(18);
            make.top.equalTo(21);
            make.width.equalTo(45);
            make.height.equalTo(45);
        }];
        
        [self.fileimagetype makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(-7);
            make.top.equalTo(self.image.bottom).offset(-7);
            make.width.equalTo(17);
            make.height.equalTo(18);
        }];
        
        
        [self.name makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(19);
//            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(15);
        }];
        
        ///试用字体
        [self.lableTrial makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.right).offset(3);
            make.top.equalTo(19);
            make.width.equalTo(50);
            make.height.equalTo(15);
        }];
        
        
        [self.dirName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(16);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(20);
        }];
        
        [self.dirTime makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(self.dirName.bottom).offset(5);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(20);
        }];
        
        [self.time makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(self.version.bottom).offset(4);
//            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(15);
        }];
        [self.version makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(15);
            make.top.equalTo(self.name.bottom).offset(4);
            make.width.equalTo(screen_width / 2 + 50);
            make.height.equalTo(15);
        }];
        
        
        
        
        [self.baoquan makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 75);
            make.top.equalTo(self.retryButton.bottom).offset(5);
            make.width.equalTo(50);
            make.height.equalTo(20);
        }];
        
        
        [self.baoquanSuccess makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 75);
            make.top.equalTo(0);
            make.width.equalTo(50);
            make.height.equalTo(80);
        }];
        
        
        [self.baoquanNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 90);
            make.top.equalTo(self.baoquan.bottom).offset(-25);
            make.width.equalTo(50);
            make.height.equalTo(15);
        }];
        
        [self.save makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.time.right);
            make.top.equalTo(self.version.bottom).offset(4);
            make.width.equalTo(50);
            make.height.equalTo(16);
        }];
        
    }
    
    return self;
}

@end
