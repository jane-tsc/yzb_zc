//
//  rapidViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "rapidViewCell.h"

@implementation rapidViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *cellFenge = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
        cellFenge.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:cellFenge];
        
        self.heading = [UIImageView new];
        [self addSubview:self.heading];
        [self.heading makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(15);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        self.heading.layer.cornerRadius = 30;
        self.heading.layer.masksToBounds= YES;
        
        
        self.imgType = [UIImageView new];
        [self addSubview:self.imgType];
        [self.imgType makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.heading.right).offset(-13);
            make.bottom.equalTo(self.heading.bottom).offset(4);
            make.width.equalTo(20);
            make.height.equalTo(18);
        }];
        
    
        self.title = [UILabel new];
        
        self.title.textColor = [UIColor darkGrayColor];
        self.title.font = [UIFont systemFontOfSize:screen_width / 24];
        [self addSubview:self.title];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.heading.right).offset(14);
            make.top.equalTo(self.top).offset(11);
            make.right.equalTo(self.right).offset(-50);
        }];

        ///del_n@2x.png
        self.forkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.forkBtn setImage:[UIImage imageNamed:@"del_n.png"] forState:UIControlStateNormal];
        [self addSubview:self.forkBtn];
        [self.forkBtn makeConstraints:^(MASConstraintMaker * make) {
            make.right.equalTo(self.right);
            make.centerY.equalTo(self.title.centerY);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];

        
        
        ///bq_highlight@2x.png
        ///bq_nor@2x.png
        self.checkBtn.selected = NO;
        self.checkBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
        self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkBtn setImage:[UIImage imageNamed:@"nofuxuan.png"] forState:UIControlStateNormal];
        [self.checkBtn setImage:[UIImage imageNamed:@"fuxuan.png"] forState:UIControlStateSelected];
        [self addSubview:self.checkBtn];
        [self.checkBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.heading.right).offset(15);
            make.bottom.equalTo(self.bottom).offset(-10);
            make.width.equalTo(18);
            make.height.equalTo(18);
        }];
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"文件代管";
        lable.textColor = [UIColor darkGrayColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.font = [UIFont systemFontOfSize:screen_width / 26];
        [self addSubview:lable];
        [lable makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.checkBtn.right).offset(10);
            make.bottom.equalTo(self.bottom).offset(-10);
//            make.width.equalTo(60);
        }];
        
        self.megaNum = [UILabel new];
        self.megaNum.textColor =[UIColor darkGrayColor];
        self.megaNum.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.megaNum];
        [self.megaNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lable.right).offset(2);
            make.centerY.equalTo(self.checkBtn.centerY);
            make.width.equalTo(70);
        }];

        self.pricecell = [[UILabel alloc]init];
        self.pricecell.textColor = [UIColor blackColor];
        self.pricecell.font = [UIFont systemFontOfSize:15];
        self.pricecell.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.pricecell];
        [self.pricecell makeConstraints:^(MASConstraintMaker * make) {
            make.right.equalTo(self.forkBtn.right).offset(-13);
            make.centerY.equalTo(self.checkBtn.centerY);
            make.width.equalTo(50);
            make.height.equalTo(15);
        }];
        
        self.zhengshuName = [UITextField new];
        self.zhengshuName.font = [UIFont systemFontOfSize:15];
//        self.zhengshuName.backgroundColor = [UIColor redColor];
        NSString *older2 = @"请输入保全证书名称";
        NSMutableAttributedString *placeholer2 = [[NSMutableAttributedString alloc]initWithString:older2];
        [placeholer2 addAttribute:NSForegroundColorAttributeName
                            value:TEXTcolor
                            range:NSMakeRange(0, older2.length)];
        [placeholer2 addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:screen_width / 26]
                            range:NSMakeRange(0, older2.length)];
        self.zhengshuName.attributedPlaceholder = placeholer2;
        self.zhengshuName.delegate = self;
        self.zhengshuName.clearsOnBeginEditing = NO;
//        self.zhengshuName.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.zhengshuName.keyboardType = UIKeyboardTypeDefault;
        self.zhengshuName.returnKeyType=UIReturnKeyDefault;
        [self addSubview:self.zhengshuName];
        [self.zhengshuName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.left);
            make.right.equalTo(self.title.right);
            make.top.equalTo(self.title.bottom).offset(10);
            make.height.equalTo(18);
        }];

    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected         = isSelected;
    _checkBtn.selected  = isSelected;
    _pricecell.hidden   = !isSelected;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.zhengshuName == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
        }
    }
    return YES;
}
//点击return 按钮 去掉
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.zhengshuName isFirstResponder];
    return YES;
}

@end
