//
//  originalYESViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "originalYESViewController.h"
#import "JZMTBtnView.h"
#import "SecurityViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyMD5.h"
#import "BaycapacityViewController.h"
#import "OpenpreservationViewController.h"
#import "ProfileAlertView.h"///弹出视图不在提醒勾选
// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface originalYESViewController ()<WJTouchIDDelegate,confirmButtonClickDelegate>{

        UIImage *imagephoto;
        NSString *stringImage;
        NSString *carID;
        NSString *md5;
        NSString *fileExtS;
        NSData *dataimage;
        NSString *SPfilePath;
    NSInteger index;///这个是纪录指纹是原文件下载还是原文件删除
    
     NSInteger indexpaths;///
    
}
@property (nonatomic, strong) WJTouchID *touchID;///指纹验证
@end

@implementation originalYESViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor =  [UIColor whiteColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIView *hen1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, 0.5)];
    hen1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:hen1];
    
    self.title = @"原文件";
     [self setupView];
}

- (void) setupView{
    
    UIView *tabbarView = [[UIView alloc]init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabbarView];
    [tabbarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(self.view.bottom).offset(-60);
        make.width.equalTo(screen_width);
        make.height.equalTo(60);
    }];
    
    UIView *hen =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 0.5)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tabbarView addSubview:hen];
    
    
    
    NSMutableArray *images =[NSMutableArray arrayWithObjects:
                             @"download_nor@2x.png",
                             @"del@2x.png",
                             nil];
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"下载",@"删除", nil];
    for (int i = 0; i< images.count; i ++) {
        CGRect frame = CGRectMake(i * screen_width / 2, 0, screen_width / 2, 60);
        JZMTBtnView *btnView = [[JZMTBtnView alloc]initWithFrame:frame title:titles [i] imageStr:images [i]];
        btnView.tag = 200 +i;
        [tabbarView addSubview:btnView];
        UITapGestureRecognizer *BtnViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(originalYesOnTapBtnView:)];
        [btnView addGestureRecognizer:BtnViewtap];
    }
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    ///请求网络的到原文件
    [[TSCCntc sharedCntc] queryWithPoint:@"getFileUrl" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"]] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            NSDictionary *dic = object[@"data"];
          
            [SVProgressHUD dismiss];
            
            stringImage     = dic [@"fileUrl"];
            carID           = self.Dictionary [@"certId"];
            md5             = self.Dictionary [@"fileHash"];
            fileExtS         = self.Dictionary [@"fileExt"];
            NSString *fileName = dic [@"fileName"];
                ///内容是图片
                if ([self.Dictionary [@"fileType"] intValue] == 20)
                {
                    ///正中心图片
                    UIImageView *imageview = [[UIImageView alloc]init];
                    
                    NSURL *url = [NSURL URLWithString:stringImage];
                    dataimage = [NSData dataWithContentsOfURL:url];
                    imageview.image = [UIImage imageWithData:dataimage];
                     NSLog(@"下载好的原文件:%@",imageview.image);
                    
                    //这里将图片放在沙盒的documents文件夹中
                    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    //文件管理器
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",md5]] contents:dataimage attributes:nil];
                    //得到选择后沙盒中图片的完整路径
                    NSString *filePath = [[NSString alloc]initWithFormat:@"%@/%@.%@",DocumentsPath, md5,fileExtS];
                    
                    [dataimage writeToFile:filePath atomically:YES];
                    
                    ///的到原文件图片
                    imagephoto = imageview.image;
                    [self.view addSubview:imageview];
                    imageview.userInteractionEnabled = YES;
                    imageview.backgroundColor = [UIColor whiteColor];
                    [imageview makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.left).offset(20);
                        make.top.equalTo(130);
                        make.width.equalTo(screen_width - 40);
                        make.height.equalTo(270);
                    }];
                    ///点击图片浏览图片
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewClick)];
                    [imageview addGestureRecognizer:tap];
                }
                  ///如果是视频
                else if ([self.Dictionary [@"fileType"] intValue] == 40){
                    
                    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeGradient];
                
                    ///提前把原文件下载好
                        NSURL * url = [NSURL URLWithString:stringImage];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                       
                        //这里将图片放在沙盒的documents文件夹中
                        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                        //文件管理器
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]] contents:data attributes:nil];
                        //得到选择后沙盒中图片的完整路径
                        SPfilePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath, fileName];
                        NSLog(@"SPfilePath1:%@",SPfilePath);

                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, screen_height / 2 - 150, screen_width, 50)];
                    lable.text = @"此格式不支持阅览";
                    lable.textColor = [UIColor darkGrayColor];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.font = [UIFont systemFontOfSize:18];
                    [self.view addSubview:lable];
                    [SVProgressHUD dismiss];
                }
                else{
                
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, screen_height / 2 - 150, screen_width, 50)];
                    lable.text = @"此格式不支持阅览";
                    lable.textColor = [UIColor darkGrayColor];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.font = [UIFont systemFontOfSize:18];
                    [self.view addSubview:lable];
                    [SVProgressHUD dismiss];
                
                }
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

-(void)originalYesOnTapBtnView:(UITapGestureRecognizer *)sender{
 
    switch (sender.view.tag) {
        case 200:
        {
NSLog(@"下载原文件的状态：%d",[User shareUser].yuanwenjianxiazai);
            
            if ([User shareUser].yuanwenjianDelete == 0) {
                ///没有设置不再提醒
                if ([User shareUser].yuanwenjianxiazaiNoremind == 0)
                {
                    ProfileAlertView *alertView = [[ProfileAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)withGroupNumber:10];
                    alertView.delegate = self;
                    alertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.7];
                    [self.view.window addSubview:alertView];
                    
                    indexpaths = 1;
                }
                ///设置了不再提醒
                else{
                
                    //／这个是判断是否是图片
                    if ([self.Dictionary [@"fileType"] intValue] == 20) {
                        NSLog(@"stringImage:%@",stringImage);
                        
                        ALAssetsLibrary *librarydata = [[ALAssetsLibrary alloc]init];
                        [librarydata writeImageDataToSavedPhotosAlbum:dataimage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                            
                            NSLog(@"assetURL:%@",assetURL);
                            if (error) {
                                //失败
                                NSLog(@"失败!");
                            }else{
                                
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                                [alert show];
                            }
                        }];
                        
                    }
                    //／这个是判断是否是视频
                    else if ([self.Dictionary [@"fileType"] intValue] == 40){
                        
                        ///判断空间是否过期
                        if ([[User shareUser].sizeExpires integerValue] == 0)
                        {
                            
                            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间已过期，请前往续费" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                                bayca.NOType = @"800";
                                NSLog(@"bayca.NOType:%@",bayca.NOType);
                                [self.navigationController pushViewController:bayca animated:YES];
                                
                            }];
                            // 添加操作（顺序就是呈现的上下顺序）
                            [alertDialog addAction:quxiao];
                            [alertDialog addAction:Okaction];
                            // 呈现警告视图
                            [self presentViewController:alertDialog animated:YES completion:nil];
                            
                        }///如果没有过期就下载
                        else{
                            /// 下载视频
                            
                            NSLog(@"SPfilePath2:%@",SPfilePath);
                            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:SPfilePath]
                                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                                            NSLog(@"保存在相册中的回调地址:%@",assetURL);
                                                            if (error) {
                                                                [SVProgressHUD dismiss];
                                                                NSLog(@"失败");
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下载失败"
                                                                                                               message:nil
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"确定"
                                                                                                     otherButtonTitles:nil, nil];
                                                                [alert show];
                                                            } else {
                                                                [SVProgressHUD dismiss];
                                                                NSLog(@"成功");
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                                                               message:nil
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"确定"
                                                                                                     otherButtonTitles:nil, nil];
                                                                [alert show];
                                                            }
                                                        }];
                            
                            
                        }
                    }
                    
                    NSLog(@"确定");
                    
                }
                
            }
            ///不启用直接下载
            else if([User shareUser].yuanwenjianDelete == 10)
            {
            
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"是否确认下载？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //／这个是判断是否是图片
                    if ([self.Dictionary [@"fileType"] intValue] == 20) {
                        NSLog(@"stringImage:%@",stringImage);
                        
                        ALAssetsLibrary *librarydata = [[ALAssetsLibrary alloc]init];
                        [librarydata writeImageDataToSavedPhotosAlbum:dataimage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                            
                            NSLog(@"assetURL:%@",assetURL);
                            if (error) {
                                //失败
                                NSLog(@"失败!");
                            }else{
                                
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                                [alert show];
                            }
                        }];
                        
                    }
                    //／这个是判断是否是视频
                    else if ([self.Dictionary [@"fileType"] intValue] == 40){
                        
                        ///判断空间是否过期
                        if ([[User shareUser].sizeExpires integerValue] == 0)
                        {
                            
                            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间已过期，请前往续费" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                                bayca.NOType = @"800";
                                NSLog(@"bayca.NOType:%@",bayca.NOType);
                                [self.navigationController pushViewController:bayca animated:YES];
                                
                            }];
                            // 添加操作（顺序就是呈现的上下顺序）
                            [alertDialog addAction:quxiao];
                            [alertDialog addAction:Okaction];
                            // 呈现警告视图
                            [self presentViewController:alertDialog animated:YES completion:nil];
                        
                        }///如果没有过期就下载
                        else{
                            /// 下载视频
                            
                            NSLog(@"SPfilePath2:%@",SPfilePath);
                            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:SPfilePath]
                                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                                            NSLog(@"保存在相册中的回调地址:%@",assetURL);
                                                            if (error) {
                                                                [SVProgressHUD dismiss];
                                                                NSLog(@"失败");
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下载失败"
                                                                                                               message:nil
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"确定"
                                                                                                     otherButtonTitles:nil, nil];
                                                                [alert show];
                                                            } else {
                                                                [SVProgressHUD dismiss];
                                                                NSLog(@"成功");
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                                                               message:nil
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"确定"
                                                                                                     otherButtonTitles:nil, nil];
                                                                [alert show];
                                                            }
                                                        }];

                            
                        }
                    }
                    
                    NSLog(@"确定");
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
           
            NSLog(@"下载");
            
            }
            ///设置了密码验证下载
            else if ([User shareUser].yuanwenjianDelete == 30)
            {
            
                ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
                pwdAlert.title = @"请输入验证密码";
                [pwdAlert show];
                pwdAlert.completeAction = ^(NSString *pwd) {
                    NSLog(@"输入的密码:%@", pwd);
                   
                    [[TSCCntc sharedCntc] queryWithPoint:@"verifySafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,pwd] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                        NSLog(@"原文件下载密码数据:%@",object);
                        if ([object [@"code"] integerValue] == 200) {
                            
                            NSDictionary *dic = object [@"data"];
                            
                            if ([dic [@"result"] integerValue] == 1) {
                                
                                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确定下载原文件" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"取消");
                                }];
                                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    //／这个是判断是否是图片
                                    if ([self.Dictionary [@"fileType"] intValue] == 20) {
                                        NSLog(@"stringImage:%@",stringImage);
                                        
                                        ALAssetsLibrary *librarydata = [[ALAssetsLibrary alloc]init];
                                        [librarydata writeImageDataToSavedPhotosAlbum:dataimage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                                            
                                            NSLog(@"assetURL:%@",assetURL);
                                            if (error) {
                                                //失败
                                                NSLog(@"失败!");
                                            }else{
                                                
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                                               message:nil
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:@"确定"
                                                                                     otherButtonTitles:nil, nil];
                                                [alert show];
                                            }
                                        }];
                                        
                                    }
                                    //／这个是判断是否是视频
                                    else if ([self.Dictionary [@"fileType"] intValue] == 40){
                                        
                                        ///判断空间是否过期
                                        if ([[User shareUser].sizeExpires integerValue] == 0)
                                        {
                                            
                                            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间已过期，请前往续费" preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }];
                                            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                
                                                BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                                                bayca.NOType = @"800";
                                                NSLog(@"bayca.NOType:%@",bayca.NOType);
                                                [self.navigationController pushViewController:bayca animated:YES];
                                                
                                            }];
                                            // 添加操作（顺序就是呈现的上下顺序）
                                            [alertDialog addAction:quxiao];
                                            [alertDialog addAction:Okaction];
                                            // 呈现警告视图
                                            [self presentViewController:alertDialog animated:YES completion:nil];
                                            
                                        }///如果没有过期就下载
                                        else{
                                            /// 下载视频
                                            
                                            NSLog(@"SPfilePath2:%@",SPfilePath);
                                            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:SPfilePath]
                                                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                                                            NSLog(@"保存在相册中的回调地址:%@",assetURL);
                                                                            if (error) {
                                                                                [SVProgressHUD dismiss];
                                                                                NSLog(@"失败");
                                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下载失败"
                                                                                                                               message:nil
                                                                                                                              delegate:nil
                                                                                                                     cancelButtonTitle:@"确定"
                                                                                                                     otherButtonTitles:nil, nil];
                                                                                [alert show];
                                                                            } else {
                                                                                [SVProgressHUD dismiss];
                                                                                NSLog(@"成功");
                                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                                                                               message:nil
                                                                                                                              delegate:nil
                                                                                                                     cancelButtonTitle:@"确定"
                                                                                                                     otherButtonTitles:nil, nil];
                                                                                [alert show];
                                                                            }
                                                                        }];
                                            
                                            
                                        }
                                    }
                                    
                                    NSLog(@"确定");
                                }];
                                // 添加操作（顺序就是呈现的上下顺序）
                                [alertDialog addAction:quxiao];
                                [alertDialog addAction:Okaction];
                                // 呈现警告视图
                                [self presentViewController:alertDialog animated:YES completion:nil];
                                
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                            }

                        }else{
                            [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                };
            
            }
             //／设置了指纹验证下载
            else if ([User shareUser].yuanwenjianDelete == 40)
            {
            
                WJTouchID *touchid = [[WJTouchID alloc]init];
                self.touchID = touchid;
                touchid.delegate = self;
                touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
                [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                
                index = 1;
            }
        }
            break;
            
        case 201:
        {
            
NSLog(@"删除原文件的状态：%d",[User shareUser].yuanwenjianDelete);
            if ([User shareUser].yuanwenjianDelete == 0) {
                
                
                if ([User shareUser].yuanwenjianshanchuNoremind == 0)
                {
                    ProfileAlertView *alertView = [[ProfileAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)withGroupNumber:10];
                    alertView.delegate = self;
                    alertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.7];
                    [self.view.window addSubview:alertView];
                    
                    indexpaths = 2;
                }
                else{
                
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认删除原文件？" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"carid:%@",carID);
                        [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,carID] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                            if ([object [@"code"] integerValue] == 200) {
                                
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];///删除成功后返回上一页
                                [SVProgressHUD showSuccessWithStatus:@"删除原文件成功"];
                                
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"原文件删除失败"];
                            }
                        } andFailed:^(NSString *object) {
                            [SVProgressHUD showErrorWithStatus:@"网络错误"];
                        }];
                        NSLog(@"确定");
                    }];
                    // 添加操作（顺序就是呈现的上下顺序）
                    [alertDialog addAction:quxiao];
                    [alertDialog addAction:Okaction];
                    // 呈现警告视图
                    [self presentViewController:alertDialog animated:YES completion:nil];
                
                }
                
            }
             ///设置了不启用直接删除
            else if([User shareUser].yuanwenjianDelete  == 10)
            {
                
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认删除原文件？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"carid:%@",carID);
                    [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,carID] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                        if ([object [@"code"] integerValue] == 200) {
                            
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];///删除成功后返回上一页
                             [SVProgressHUD showSuccessWithStatus:@"删除原文件成功"];
                            
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"原文件删除失败"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    NSLog(@"确定");
                }];
                // 添加操作（顺序就是呈现的上下顺序）
                [alertDialog addAction:quxiao];
                [alertDialog addAction:Okaction];
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
 
            }
            ///设置了密码验证
            else if ([User shareUser].yuanwenjianDelete == 30)
            {
                ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
                pwdAlert.title = @"请输入验证密码";
                [pwdAlert show];
                pwdAlert.completeAction = ^(NSString *pwd) {
                    NSLog(@"输入的密码:%@", pwd);
                    [[TSCCntc sharedCntc] queryWithPoint:@"verifySafePass" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&safePass=%@",[User shareUser].appKey,[User shareUser].authToken,pwd] andURL:@"Safe" andSuccessCompletioned:^(id object) {
                        NSLog(@"删除证书验证密码数据:%@",object);
                        if ([object [@"code"] integerValue] == 200) {
                            
                            
                            NSDictionary *dic = object [@"data"];
                            
                            if ([dic [@"result"] integerValue] == 1) {
                                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确定删除原文件" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"取消");
                                }];
                                UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,carID] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                                        if ([object [@"code"] integerValue] == 200) {
                                            
                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];///删除成功后返回上一页
                                            [SVProgressHUD showSuccessWithStatus:@"删除原文件成功"];
                                            
                                        }else{
                                            [SVProgressHUD showErrorWithStatus:@"原文件删除失败"];
                                        }
                                    } andFailed:^(NSString *object) {
                                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                                    }];
                                    NSLog(@"确定");
                                }];
                                // 添加操作（顺序就是呈现的上下顺序）
                                [alertDialog addAction:quxiao];
                                [alertDialog addAction:Okaction];
                                // 呈现警告视图
                                [self presentViewController:alertDialog animated:YES completion:nil];
                            }else{
                              
                                [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                            }

                        }else{
                            [SVProgressHUD showErrorWithStatus:@"密码不一致"];
                        }
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                };
            }
            ///设置了指纹验证
            else if ([User shareUser].yuanwenjianDelete == 40)
            {
            
                WJTouchID *touchid = [[WJTouchID alloc]init];
                self.touchID = touchid;
                touchid.delegate = self;
                touchid.WJTouchIDFallbackTitle = WJNotice(@"自定义按钮标题",@"云证保指纹验证");
                [touchid startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                [self.touchID startWJTouchIDWithMessage:WJNotice(@"自定义提示语", @"云证保指纹验证")];
                
                index = 2;
            }
        }
            break;

        default:
            break;
    }
}
/**
 *  TouchID验证成功就删除证书
 *
 *  (English Comments) Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
    
    ///index ＝ 1  是原文件下载    index = 2  是原文件删除
 /*
     是原文件删除
 */
    if (index == 2) {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认删除原文件？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[TSCCntc sharedCntc] queryWithPoint:@"delCert" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@",[User shareUser].appKey,[User shareUser].authToken,carID] andURL:@"Cert" andSuccessCompletioned:^(id object) {
                if ([object [@"code"] integerValue] == 200) {
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];///删除成功后返回上一页
                    [SVProgressHUD showSuccessWithStatus:@"删除原文件成功"];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除原文件失败"];
                }
            } andFailed:^(NSString *object) {
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
            NSLog(@"确定");
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
    }
/*
  是原文件下载
 */
    else if (index == 1)
    {
    
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"是否确认下载？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //／这个是判断是否是图片
            if ([self.Dictionary [@"fileType"] intValue] == 20) {
                NSLog(@"stringImage:%@",stringImage);
                
                ALAssetsLibrary *librarydata = [[ALAssetsLibrary alloc]init];
                [librarydata writeImageDataToSavedPhotosAlbum:dataimage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    NSLog(@"assetURL:%@",assetURL);
                    if (error) {
                        //失败
                        NSLog(@"失败!");
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                       message:nil
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
                
            }
            //／这个是判断是否是视频
            else if ([self.Dictionary [@"fileType"] intValue] == 40){
                
                ///判断空间是否过期
                if ([[User shareUser].sizeExpires integerValue] == 0)
                {
                    
                    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间已过期，请前往续费" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                        bayca.NOType = @"800";
                        NSLog(@"bayca.NOType:%@",bayca.NOType);
                        [self.navigationController pushViewController:bayca animated:YES];
                        
                    }];
                    // 添加操作（顺序就是呈现的上下顺序）
                    [alertDialog addAction:quxiao];
                    [alertDialog addAction:Okaction];
                    // 呈现警告视图
                    [self presentViewController:alertDialog animated:YES completion:nil];
                    
                }///如果没有过期就下载
                else{
                    /// 下载视频
                    
                    NSLog(@"SPfilePath2:%@",SPfilePath);
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:SPfilePath]
                                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                                    NSLog(@"保存在相册中的回调地址:%@",assetURL);
                                                    if (error) {
                                                        [SVProgressHUD dismiss];
                                                        NSLog(@"失败");
                                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下载失败"
                                                                                                       message:nil
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"确定"
                                                                                             otherButtonTitles:nil, nil];
                                                        [alert show];
                                                    } else {
                                                        [SVProgressHUD dismiss];
                                                        NSLog(@"成功");
                                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                                                                       message:nil
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"确定"
                                                                                             otherButtonTitles:nil, nil];
                                                        [alert show];
                                                    }
                                                }];
                    
                    
                }
            }
            
            NSLog(@"确定");
        }];
        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:quxiao];
        [alertDialog addAction:Okaction];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
    
    }

    NSLog(@"line 37: %@",WJNotice(@"TouchID验证成功", @"TouchID验证成功"));
}
/**
 *  TouchID验证失败
 *
 *  (English Comments) Authentication Failure
 */
- (void) WJTouchIDAuthorizeFailure {
    NSLog(@"line 46: %@",WJNotice(@"TouchID验证失败", @"TouchID验证失败") );
    [SVProgressHUD showErrorWithStatus:@"TouchID验证失败" duration:2.0];
}
#pragma mark - 把图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
        [alert show];
    }
    
}

///点击图片后的操作
- (void)imageviewClick{
    NSLog(@"您点击了图片");
    
    ///显示图片的位置
    CGRect frame = CGRectMake(0, 0, screen_width, screen_height);
    
    NSArray *imgUrls = @[stringImage];
    XHPicView *picView = [[XHPicView alloc]initWithFrame:frame withImgs:nil withImgUrl:imgUrls];
    picView.eventBlock = ^(NSString *event){
        NSLog(@"点击图片触发事件%@",event);
    };
    [self.view addSubview:picView];
}



///这个是不在提醒按钮的操作
- (void) confirmButtonDidCilckedIsSetChat:(BOOL) isChat {
    NSLog(@"%d",isChat);
    
    if (indexpaths == 1) {
        NSLog(@"进入了下载");
        NSLog(@"[user share].yuanwenjianxiazaiNoremind;%d",[User shareUser].yuanwenjianxiazaiNoremind);
        if (isChat) {
            NSLog(@"勾选了");
            [User shareUser].yuanwenjianxiazaiNoremind = 1;
            [User saveUserInfo];
            NSLog(@"[user share].yuanwenjianxiazaiNoremind;%d",[User shareUser].yuanwenjianxiazaiNoremind);
            
        }else{
            NSLog(@"没有勾选");
        }
    }
    else{
    
         NSLog(@"进入了删除");
        NSLog(@"[user share].yuanwenjianshanchuNoremind;%d",[User shareUser].yuanwenjianshanchuNoremind);
        if (isChat) {
            NSLog(@"勾选了");
            [User shareUser].yuanwenjianshanchuNoremind = 1;
            [User saveUserInfo];
            NSLog(@"[user share].yuanwenjianshanchuNoremind;%d",[User shareUser].yuanwenjianshanchuNoremind);
            
        }else{
            NSLog(@"没有勾选");
        }
    }
}
///这个是点击了前往设置按钮
- (void)conqianwangshezClickButton{
    NSLog(@"点击了前往设置");
    SecurityViewController *secur = [[SecurityViewController alloc]init];
    [self.navigationController pushViewController:secur animated:YES];
}


@end
