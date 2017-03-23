//
//  addressViewCell.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "addressViewCell.h"

@implementation addressViewCell

- (void)configWithindexPath:(NSIndexPath *)indexPath{

    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"所在省",@"所在市",@"所在区／县", @"详细地址",nil];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, screen_width / 2, 55)];
    lable.text = titles [indexPath.row];
    lable.font = [UIFont systemFontOfSize:screen_width / 24];
    lable.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:lable];
    
    if (indexPath.row != 3) {
        self.RigthImg = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width -  50, 16.5, 22, 22)];
        self.RigthImg.image = [UIImage imageNamed:@"next_grzx.png"];
        [self.contentView addSubview:self.RigthImg];
        
        if (indexPath.row == 0) {
            self.shen = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 124 , 0, 55, 55)];
            self.shen.font = [UIFont systemFontOfSize:screen_width / 24];
            self.shen.textAlignment = NSTextAlignmentRight;
            self.shen.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:self.shen];
        }else if (indexPath.row == 1){
            self.shi = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 124 , 0, 55, 55)];
            self.shi.font = [UIFont systemFontOfSize:screen_width / 24];
            self.shi.textAlignment = NSTextAlignmentRight;
            self.shi.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:self.shi];
        }else if (indexPath.row == 2){
            self.xian = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 174 , 0, 100, 55)];
            self.xian.font = [UIFont systemFontOfSize:screen_width / 24];
            self.xian.textAlignment = NSTextAlignmentRight;
            self.xian.textColor = [UIColor darkGrayColor];
            [self.contentView addSubview:self.xian];
        }
    }else if(indexPath.row == 3){
       
    
    }
}


@end
