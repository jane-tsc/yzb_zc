//
//  BrushsuccessViewController.m
//  yzb_zc
//
//  Created by 兴手付科技 on 16/7/18.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BrushsuccessViewController.h"

@interface BrushsuccessViewController (){

    UIView *view;
}

@end

@implementation BrushsuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"使用帮助";
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    /// 目前使用帮助没有，先把清空缓存放在这儿  ，，点击视图就打印换成大小或清空缓存
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NavigationchongzhiClick)];
    [view addGestureRecognizer:tap];
}


#define 重置按钮
- (void)NavigationchongzhiClick{
    
    NSString  *cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask ,  YES )  objectAtIndex : 0 ];
    NSArray *files = [[ NSFileManager defaultManager ]  subpathsAtPath :cachPath];
    NSLog ( @"缓存大小 :%lu" ,(unsigned long)[files  count ]);
    
    for ( NSString *p  in files) {
        
        NSError *error;
        
        NSString *path = [cachPath  stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ]  fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ]  removeItemAtPath :path  error :&error];
            
        }
    }
    
    [self performSelectorOnMainThread : @selector (clearCacheSuccess)  withObject : nil waitUntilDone : YES ];
}
-( void )clearCacheSuccess

{
    NSLog ( @" 清理成功 " );
    
}


@end
