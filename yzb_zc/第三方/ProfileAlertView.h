//
//  ProfileAlertView.h
//  CRWB
//
//  Created by CR-IOS on 16/7/25.
//  Copyright © 2016年 CR-IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol  confirmButtonClickDelegate <NSObject>

/* 取消按钮点击事件 */
- (void) confirmButtonDidCilckedIsSetChat:(BOOL) isChat ;
- (void) conqianwangshezClickButton;

@end

@interface ProfileAlertView : UIView



/* 创建提示框View */
@property (nonatomic, strong) UIView *alertView;
/* 提示Label */
@property (nonatomic,strong) UILabel *operateLabel;

@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIFont  *titleFont;

/* 消息Label */
@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UIColor *msgColor;
@property (nonatomic,strong) UIFont  *msgFont;
/* 发起聊天按钮 */
@property (nonatomic,strong) UIButton *setChatButton;
/* 发起聊天Label */
@property (nonatomic,strong) UILabel *chatLabel;
/* 取消按钮 */
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIColor  *cancelColor;

/* 确定 */
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIColor  *confirmColor;

@property (nonatomic,retain) id <confirmButtonClickDelegate> delegate;



- ( instancetype )initWithFrame:(CGRect)frame withGroupNumber:(NSInteger) num;


@end
