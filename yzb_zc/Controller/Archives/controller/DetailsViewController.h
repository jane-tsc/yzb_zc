//
//  DetailsViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"
#import "Public.h"
@interface DetailsViewController : BasicViewController

@property (nonatomic,copy) NSString *fileid;

@property (nonatomic,copy) NSString *labletitle;

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSString *urlStr;


@property(nonatomic, copy) NSString *chenggongType;///测试給的失败成功状态

@end
