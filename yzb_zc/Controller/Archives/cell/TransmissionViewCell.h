//
//  TransmissionViewCell.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Public.h"
@interface TransmissionViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UIImageView *imgType;

@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *endBB;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UILabel *typeNum;


@end
