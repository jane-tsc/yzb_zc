//
//  NewfeatureViewController.m
//  傻子笑了。
//
//  Created by zuxia on 15-4-3.
//  Copyright (c) 2015年 zuxia. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "UIImage+LY.h"
#import "LoginViewController.h"
@interface NewfeatureViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *scroll;
    UIPageControl *pg;
}

@end

@implementation NewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    //设置滚动试图
    scroll = [[UIScrollView alloc]init];
    scroll.frame = self.view.bounds;
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator =NO;
    scroll.userInteractionEnabled = YES;
    scroll.contentSize=CGSizeMake(scroll.frame.size.width*4,0);
    scroll.delegate=self;
    [self.view addSubview:scroll];
    
    for (int i = 0; i<4; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(i*scroll.frame.size.width, 0, scroll.frame.size.width, scroll.frame.size.height);
        image.userInteractionEnabled = YES;
        NSString *name = [NSString stringWithFormat:@"qi%d.png", i+1];
        image.image=[UIImage fullScreenImage:name];
        [scroll addSubview:image];
        if (i == 4 - 1) {
            
            UIButton *start=[UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startImg=[UIImage imageNamed:@"button_normal@2x.png"];
            [start setTitle:@"立即体验" forState:UIControlStateNormal];
            start.titleLabel.font = [UIFont systemFontOfSize:17];
            [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [start setBackgroundImage:startImg forState:UIControlStateNormal];

            start.center=CGPointMake(scroll.frame.size.width*0.5, scroll.frame.size.height*0.8);
            start.frame = CGRectMake(screen_width/4, screen_height - 70, screen_width/2, 35.0);
            
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:start];
        }
    }
}

//跳转页面
- (void)start{
    LoginViewController *basic = [[LoginViewController alloc]init];
    UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:basic];
//    [self.navigationController pushViewController:basic animated:YES];
    [self presentViewController:nac animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //只能向右滚动
    if (scrollView.contentOffset.x<0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }
    int num= scrollView.contentOffset.x/self.view.frame.size.width;
    pg.currentPage=num;
    
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
