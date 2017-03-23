//
//  SearchViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/23.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

///文件夹
@property(nonatomic,strong) NSMutableArray *dirList;
///文件
@property(nonatomic,strong) NSMutableArray *fileList;

@end
