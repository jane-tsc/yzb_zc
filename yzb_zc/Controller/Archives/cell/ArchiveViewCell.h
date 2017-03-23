//
//  ArchiveViewCell.h
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/7.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface ArchiveViewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *image;///
@property(nonatomic, strong) UIImageView *fileimage;///
@property(nonatomic, strong) UIImageView *fileimagetype;///
@property(nonatomic, strong) UILabel *name;///
@property(nonatomic, strong) UILabel *time;///
@property(nonatomic, strong) UILabel *num;///
@property(nonatomic, strong) UILabel *version;///
@property(nonatomic, strong) UILabel *baoquan;///
@property(nonatomic, strong) UILabel *baoquanSuccess;///
@property(nonatomic, strong) UILabel *baoquanNum;///
@property(nonatomic, strong) UILabel *save;///

@property (nonatomic, strong) UIButton *retryButton;///

@property(nonatomic, strong) UILabel *dirName;///
@property(nonatomic, strong) UILabel *dirTime;///

@property(nonatomic, strong) UIImageView *RigthImg;

@property(nonatomic, strong) UILabel *lableTrial;///试用字体

@property(nonatomic, copy) NSString *nameString;


@end
