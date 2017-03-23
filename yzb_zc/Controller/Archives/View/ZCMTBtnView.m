//
//  ZCMTBtnView.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ZCMTBtnView.h"

@implementation ZCMTBtnView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageStr:(NSString *)imageStr{
    self = [super initWithFrame:frame];
    if (self) {
        //
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/10, 20, frame.size.width/1.3 + 3, frame.size.width/1.3 - 7)];
        imageView.image = [UIImage imageNamed:imageStr];
        [self addSubview:imageView];
        
        //
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height + 20, frame.size.width, 20)];
        titleLable.text = title;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:13];
        titleLable.textColor = [UIColor darkGrayColor];
        [self addSubview:titleLable];
    }
    return self;
}

@end
