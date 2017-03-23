//
//  QKYMyTitleView.m
//  qikeyun
//
//  Created by 马超 on 16/5/30.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import "QKYMyTitleView.h"

@interface QKYMyTitleView ()
@property (nonatomic,strong,nonnull)UILabel *titleLabel;
@property (nonatomic,strong,nonnull)UILabel *subTitleLabel;
@property (nonatomic,strong,nonnull)UIImageView *arrowView;
@end

@implementation QKYMyTitleView
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(MyTitleViewType)type extend:(id)extend
{
    self = [super init];
    
    if (self) {
        
        _title = title;
        _subTitle = subTitle;
        _type = type;
        _extend = extend;
        
        _bgColor = [UIColor whiteColor];
        _titleColor = [UIColor blackColor];
        _subTitleColor = [UIColor darkGrayColor];
        _titleFont = [UIFont systemFontOfSize:16.0];
        _subTitleFont = [UIFont systemFontOfSize:14.0];
        
        [self setupViews];
    }
    
    return self;
}

#pragma mark - setter
- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    
    self.backgroundColor = bgColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    self.titleLabel.textColor = titleColor;
}

- (void)setSubTitleColor:(UIColor *)subTitleColor
{
    _subTitleColor = subTitleColor;
    
    self.subTitleLabel.textColor = subTitleColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    self.titleLabel.font = titleFont;
}

-  (void)setSubTitleFont:(UIFont *)subTitleFont
{
    _subTitleFont = subTitleFont;
    
    self.subTitleLabel.font = subTitleFont;
}

#pragma mark - set up views
- (void)setupViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = _titleFont;
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = _subTitleFont;
    [self addSubview:self.subTitleLabel];
    
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage imageNamed:@"search_white"];
    [self addSubview:self.arrowView];
    
    if (_type == MyTitleViewTypeDefault) {
        
        self.subTitleLabel.hidden = YES;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self adjustLayout];
}

/**
 *  根据内容调整位置
 */
- (void)adjustLayout
{
    //计算文本的长度
    CGFloat arrowW = 10.0;
    CGFloat arrowH = arrowW;
    CGFloat magrin = 5;
    
    CGFloat contentMaxW = self.frame.size.width - magrin * 3 - arrowW; ///文本的最大宽度
    

    NSMutableDictionary *contentdic = [NSMutableDictionary dictionary];
    contentdic[NSFontAttributeName] = _titleFont;
    
    CGRect rect = [_title boundingRectWithSize:CGSizeMake(contentMaxW, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentdic context:nil];
    
    CGFloat totalW = rect.size.width + magrin + arrowW; /// 文本和箭头总的宽度
    
    CGFloat leftMagrin = (self.bounds.size.width - totalW) * 0.5;
    
    if ( _type == MyTitleViewTypeDefault) {
        
         self.titleLabel.frame = CGRectMake(leftMagrin, 0, rect.size.width, self.bounds.size.height );
    }
    else if (_type == MyTitleViewTypeTitleAndTime) {
        
         self.titleLabel.frame = CGRectMake(leftMagrin, 0, rect.size.width, self.bounds.size.height * 0.5);
    }
   
    self.arrowView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+ magrin, (self.bounds.size.height - arrowH) / 2, arrowW, arrowH);
    
    
    
    {
        NSMutableDictionary *contentdic = [NSMutableDictionary dictionary];
        contentdic[NSFontAttributeName] = _subTitleFont;
        
        CGRect rect = [_subTitle boundingRectWithSize:CGSizeMake(contentMaxW, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentdic context:nil];
        
        CGFloat totalW1 = rect.size.width + magrin + arrowW; /// 文本和箭头总的宽度
        
        CGFloat leftMagrin = (self.bounds.size.width - totalW1) * 0.5;
        
        self.subTitleLabel.frame = CGRectMake(leftMagrin, CGRectGetMaxY(self.titleLabel.frame), rect.size.width, self.bounds.size.height * 0.5);
        
        if (totalW1 > totalW) {
            
            self.arrowView.frame = CGRectMake(CGRectGetMaxX(self.subTitleLabel.frame)+ magrin, (self.bounds.size.height - arrowH) / 2, arrowW, arrowH);
        }
    }
   
    
    
    
    self.titleLabel.text = _title;
    self.subTitleLabel.text = _subTitle;
    
}

- (void)updateWithTitle:(NSString *)title subTitle:(NSString *)subTitle extend:(id)extend
{
    _title = title;
    _subTitle = subTitle;
    _extend = extend;
    
    [self adjustLayout];
}


#pragma mark --------------- 点击方法 ----------------
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.clickedBlock) {
        self.clickedBlock(self.extend);
    }
}
@end
