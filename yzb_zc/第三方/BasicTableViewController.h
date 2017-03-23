//
//  BasicTableViewController.h
//  AdailyShop
//
//  Created by 重庆阿达西科技有限公司 on 15/9/1.
//  Copyright (c) 2015年 com.adaxi.AdailyShop. All rights reserved.
/* A Da Xi of Chongqing Science and Technology Co., Ltd. is a high-tech enterprise specialized in software development and its affiliated sales of electronic products. Is a professional engaged in software development, software customization, software implementation of high-tech enterprises.
The company has a number of long-term professional engaged in software development, software customization of professional personnel, with strong technology development strength, the full range of government and business information needs.
Company's purpose: scientific and technological innovation, excellence, pioneering and enterprising, pragmatic and efficient.
Business philosophy: people-oriented, integrity, mutual benefit.
Service tenet: "the first-class technology, the first-class product, the thoughtful customer service" is our tenet. "Customer satisfaction" is our eternal pursuit.
Main business: website development and maintenance, software outsourcing, software customization development, system maintenance, OA office systems, mobile APP customization, micro channel two development, etc..
The language used include: JAVA/JSF/JSP,.NET, VB/VBA, OC, Swift, PHP, etc..
The company's business goal is to become a leader in the software development market, innovative technology, developed a series of popular consumer favorite software. */

#import <UIKit/UIKit.h>
#import "Public.h"
@interface BasicTableViewController : UITableViewController

@property (nonatomic, strong) UIButton * leftBtn;

/// 标题项
@property (nonatomic, strong) MarqueeLabel * titleLabel;

/// 设置标题
- (void)setViewControllerNavTitle:(NSString *)titleStr;


- (void)NavigationBackItemClick;

@end
