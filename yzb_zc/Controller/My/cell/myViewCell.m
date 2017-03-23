//
//  myViewCell.m
//  yunzhenbao
//
//  Created by 兴手付科技 on 16/6/6.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "myViewCell.h"
#import "Public.h"
@implementation myViewCell

- (void)configWithindexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"头像",@"姓名",@"性别", @"身份证号",@"手机号码",nil];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
        lable.text = titles [indexPath.row];
        lable.font = [UIFont systemFontOfSize:screen_width / 24];
        lable.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:lable];
        
        if (indexPath.row == 0) {
            
            lable.frame = CGRectMake(27, 0, screen_width / 2, 65);
            
            self.headimg = [[UIImageView alloc]init];
            [self.contentView addSubview:self.headimg];
            [self.headimg makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.right).offset( - 124);
                make.top.equalTo(self.top).offset(8);
                make.width.equalTo(50);
                make.height.equalTo(50);
            }];
           
            self.headimg.layer.cornerRadius = 25;
            self.headimg.layer.masksToBounds = YES;
            
            
            self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  54, 22, 22, 22)];
            self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
            [self.contentView addSubview:self.RigthImg];
            
            ///next_grzx
        }else if (indexPath.row == 1){
            
            self.name = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 29 , 0, screen_width / 2.5, 55)];
            self.name.font = [UIFont systemFontOfSize:screen_width / 24];
            self.name.textAlignment = NSTextAlignmentRight;
            self.name.textColor = RGB(204, 205, 205);
            [self.contentView addSubview:self.name];
        }else if (indexPath.row == 2){
            
            self.sex = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 124, 0, 55, 55)];
            self.sex.font = [UIFont systemFontOfSize:screen_width / 24];
            self.sex.textAlignment = NSTextAlignmentRight;
            self.sex.textColor = [UIColor grayColor];
            [self.contentView addSubview:self.sex];
            
            self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  54, 18, 22, 22)];
            self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
            [self.contentView addSubview:self.RigthImg];
            
        }else if (indexPath.row == 3){
            
            self.idcar = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 1.5 - 29 , 0, screen_width / 1.5, 55)];
            self.idcar.font = [UIFont systemFontOfSize:screen_width / 24];
            self.idcar.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:self.idcar];
            self.idcar.textColor = RGB(204, 205, 205);
        }else if (indexPath.row == 4){
        
            self.phone = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 29 , 0, screen_width / 2.5, 55)];
            self.phone.font = [UIFont systemFontOfSize:screen_width / 24];
            self.phone.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:self.phone];
            self.phone.textColor = RGB(204, 205, 205);
        }
    }

}

@end