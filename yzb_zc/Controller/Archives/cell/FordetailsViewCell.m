//
//  FordetailsViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/12.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "FordetailsViewCell.h"

@implementation FordetailsViewCell

- (void)initWithIndexpath:(NSIndexPath *)indexpath{
    if (indexpath.row == 0) {
        UILabel *zhengshumessage = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width - 20, 44)];
        zhengshumessage.textAlignment = NSTextAlignmentLeft;
        zhengshumessage.text = @"证书信息";
        zhengshumessage.textColor = [UIColor blackColor];
        zhengshumessage.font = [UIFont boldSystemFontOfSize:screen_width / 22];
        [self addSubview:zhengshumessage];
    }else if (indexpath.row == 1 || indexpath.row == 2 || indexpath.row == 3){
        NSArray *titles = [NSArray arrayWithObjects:@"备  案   号",@"档  案  名",@"文件类型", nil];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width / 4, 70)];
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:screen_width / 24];
        title.text = titles [indexpath.row - 1];
        title.textColor = [UIColor darkGrayColor];
        [self addSubview:title];
        
        if (indexpath.row == 1) {
            self.beianNum = [[UILabel alloc]init];
            self.beianNum .textAlignment = NSTextAlignmentLeft;
            self.beianNum.numberOfLines = 0;
            self.beianNum .font = [UIFont systemFontOfSize:screen_width / 24];
            self.beianNum .textColor = [UIColor darkGrayColor];
            [self addSubview:self.beianNum ];
            [self.beianNum makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.right);
                make.top.equalTo(0);
                make.width.equalTo(screen_width - screen_width / 4 - 40);
                make.height.equalTo(70);
            }];

        }else if (indexpath.row == 2){
            
            self.danganName = [[UILabel alloc]init];
            self.danganName .textAlignment = NSTextAlignmentLeft;
            self.danganName .font = [UIFont systemFontOfSize:screen_width / 24];
            self.danganName .textColor = [UIColor darkGrayColor];
            [self addSubview:self.danganName ];
            [self.danganName makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.right);
                make.top.equalTo(0);
                make.width.equalTo(screen_width - screen_width / 4);
                make.height.equalTo(70);
            }];
        
        }else if (indexpath.row == 3){
        
            self.baoquanType = [[UILabel alloc]init];
            self.baoquanType .textAlignment = NSTextAlignmentLeft;
            self.baoquanType .font = [UIFont systemFontOfSize:screen_width / 24];
            self.baoquanType .textColor = [UIColor darkGrayColor];
            [self addSubview:self.baoquanType ];
            [self.baoquanType makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.right);
                make.top.equalTo(0);
                make.width.equalTo(screen_width - screen_width / 4);
                make.height.equalTo(70);
            }];
        
        }
        
        
    }else if (indexpath.row == 4){
        UILabel *zhengshumessage = [[UILabel alloc]initWithFrame:CGRectMake(20,25, screen_width / 4, 44)];
        zhengshumessage.textAlignment = NSTextAlignmentLeft;
        zhengshumessage.text = @"收件信息";
        zhengshumessage.textColor = [UIColor blackColor];
        zhengshumessage.font =[UIFont boldSystemFontOfSize:screen_width / 22];
        [self addSubview:zhengshumessage];

    }else if (indexpath.row == 5){
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width / 4, 70)];
        self.name .textAlignment = NSTextAlignmentLeft;
        self.name .font = [UIFont systemFontOfSize:screen_width / 24];
        self.name .textColor = [UIColor darkGrayColor];
        [self addSubview:self.name ];
    
        self.phone = [[UILabel alloc]init];
        self.phone .textAlignment = NSTextAlignmentLeft;
        self.phone .font = [UIFont systemFontOfSize:screen_width / 24];
        self.phone .textColor = [UIColor darkGrayColor];
        [self addSubview:self.phone ];
        [self.phone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.right);
            make.top.equalTo(0);
            make.width.equalTo(screen_width - screen_width / 4);
            make.height.equalTo(70);
        }];
        
    }else if (indexpath.row == 6){
        
        ///write_cz_n@2x.png
        self.Modifybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.Modifybtn setBackgroundImage:[UIImage imageNamed:@"write_cz_n.png"] forState:UIControlStateNormal];
        [self addSubview:self.Modifybtn];
        [self.Modifybtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screen_width - 40);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(15);
            make.height.equalTo(15);
        }];
        
        self.addressArea =[[UILabel alloc]init];
        self.addressArea.textAlignment = NSTextAlignmentLeft;
        self.addressArea.font = [UIFont systemFontOfSize:screen_width / 24];
        self.addressArea.textColor = [UIColor darkGrayColor];
        [self addSubview:self.addressArea];
        [self.addressArea makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(0);
//            make.width.equalTo(screen_width/2 - 50);
            make.height.equalTo(50);
        }];
        
        self.addressDetail = [[UILabel alloc]init];
        self.addressDetail.numberOfLines = 0;
        self.addressDetail .textAlignment = NSTextAlignmentLeft;
        self.addressDetail .font = [UIFont systemFontOfSize:screen_width / 24];
        self.addressDetail .textColor = [UIColor darkGrayColor];
        [self addSubview:self.addressDetail ];
        [self.addressDetail makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.addressArea.bottom);
//            make.width.equalTo(screen_width / 2);
            make.height.equalTo(40);
        }];
        
    }else if(indexpath.row == 7){
        
        UILabel *zhengshumessage = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, screen_width / 4, 44)];
        zhengshumessage.textAlignment = NSTextAlignmentLeft;
        zhengshumessage.text = @"出证材料";
        zhengshumessage.textColor = [UIColor blackColor];
        zhengshumessage.font = [UIFont boldSystemFontOfSize:screen_width / 22];
        [self addSubview:zhengshumessage];
    }else if(indexpath.row == 8){
        
        NSString *strings = [NSString stringWithFormat:@"纸质保全证书, 文件保全证书, 保全公证书, 源文件密封件"];
        CGSize size = [strings sizeWithFont:[UIFont systemFontOfSize:screen_width / 24] constrainedToSize:CGSizeMake(screen_width - 40,10000.0f)lineBreakMode:NSLineBreakByCharWrapping];
        self.cailiao1 = [UILabel new];
        self.cailiao1.textAlignment = NSTextAlignmentLeft;
        self.cailiao1.numberOfLines = 0;
        self.cailiao1.font = [UIFont systemFontOfSize:screen_width / 24];
        self.cailiao1.text =strings;
        self.cailiao1.textColor = [UIColor darkGrayColor];
        [self addSubview:self.cailiao1];
        [self.cailiao1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.height.equalTo(size.height);
            make.top.equalTo(self.top).offset(20);
            make.width.equalTo(size.width);
        }];
    }
}
@end
