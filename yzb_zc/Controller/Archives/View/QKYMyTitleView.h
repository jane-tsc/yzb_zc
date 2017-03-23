//
//  QKYMyTitleView.h
//  qikeyun
//
//  Created by 马超 on 16/5/30.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MyTitleViewType) {
    MyTitleViewTypeDefault,
    MyTitleViewTypeTitleAndTime,
};

@interface QKYMyTitleView : UIView

/**
 *  标题
 */
@property (nonatomic,copy,readonly,nullable)NSString *title;

/**
 *  子标题
 */
@property (nonatomic,copy,readonly,nullable)NSString *subTitle;

/**
 *  类型
 */
@property (nonatomic,assign,readonly)MyTitleViewType type;

/**
 *  可携带任何数据的扩展
 */
@property (nonatomic,strong,readonly,nullable)id extend;

/**
 *  实例方法
 *
 *  @param title    标题
 *  @param subTitle 子标题
 *  @param type     类型
 *
 *  @return 本身实例
 */
- (instancetype)initWithTitle:(NSString * _Nullable)title subTitle:(NSString * _Nullable)subTitle type:(MyTitleViewType)type extend:(id)extend;



/* ----------------------  下边的属性 可用来更新UI  -------------------------- */

/**
 *  跟新内容
 */
- (void)updateWithTitle:(NSString * _Nullable)title subTitle:(NSString * _Nullable)subTitle extend:(id)extend;

/**
 *  背景色 ，默认是白色
 */
@property (nonatomic,strong,nullable)UIColor *bgColor;

/**
 *  标题颜色 默认黑色
 */
@property (nonatomic,strong,nullable)UIColor *titleColor;

/**
 *  子标题颜色 默认黑色
 */
@property (nonatomic,strong,nullable)UIColor *subTitleColor;

/**
 *  标题 文字大小
 */
@property (nonatomic,strong,nullable)UIFont *titleFont;

/**
 *  子标题文字大小
 */
@property (nonatomic,strong,nullable)UIFont *subTitleFont;


/**
 *  点击的回调
 */
@property (nonatomic,nullable,strong)void(^clickedBlock)(id _Nullable);
@end

NS_ASSUME_NONNULL_END