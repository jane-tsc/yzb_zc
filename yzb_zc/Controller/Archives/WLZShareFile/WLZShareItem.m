//
//  WLZShareItem.m
//  WLZShareView
//
//  Created by lijiarui on 15/11/11.
//  Copyright © 2015年 lijiarui qq:81995383. All rights reserved.
//

#import "WLZShareItem.h"

@implementation WLZShareItem


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self subviewsInit];
    }
    return self;
}

- (void)subviewsInit
{
    _logoImageView = [[UIImageView alloc]init];
    
    
    _logoImageView.backgroundColor = [UIColor clearColor];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _itemButton = [[WLZBlockButton alloc]init];
      _itemButton.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setUpViews];
}


- (void)setUpViews
{
    _logoImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width-20);
    
    _logoImageView.contentMode =  UIViewContentModeCenter;

    [self addSubview:_logoImageView];
    
    _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_logoImageView.frame), self.frame.size.width, 20);


    [self addSubview:_titleLabel];
    
    
    _itemButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  

    [self addSubview:_itemButton];
    [self bringSubviewToFront:_itemButton];
}




@end
