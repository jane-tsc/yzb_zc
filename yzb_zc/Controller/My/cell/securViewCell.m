//
//  securViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "securViewCell.h"

@implementation securViewCell

- (void)configWithindexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
            lable.text =@"验证方式";
            lable.font = [UIFont boldSystemFontOfSize:screen_width / 20];
            lable.textColor = [UIColor blackColor];
            [self.contentView addSubview:lable];
        }else if(indexPath.row == 1){
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
            lable.text = @"密码验证";
            lable.font = [UIFont systemFontOfSize:screen_width / 24];
            lable.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:lable];
            
            self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  50, 16.5, 22, 22)];
            self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
            [self.contentView addSubview:self.RigthImg];
            
            self.password = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
            self.password.font = [UIFont systemFontOfSize:screen_width / 24];
            self.password.textAlignment = NSTextAlignmentRight;
            self.password.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:self.password];
        }
        else if(indexPath.row == 2){
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
            lable.text = @"指纹验证";
            lable.font = [UIFont systemFontOfSize:screen_width / 24];
            lable.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:lable];
            
            self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  50, 16.5, 22, 22)];
            self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
            [self.contentView addSubview:self.RigthImg];
            
            self.fingerprint = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
            self.fingerprint.font = [UIFont systemFontOfSize:screen_width / 24];
            self.fingerprint.textAlignment = NSTextAlignmentRight;
            self.fingerprint.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:self.fingerprint];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
            lable.text =@"验证设置";
            lable.font = [UIFont boldSystemFontOfSize:screen_width / 20];
            lable.textColor = [UIColor blackColor];
            [self.contentView addSubview:lable];
        }else if(indexPath.row !=0){
            NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"证书删除",@"证书出证",@"原文件下载", @"原文件删除",nil];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
            lable.text = titles [indexPath.row - 1];
            lable.font = [UIFont systemFontOfSize:screen_width / 24];
            lable.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:lable];
            
            self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  50, 16.5, 22, 22)];
            self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
            [self.contentView addSubview:self.RigthImg];
            
            if (indexPath.row == 1) {
                self.shanchu = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
                self.shanchu.font = [UIFont systemFontOfSize:screen_width / 24];
                self.shanchu.textAlignment = NSTextAlignmentRight;
                self.shanchu.textColor = [UIColor darkGrayColor];
                [self.contentView addSubview:self.shanchu];
            }else if (indexPath.row == 2){
                self.chuzhen = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
                self.chuzhen.font = [UIFont systemFontOfSize:screen_width / 24];
                self.chuzhen.textAlignment = NSTextAlignmentRight;
                self.chuzhen.textColor = [UIColor darkGrayColor];
                [self.contentView addSubview:self.chuzhen];
            }else if (indexPath.row == 3){
                self.xiazai = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
                self.xiazai.font = [UIFont systemFontOfSize:screen_width / 24];
                self.xiazai.textAlignment = NSTextAlignmentRight;
                self.xiazai.textColor = [UIColor darkGrayColor];
                [self.contentView addSubview:self.xiazai];
            }else{
                self.yuanwenjianshanchu = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2.5 - 60 , 0, screen_width / 2.5, 55)];
                self.yuanwenjianshanchu.font = [UIFont systemFontOfSize:screen_width / 24];
                self.yuanwenjianshanchu.textAlignment = NSTextAlignmentRight;
                self.yuanwenjianshanchu.textColor = [UIColor darkGrayColor];
                [self.contentView addSubview:self.yuanwenjianshanchu];
            }
        }
        
    }else{
    
    }
}

@end
