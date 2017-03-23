//
//  PayViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "PayViewCell.h"

@implementation PayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        ///=========================微信支付
        
        UIView *weixin = [[UIView alloc]init];
        [self addSubview:weixin];
        [weixin makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(screen_width);
            make.height.equalTo(75);
        }];
        
        ///wx_pay@2x.png  yhk_pay@2x.png   zfb_pay@2x.png
        
        self.weixinImg = [[UIImageView alloc]init];
        [weixin addSubview: self.weixinImg];
        [ self.weixinImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(weixin.top).offset(20);
            make.width.equalTo(weixin.height).offset(-37);
            make.height.equalTo(weixin.height).offset(-37);
        }];
        
        self.weixinLable = [[UILabel alloc]init];
        self.weixinLable.textAlignment = NSTextAlignmentLeft;
        self.weixinLable.textColor = [UIColor blackColor];
        self.weixinLable.font = [UIFont systemFontOfSize:15];
        [weixin addSubview:self.weixinLable];
        [self.weixinLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.weixinImg.right).offset(10);
            make.top.equalTo(weixin.top).offset(15);
            make.width.equalTo(weixin.width).offset( - 120);
            make.height.equalTo(20);
        }];
        
        self.weixinLable1 = [[UILabel alloc]init];
        self.weixinLable1.textAlignment = NSTextAlignmentLeft;
        self.weixinLable1.textColor = [UIColor blackColor];
        self.weixinLable1.font = [UIFont systemFontOfSize:13];
        [weixin addSubview:self.weixinLable1];
        [self.weixinLable1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.weixinImg.right).offset(10);
            make.top.equalTo(self.weixinLable.bottom).offset(5);
            make.width.equalTo(weixin.width).offset( - 120);
            make.height.equalTo(20);
        }];
        ///unchoose@2x.png    choose@2x.png
//        self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
//        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateSelected];
//        self.checkBtn.selected = YES;
//        [weixin addSubview:self.checkBtn];
//        [self.checkBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.weixinLable.right).offset(15);
//            make.top.equalTo(30);
//            make.width.equalTo(15);
//            make.height.equalTo(15);
//        }];
//        
//        [self.checkBtn addTarget:self action:@selector(onSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)onSelectButton:(UIButton *)button{
    
   
    //        NSLog(@"您选中了微信支付");
    
//    [_delegate obtainButtonWithSelectButton:button];
//    
//    NSInteger tap = button.tag;
//    
//    if (button.tag == _selectIndex) {
//        
//        UIButton * buttons       = (UIButton *)[_checkBtn viewWithTag:_selectIndex];
//        
//        buttons.selected         = buttons.tag == button.tag ? YES : NO;
//        
//                  if (button.tag == _selectIndex) {
//        
//                      button.selected = NO;
//                   }else{
//                       button.selected = YES;
//                }
//    }
    
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    
     //(UIButton *)[_checkBtn viewWithTag:_selectIndex] = selectIndex;
    
}




@end
