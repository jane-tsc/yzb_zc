//
//  UIViewAdditions.h
//  TTUI
//
//  Created by shaohua on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TTUI)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) UIColor *borderColor;

// The view controller whose view contains this view.
@property (nonatomic, readonly) UIViewController *viewController;

//when clicked, hidden the keyboard.
- (void)addHiddenKeyboardGesture;

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

+ (UIView *)tipViewWithFrame:(CGRect)frame text:(NSString *)text image:(UIImage *)image;

@end
