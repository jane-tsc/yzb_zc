//
//  WLZShareController.m
//  WLZShareView
//
//  Created by lijiarui on 15/11/11.
//  Copyright © 2015年 lijiarui qq:81995383. All rights reserved.
//

#import "WLZShareController.h"
#import "WLZShareItem.h"
//static CGFloat itemWidth = 80.0f;
static CGFloat itemHeight = 80.0f;
static NSInteger itemCount = 4.0f;

//子元素的边距
static CGFloat boardWidth = 10.0f;
//子元素的边距
static CGFloat boardHeight = 10.0f;

//距离父view的边距 x
static CGFloat marginX = 10.0f;
//距离父view的边距 y
static CGFloat marginY = 20.0f;

//背景alpha值
static CGFloat viewAlpha =  0.6f;


//底部BT的高度
static CGFloat endBtHeight = 35.0f;
@interface WLZShareController ()


@property(nonatomic,strong)NSMutableArray *array_items;


@property (nonatomic, strong) UIView *contentView;

@property(nonatomic,strong) UIView *darkView;
@property(nonatomic,strong) UIView *buttonView;


@end

@implementation WLZShareController



- (instancetype)init
{
    self = [super init];
    if ( self) {
        self.view.frame =[UIScreen mainScreen].bounds;
        
        [self setUpViews];
    }
    return self;
}

- (NSMutableArray *)array_items
{
    if (!_array_items) {
        _array_items =[NSMutableArray array];
    }
    return _array_items;
}

- (void)addItem:(NSString *)title icon:(NSString *)icon block:(void (^)(WLZBlockButton *))block
{
    WLZShareItem *item = [[WLZShareItem alloc]init];
    [item.itemButton setBlock:^(WLZBlockButton *button){
        block(button);
        [self removeView];
    }];
  
    item.logoImageView.image = [UIImage imageNamed:icon];
    item.titleLabel.text = title;
    [self.contentView addSubview:item];
    [self.array_items addObject:item];
}

 - (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)setUpViews
{
    CGRect frame =CGRectMake(0, 64, screen_width, screen_height - 64);
    ///給分类按钮区域加个点击事件
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
//    _buttonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_buttonView];
    
    _darkView = [[UIView alloc] initWithFrame:frame];
    _darkView.backgroundColor = [UIColor blackColor];
    _darkView.userInteractionEnabled=YES;
    _darkView.alpha = viewAlpha;
    [self.view addSubview:_darkView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheDarkView)];
    [_darkView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheDarkView)];
    [_buttonView addGestureRecognizer:tap1];

}

- (void)tapTheDarkView
{
    [UIView animateWithDuration:0.3 animations:^{
       
        _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeView];
    }];
}

- (void)removeView
{
    
    for (UIView *views in self.view.subviews) {
        [views removeFromSuperview];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)show
{
    CGFloat itemWidth =(self.view.frame.size.width-((itemCount-1)*boardWidth)-(marginX*2))/itemCount;
    CGFloat height = 0;
    CGFloat rows = _array_items.count/itemCount +( (_array_items.count%itemCount) != 0 ?1:0);
    height = rows*itemHeight + rows*marginY;
    for (int i=0; i<_array_items.count; i++) {
        CGFloat x = (i%itemCount)*(itemWidth+boardWidth)+marginX;
        CGFloat y = floor(i/itemCount)*(itemHeight+boardHeight)+marginY;
        WLZShareItem *item =(WLZShareItem *) [_array_items objectAtIndex:i];
        item.frame = CGRectMake(x, y, itemWidth, itemHeight);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = CGRectMake(0, 64, self.view.frame.size.width, height+endBtHeight - 35);
    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

@end
