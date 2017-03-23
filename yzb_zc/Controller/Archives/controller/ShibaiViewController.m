//
//  ShibaiViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/24.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "ShibaiViewController.h"
#import "ResultsViewController.h"
#import "MyMD5.h"
#import "WsqMD5Util.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ShibaiViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    UIImage *yanzImage;///验证选择的图片
//    NSString * size;///图片大小
//    NSString *md5image;///图片的哈希值
//     NSString* filePath;
    
}
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIButton *chongshiButton;///重试按钮
@end

@implementation ShibaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ///设置导航栏上面的字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"保全验证";
    [self setupView];
}

- (void) setupView{
    //   pull_n@2x.png
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(view.top);
        make.width.equalTo(view.width);
        make.height.equalTo(screen_height - 160);
    }];
    NSString *path = [NSString stringWithFormat:@"%@View/verifyResult?verifyAuth=%@",HttpUrl,self.data [@"verifyAuth"]];
    NSLog(@"path ：－－－－－－－－－－－%@",path);
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    
    ///重新选择
    self.chongshiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chongshiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.chongshiButton setTitle:@"重新验证" forState:UIControlStateNormal];
    self.chongshiButton.layer.cornerRadius = 18.0;
    [self.chongshiButton setBackgroundColor:RGB(252, 174, 176)];
    self.chongshiButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.chongshiButton.layer.shadowOpacity = 0.5;
    self.chongshiButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.chongshiButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.chongshiButton];
    [self.chongshiButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(100);
        make.top.equalTo(self.webView.bottom).offset(30);
        make.width.equalTo(screen_width - 200);
        make.height.equalTo(35);
    }];
    
    
    [self.chongshiButton addTarget:self action:@selector(chongshiButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
}

#define 重新选择
- (void)chongshiButtonClick1:(UIButton *)sender{

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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [OMGToast showWithText:@"取消选择"];
    return;
}
#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate  // 选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
    [picker dismissViewControllerAnimated:YES completion:nil];
    
if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    ///得到路径和图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSDatas
        yanzImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        ///得到图片原来的名称
        __block NSString *imagesss;
        __block double size;
        
        NSURL *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            imagesss = [representation filename];
            NSLog(@"图片名称＋＋＋＋＋＋＋＋＋＋＋＋＋::%@",imagesss);
            
            NSURL *urlname = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            
            __block NSData *data;
            __block NSString *md5image;
            __block  NSString * imagePath;
            __block NSUInteger buffered;
            __block  NSString *buff;
            __block  NSString *fileExt;
            __block  NSString *certId;
            __block NSString *s;
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
                    
                    NSLog(@"data.length -:%lu",(unsigned long)data.length);
                    
                    s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                    
                    float floatString = [s floatValue];
                    
                    size = floatString / (1024 * 1024);
                    
                    NSLog(@"size:%.2lf",size);
                    
                    buff = [NSString stringWithFormat:@"%.2lf",size];
                    
                    NSLog(@"图片大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@ - :%lu",buff,(unsigned long)buffered);
                    
                    ///文件原名
                    NSLog(@"imagesss:%@",imagesss);
                    /// md5 加密
                    md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                    ///字节数
                    NSLog(@"buffered:%lu",(unsigned long)buffered);
                    /// 后缀名
                    fileExt = self.Dictionary [@"fileExt"];
                    ///id
                    certId = self.Dictionary [@"certId"];
                    
                    NSLog(@"imagesss:%@,md5image:%@,buffered:%lu,fileExt:%@,certId:%@",imagesss,md5image,(unsigned long)buffered,fileExt,certId);

///================================清除沙盒路径============================
                    [AllObject clearCacheWithFilePath:imagePath];
                    
                    [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeGradient];
                    [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,certId,md5image,imagesss,(unsigned long)buffered,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                        
                        if ([object [@"code"] integerValue] == 200) {
                            [SVProgressHUD dismiss];
                            NSDictionary *dic = object[@"data"];
                            
                            if ([dic [@"verifyResult"] intValue]== 1)
                            {
                                
                                ResultsViewController *result = [[ResultsViewController alloc]init];
                                result.Dictionary = self.Dictionary;
                                result.image = yanzImage;
                                result.data = dic ;
                                [self.navigationController pushViewController:result animated:YES];
                                
                            }
                            else if ([dic [@"verifyResult"] intValue]== 0){
                                
                                ShibaiViewController *shibai = [[ShibaiViewController alloc]init];
                                shibai.Dictionary =  self.Dictionary;
                                shibai.image = yanzImage;
                                shibai.data = dic;
                                [self.navigationController pushViewController:shibai animated:YES];
                                
                            }
                            
                        }else{
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showErrorWithStatus:@"操作失败！" duration:2.0];
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
}else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
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
                md5image = [WsqMD5Util getFileMD5WithPath:imagePath];
                ///计算图片大小
                s = [NSString stringWithFormat:@"%ld",(unsigned long)buffered];
                
                float floatString = [s floatValue];
                
                size = floatString / (1024 * 1024);
                
                NSLog(@"size:%.2lf",size);
                buff = [NSString stringWithFormat:@"%.2lf",size];
                /// 后缀名
                fileExt = self.Dictionary [@"fileExt"];
                
                NSLog(@"视频的图片++++++++++++++++++++++:%@",image);
                NSLog(@"视频的名字++++++++++++++++++++++:%@",imagesss);
                NSLog(@"视频的大小＋＋＋＋＋＋＋＋＋＋＋＋＋：%@",buff);
                NSLog(@"视频的md5++++++++++++++++++++++:%@",md5image);
                NSLog(@"视频的路径++++++++++++++++++++++:%@",imagePath);
                NSLog(@"视频的s++++++++++++++++++++++:%@",s);

///================================清除沙盒路径============================
                [AllObject clearCacheWithFilePath:imagePath];
                
                [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeGradient];
                [[TSCCntc sharedCntc] queryWithPoint:@"doSend" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&fileHash=%@&fileName=%@&fileSize=%lu&fileExt=%@",[User shareUser].appKey,[User shareUser].authToken,self.Dictionary [@"certId"],md5image,imagesss,(unsigned long)buffered,fileExt] andURL:@"Verify" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [SVProgressHUD dismiss];
                        NSDictionary *dic = object[@"data"];
                        
                        if ([dic [@"verifyResult"] intValue]== 1)
                        {
                            
                            ResultsViewController *result = [[ResultsViewController alloc]init];
                            result.Dictionary = self.Dictionary;
                            result.image = yanzImage;
                            result.data = dic ;
                            [self.navigationController pushViewController:result animated:YES];
                            
                        }
                        else if ([dic [@"verifyResult"] intValue]== 0){
                            
                            ShibaiViewController *shibai = [[ShibaiViewController alloc]init];
                            shibai.Dictionary =  self.Dictionary;
                            shibai.image = yanzImage;
                            shibai.data = dic;
                            [self.navigationController pushViewController:shibai animated:YES];
                            
                        }
                        
                    }else{
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showErrorWithStatus:@"操作失败！" duration:2.0];
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

- (void)NavigationBackItemClick{
    
    if ([self.shibaiType isEqualToString:@"0"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}


@end
