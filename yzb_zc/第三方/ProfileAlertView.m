//
//  ProfileAlertView.m
//  CRWB
//
//  Created by CR-IOS on 16/7/25.
//  Copyright © 2016年 CR-IOS. All rights reserved.
//

#import "ProfileAlertView.h"

@implementation ProfileAlertView
- ( instancetype )initWithFrame:(CGRect)frame withGroupNumber:(NSInteger) num{
    self = [super initWithFrame:frame];
    if (self) {
        
        _alertView = [[UIView alloc] init];
        [self addSubview:_alertView];
        _alertView.layer.cornerRadius = 6.0;
        _alertView.center = self.center;
        _alertView.frame = CGRectMake((ScreenWidth - 280)/2, (ScreenHeight - 130)/2, 280, 130);
        _alertView.backgroundColor = [UIColor whiteColor];

        _messageLabel = [[UILabel alloc] init];
        [_alertView addSubview:_messageLabel];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont systemFontOfSize:ScreenWidth / 24];
        _messageLabel.text = [NSString stringWithFormat:@"为了您的数据安全，请开启安全验证"];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 2; //最多显示两行Message
        _messageLabel.frame = CGRectMake(5, CGRectGetMaxY(_operateLabel.frame) + 5, _alertView.frame.size.width - 20, 44);
        
        
        
        _setChatButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_messageLabel.frame) + 5, 20, 20)];
        [_alertView addSubview:_setChatButton];
        [_setChatButton setImage:[UIImage imageNamed:@"矩形-33"] forState:UIControlStateNormal];
        [_setChatButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(_alertView.frame.size.width / 2 - 100, CGRectGetMaxY(_messageLabel.frame) + 5, 110, 20)];
        [_alertView addSubview:_chatLabel];
        _chatLabel.text = @"不再提醒";
        _chatLabel.font = [UIFont systemFontOfSize:14];
        
        //创建中间灰色分割线
        UIView * separateBottomLine = [[UIView alloc] init];
        separateBottomLine.backgroundColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1];
        [_alertView addSubview:separateBottomLine];
        separateBottomLine.frame = CGRectMake(0, CGRectGetMaxY(_chatLabel.frame) + 10, _alertView.bounds.size.width, 0.5);
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(separateBottomLine.frame) + 2, _alertView.frame.size.width / 2, 45)];
        [_alertView addSubview:_cancelButton];
        [_cancelButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:ScreenWidth / 24];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.tag = 0;
        _cancelButton.layer.cornerRadius = 6;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(_alertView.bounds.size.width/2, CGRectGetMaxY(separateBottomLine.frame) + 2, _alertView.frame.size.width / 2, 45)];
        [_alertView addSubview:_confirmButton];
        _confirmButton.tag = 1;
        [_confirmButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:ScreenWidth / 24];
        [_confirmButton setTitle:@"前往设置" forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 6;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setBackgroundColor:[UIColor whiteColor]];
        [_confirmButton addTarget:self action:@selector(didClickBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        //创建中间灰色分割线
        UIView * mLine = [[UIView alloc] init];
        mLine.backgroundColor = [UIColor grayColor];
        [_alertView addSubview:mLine];
        mLine.frame = CGRectMake(_alertView.bounds.size.width / 2,  CGRectGetMaxY(separateBottomLine.frame) + 5, 0.5, 40);
        
    }
    return self;

}


- (void) selectButtonClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"矩形-33"] forState:UIControlStateNormal];
        
    }else{
        [btn setImage:[UIImage imageNamed:@"矩形-34"] forState:UIControlStateNormal];
    }
}
- (void) didClickBtnCancel:(UIButton *)btn {

    [self.delegate conqianwangshezClickButton];
    
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}
- (void) didClickBtnConfirm:(UIButton *)btn {
    
    if (_setChatButton.selected) {
        [self.delegate confirmButtonDidCilckedIsSetChat:YES];
    }else{
        [self.delegate confirmButtonDidCilckedIsSetChat:NO];
    }
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}
@end
