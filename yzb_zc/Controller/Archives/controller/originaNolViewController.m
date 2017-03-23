//
//  originalViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "originaNolViewController.h"
#import "Public.h"
#import "TransmissionViewController.h"
#import "PayWCViewController.h"
#import "MyMD5.h"
#import "WsqMD5Util.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaycapacityViewController.h"
@interface originaNolViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    //图片2进制路径
    NSString* filePath;
}

@property(nonatomic ,strong) UIButton *DaigButton;///立即代管
@property(nonatomic, strong) NSMutableArray *imageArray;
//@property(nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation originaNolViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
     [self httprestWithup];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  RGB(249, 253, 255);
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.imageArray = [NSMutableArray array];
    
    self.title = @"原文件";
    [self setupView];
}

- (void) setupView{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(35, 30, screen_width - 70, 250)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8.0;
    view.layer.shadowColor =RGB(237, 245, 255).CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowOffset = CGSizeMake(1, 6);
    view.layer.shadowRadius = 3;
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = view.bounds.size.width;
    float height = view.bounds.size.height;
    float x = view.bounds.origin.x;
    float y = view.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = view.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];  
    //设置阴影路径  
    view.layer.shadowPath = path.CGPath;
    
//    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    ///right_grzx@2x.png
    UIImageView *image1= [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/ 2 - 12.5, 30, 25, 25)];
    image1.image = [UIImage imageNamed:@"wr_n.png"];
    [view addSubview:image1];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 , view.frame.size.width , 25)];
    NSString *string = [NSString stringWithFormat:@"无原文件!"];
    lable.text = string;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont boldSystemFontOfSize:screen_width / 24];
    lable.textColor = [UIColor blackColor];
    [view addSubview:lable];
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width / 3 - 20, 100, view.frame.size.width, 25)];
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont boldSystemFontOfSize:screen_width / 24];
    price.textColor = [UIColor grayColor];
    [view addSubview:price];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getPriceBySize" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&bytes=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary[@"fileSize"]] andURL:@"Security" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
//            NSDictionary *Dictionary = [object objectForKey:@"data"];
//             NSString *money = [Dictionary objectForKey:@"amount"];
//            NSString *pricestring = [NSString stringWithFormat:@"费    用:       %@元",money];
//            price.text = pricestring;
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
    
//    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width / 3 - 20, 120, view.frame.size.width, 25)];
//    NSString *timestring = [NSString stringWithFormat:@"有效期:       %@",self.Dictionary [@"securityExpires"]];
//    time.text = timestring;
//    time.textAlignment = NSTextAlignmentLeft;
//    time.font = [UIFont boldSystemFontOfSize:14];
//    time.textColor = [UIColor grayColor];
//    [view addSubview:time];
    
    ///立即代管按钮
    self.DaigButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.DaigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.DaigButton setTitle:@"立即代管" forState:UIControlStateNormal];
    self.DaigButton.layer.cornerRadius = 15.0;
    [self.DaigButton setBackgroundColor:RGB(251, 140, 142)];
    self.DaigButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.DaigButton.layer.shadowOpacity = 0.5;
    self.DaigButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.DaigButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 24];
    [view addSubview:self.DaigButton];
    [self.DaigButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 6);
        make.top.equalTo(price.bottom).offset(60);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(screen_width / 11);
    }];
    [self.DaigButton addTarget:self action:@selector(DaigButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 立即代管按钮
- (void)DaigButtonClick:(UIButton *)sender{
    
    //／没开通空间
    if ([[User shareUser].sizeUsed intValue] == 0) {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"未开通空间，请前往开通空间" preferredStyle:UIAlertControllerStyleAlert];
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
        
    }
    //判断空间是否足够，不够请前往购买
    else if ([[User shareUser].restSize integerValue] == 0)
    {
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"空间容量不足，请前往开通" preferredStyle:UIAlertControllerStyleAlert];
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
    
    }
    ///空间，次数，什么都有
    else{
    
        if ([self.Dictionary [@"fileType"] intValue] == 40) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            //                imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            [self presentModalViewController:imagePicker animated:YES];
            
        }else if ([self.Dictionary [@"fileType"] intValue] == 20){
            
            ///选择图片
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //			[self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
    
    }
 
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [OMGToast showWithText:@"取消选择"];
    return;
}
#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate  // 选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD showWithStatus:@"验证中。。。" maskType:SVProgressHUDMaskTypeGradient];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
    NSLog(@"相册返回的图片:－－－－－－－－－－－－－－－－－－－－－－－%@",info);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    ///得到路径和图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSDatas
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        ///得到图片原来的名称
        __block NSString *imagesss;
        __block double size;
        
        NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            imagesss = [representation filename];
            NSURL *urlname = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            
            __block NSData *data;
            __block NSString *md5image;
            __block  NSString * imagePath;
            __block NSUInteger buffered;
            __block  NSString *buff;
            __block NSString *s;
            __block  NSString *fileExt;
            // 如何判断已经转化了,通过是否存在文件路径
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            // 创建存放原始图的文件夹--->OriginalPhotoImages
            NSFileManager * fileManager1 = [NSFileManager defaultManager];
            if (![fileManager1 fileExistsAtPath:KOriginalPhotoImagePath]) {
                [fileManager1 createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (urlname) {
                // 主要方法
                [assetLibrary assetForURL:urlname resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                    buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                    NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                    data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                    imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                    [data writeToFile:imagePath atomically:YES];

                    md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                    
                    s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                    
                    float floatString = [s floatValue];
                    
                    size = floatString / (1024 * 1024);
                    
                    NSLog(@"size:%.2lf",size);
                    
                    buff = [NSString stringWithFormat:@"%.2lf",size];
                    /// 后缀名
                    fileExt = [imagePath pathExtension];
   
                    NSLog(@"图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                    NSLog(@"图片名称＋＋＋＋＋＋＋＋＋＋＋＋＋::%@",imagesss);
                    NSLog(@"md5image:++++++++++++++++++++++%@",md5image);
                    NSLog(@"imagePath:++++++++++++++++++++++%@",imagePath);
                    NSLog(@"fileExt:++++++++++++++++++++++%@",fileExt);
                    
                    NSDictionary *dic = @{@"image":image,@"filePath":imagesss,@"zhao":buff,@"price":@"",@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s,@"fileExt":fileExt};
                    
                    [self.imageArray addObject:dic];
                    
                    NSLog(@"self.Dictionary:%@,  self.imagearray:%@",self.Dictionary,self.imageArray);
                    
///================================清除沙盒路径============================
                    [AllObject clearCacheWithFilePath:imagePath];
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"setCertFile" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],md5image] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            [SVProgressHUD dismiss];
                            
                            NSDictionary *dic = object [@"data"];
                            NSLog(@"dic:%@",dic);
                            
                            if ([dic [@"verifyResult"] intValue] == 1) {
                                
                                PayWCViewController *pay = [[PayWCViewController alloc]init];
                                pay.Dictionary = self.Dictionary;
                                /// dic 是验证后返回的数据
                                pay.yanzhenDic = dic;
                                pay.imageArray = self.imageArray;
                                pay.paytype = @"1";
                                [self.navigationController pushViewController:pay animated:YES];
                                
                            }else {
                                
                                [SVProgressHUD dismiss];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"文件验证失败！"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                                [alert show];
                                ///验证失败后就删除数组里面的值
                                [self.imageArray removeAllObjects];
                                
                                return;
                            }
                            
                        }
                        else if ([object [@"code"] integerValue] == 4014){
                            
                            ///验证失败后就删除数组里面的值
                            [self.imageArray removeAllObjects];
                            [SVProgressHUD dismiss];
                            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:object [@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"前往开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                BaycapacityViewController *bayca = [[BaycapacityViewController alloc]init];
                                [self.navigationController pushViewController:bayca animated:YES];
                                
                            }];
                            // 添加操作（顺序就是呈现的上下顺序）
                            [alertDialog addAction:quxiao];
                            [alertDialog addAction:Okaction];
                            // 呈现警告视图
                            [self presentViewController:alertDialog animated:YES completion:nil];
                            
                        }
                        else{
                            
                            [SVProgressHUD dismiss];
                            [OMGToast showWithText:object [@"msg"]];
                        }
                        
                    } andFailed:^(NSString *object) {
                        [SVProgressHUD dismiss];
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                    
                } failureBlock:nil];
            }
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
         
                      failureBlock:nil];
    }
    
    }
    ///立即代管视频
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
    {
    
        NSLog(@"--选取的是视频-----------");
        NSString *videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"url:%@",videoPath);
        //先把图片转成NSDatas
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        ///得到图片原来的名称
        __block NSString *imagesss;
        __block double size;
        
        NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSLog(@"imageURL:%@",imageURL);
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            imagesss = [representation filename];
            __block NSData *data;
            __block NSString *md5image;
            __block  NSString * imagePath;
            __block NSUInteger buffered;
            __block  NSString *buff;
            __block  NSString *fileExt;
            __block NSString *s;
            // 如何判断已经转化了,通过是否存在文件路径
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            // 创建存放原始图的文件夹--->OriginalPhotoImages
            NSFileManager * fileManager1 = [NSFileManager defaultManager];
            if (![fileManager1 fileExistsAtPath:KVideoUrlPath]) {
                [fileManager1 createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (imageURL) {
                // 主要方法
                [assetLibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                    buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                    NSLog(@"buffered------------:%lu",(unsigned long)buffered);
                    data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                    imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:imagesss];
                    [data writeToFile:imagePath atomically:YES];
                    //
                    NSLog(@"data.length -:%lu",(unsigned long)data.length);
                    ///md5 加密
                    md5image =  [WsqMD5Util getFileMD5WithPath:imagePath];
                    ///计算图片大小
                    s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                    
                    float floatString = [s floatValue];
                    
                    size = floatString / (1024 * 1024);
                    
                    NSLog(@"size:%.2lf",size);
                    buff = [NSString stringWithFormat:@"%.2lf",size];
                    /// 后缀名
                    fileExt = self.Dictionary [@"fileExt"];
                    
                    NSLog(@"视频的名字++++++++++++++++++++++:%@",imagesss);
                    NSLog(@"视频的大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@",buff);
                    NSLog(@"视频的md5++++++++++++++++++++++:%@",md5image);
                    NSLog(@"视频的路径++++++++++++++++++++++:%@",imagePath);
                    NSLog(@"视频的s++++++++++++++++++++++:%@",s);
                    
                    NSDictionary *dic = @{@"image":@"",@"filePath":imagesss,@"zhao":buff,@"price":@"",@"md5":md5image,@"textName":@"",@"filePathlujin":imagePath,@"buffered":s};
                    
                    [self.imageArray addObject:dic];
                   
///================================清除沙盒路径============================
                    [AllObject clearCacheWithFilePath:imagePath];
                    
                    [[TSCCntc sharedCntc] queryWithPoint:@"setCertFile" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],md5image] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                        NSLog(@"这个是没有原文件页面:%@",object);
                        if ([object [@"code"] integerValue] == 200) {
                            [SVProgressHUD dismiss];
                            
                            NSDictionary *dic = object [@"data"];
                            NSLog(@"dic:%@",dic);
                            NSLog(@"self.imageArray:%@",self.imageArray);
                            NSLog(@"self.Dictionary:%@",self.Dictionary);
                            
                            if ([dic [@"verifyResult"] intValue] == 1) {
                                
                                PayWCViewController *pay = [[PayWCViewController alloc]init];
                                pay.Dictionary = self.Dictionary;
                                /// dic 是验证后返回的数据
                                pay.yanzhenDic = dic;
                                pay.imageArray = self.imageArray;
                                pay.paytype = @"1";
                                [self.navigationController pushViewController:pay animated:YES];
                                
                            }else {
                                
                                [OMGToast showWithText:@"文件验证失败！"];
                                ///验证失败后就删除数组里面的值
                                [self.imageArray removeAllObjects];
                                
                                return;
                            }
                            
                        }
                        else if ([object [@"code"] integerValue] == 4014){
                            
                            ///验证失败后就删除数组里面的值
                            [self.imageArray removeAllObjects];
                            [SVProgressHUD dismiss];
                            [OMGToast showWithText:object [@"msg"]];
                            
                        }
                        else{
                            
                            [SVProgressHUD dismiss];
                            [OMGToast showWithText:object [@"msg"]];
                        }
                        
                    } andFailed:^(NSString *object) {
                         [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    }];
                    
                    
                } failureBlock:nil];
            }
            
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
         
                      failureBlock:nil];
    }
}

- (NSString *)getFileName
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyyMMddHHmmss";
    NSString * str              = [formatter stringFromDate:[NSDate date]];
    NSString * fileName         = [NSString stringWithFormat:@"%@.png", str];
    return fileName;
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePaths{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePaths]){
        return [[manager attributesOfItemAtPath:filePaths error:nil] fileSize] / 1024 / 5;
    }
    return 0;
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}
- (void)httprestWithup{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getUserInfo" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            
            [User shareUser].defaultAddressId           = object [@"data"] [@"defaultAddressId"];
            [User shareUser].delCertState               = object [@"data"] [@"delCertState"];
            [User shareUser].delFileState               = object [@"data"] [@"delFileState"];
            [User shareUser].downFileState              = object [@"data"] [@"downFileState"];
            [User shareUser].numExpires                 = object [@"data"] [@"numExpires"];
            [User shareUser].numUsed                    = object [@"data"] [@"numUsed"];
            [User shareUser].restSize                    = object [@"data"] [@"restSize"];
            [User shareUser].securityRestNum            = object [@"data"] [@"securityRestNum"];
            [User shareUser].securityTotalNum           = object [@"data"] [@"securityTotalNum"];
            [User shareUser].securityTotalSize          = object [@"data"] [@"securityTotalSize"];
            [User shareUser].securityUsedNum            = object [@"data"] [@"securityUsedNum"];
            [User shareUser].securityUsedSize           = object [@"data"] [@"securityUsedSize"];
            [User shareUser].sizeExpires                = object [@"data"] [@"sizeExpires"];
            [User shareUser].sizeUsed                   = object [@"data"] [@"sizeUsed"];
            [User shareUser].testRestNum                = object [@"data"] [@"testRestNum"];
            [User shareUser].testTotalNum               = object [@"data"] [@"testTotalNum"];
            [User shareUser].testifyType                = object [@"data"] [@"testifyType"];
            [User shareUser].totalSize                  = object [@"data"] [@"totalSize"];
            [User shareUser].usedStatus                 = object [@"data"] [@"usedStatus"];
            [User shareUser].userAvatar                 = object [@"data"] [@"userAvatar"];
            [User shareUser].userName                   = object [@"data"] [@"userName"];
            [User shareUser].userSex                    = object [@"data"] [@"userSex"];
            [User shareUser].userSn                     = object [@"data"] [@"userSn"];
            [User shareUser].userTel                    = object [@"data"] [@"userTel"];
            [User shareUser].verifyType                 = object [@"data"] [@"verifyType"];
            
            [User saveUserInfo];
            
            NSLog(@"剩余空间:%@",[User shareUser].securityUsedSize);
            
        }else{
            
        }
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}

@end
