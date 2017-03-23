//
//  MyViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "MyViewController.h"
#import "myViewCell.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extensions.h"
#import "ViewController.h"
#import "TestViewController.h"
typedef void(^success)(id success);

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>{
    UITableView *_tableView;
    MBProgressHUD * _HUD;
    UIButton * _leftItem;
    
    //图片2进制路径
    NSString* filePath;
    
    NSString *BOUNDRY;
    
    //id _success;
    
    
    NSMutableURLRequest *_request;
    
    NSURLConnection *_urlConnection;
    
    
    NSString *StringHeading;
    
    UIView *view;
    
}
@property (nonatomic ,strong) NSMutableArray *sexArray;

@property(nonatomic,copy)success _success;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

//上传进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //修改为导航栏一下开始显示
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    UILabel *navtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, screen_width, 44)];
    navtitle.text =@"个人资料";
    navtitle.userInteractionEnabled = YES;
    navtitle.textColor = [UIColor blackColor];
    navtitle.font = [UIFont systemFontOfSize:NacFontsize];
    navtitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:navtitle];
    UIView *hen = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screen_width, 0.5)];
    hen.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navView addSubview:hen];
    
    //    self.title = @"个人资料";
    [self setWithTableView];
    
    _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_leftItem setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    _leftItem.frame = CGRectMake(25, 32, 12, 18);
    _leftItem.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _leftItem.backgroundColor = [UIColor clearColor];
    _leftItem.titleEdgeInsets = UIEdgeInsetsMake(19, 15, 5, -8);
    [_leftItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NavigationfanhuiClick)]];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftItem];
    [navView addSubview:_leftItem];
    
    self.sexArray = [[NSMutableArray alloc]init];
    
    BOUNDRY = @"0xKhTmLbOuNdArY";
    
}
///个人中心有点特殊， 这个是个人中心返回到首页的方法
- (void)NavigationfanhuiClick
{
    TestViewController *home = [[TestViewController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:home animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    ///一离开这个界面就不隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}



- (void)setWithTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    myViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[myViewCell alloc]init];
    }
    [cell configWithindexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            NSLog(@"[User shareUser].userAvatar:%@",[User shareUser].userAvatar);
            
            if ([[User shareUser].userAvatar isEqualToString:@""] || [User shareUser].userAvatar == nil) {
                
                cell.headimg.image = [UIImage imageNamed:@"tx_bg_nor@2x(1).png"];
            }
            else
            {
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSURL *url = [NSURL URLWithString:[User shareUser].userAvatar];
                    
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.headimg.image = [UIImage imageWithData:data];
                        
                    });
                    
                });
            }
        }
    }
    cell.name.text = [User shareUser].userName;
    if ([[User shareUser].userSex integerValue] == 0) {
        cell.sex.text = @"未设置";
    }else if ([[User shareUser].userSex integerValue] == 1){
        cell.sex.text = @"女";
    }else if ([[User shareUser].userSex integerValue] == 2){
        cell.sex.text = @"男";
    }
    cell.idcar.text = [User shareUser].userSn;;
    cell.phone.text = [User shareUser].userTel;;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 65;
    }else{
        return 55;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"请选择"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照",@"手机相册",nil];
            actionSheet.tag = 101;
            
            [actionSheet showInView:self.view];
            
        }else if (indexPath.row == 2){
            
            UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"请选择"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"男",@"女",nil];
            actionSheet.tag = 102;
            
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        
        NSLog(@"您点中了选择头像选项");
        
        switch (buttonIndex) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
            case 1://手机相册
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //			[self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
        
    }else if(actionSheet.tag == 102){
        
        NSLog(@"您点中了了男女选项");
        
        switch (buttonIndex) {
            case 0://照相机
            {
                ///  1 女    2 男
                [[TSCCntc sharedCntc] queryWithPoint:@"setSex" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&userSex=%@",[User shareUser].appKey,[User shareUser].authToken,@"2"] andURL:@"User" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        ///用单列模式存储appkey
                        [User shareUser].userSex    = object [@"data"][@"userSex"];
                        [User saveUserInfo];
                        
                        [_tableView reloadData];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                NSLog(@"男");
            }
                break;
            case 1://手机相册
            {
                ///  1 女    2 男
                [[TSCCntc sharedCntc] queryWithPoint:@"setSex" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&userSex=%@",[User shareUser].appKey,[User shareUser].authToken,@"1"] andURL:@"User" andSuccessCompletioned:^(id object) {
                    
                    if ([object [@"code"] integerValue] == 200) {
                        [OMGToast showWithText:@"修改成功"];
                        [User shareUser].userSex    = object [@"data"][@"userSex"];
                        [User saveUserInfo];
                        [_tableView reloadData];
                    }else{
                        [OMGToast showWithText:object[@"msg"]];
                    }
                    
                } andFailed:^(NSString *object) {
                     [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }];
                NSLog(@"女");
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate  // 选中图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    ///得到路径和图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        //把图片转换为NSData
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/head.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/head.png"];
        NSLog(@"filePath :%@---------:image:%@ ------- ",filePath,image);
        
        [SVProgressHUD showWithStatus:@"正在上传头像" maskType:SVProgressHUDMaskTypeGradient];
        
        //AFN3.0+基于封住HTPPSession的句柄
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSDictionary *dict = @{@"appKey":[User shareUser].appKey,@"authToken":[User shareUser].authToken};
        //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据
        [manager POST:@"http://test.yzzdata.com/App/V1/User/setAvatar" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:data name:@"userAvatar" fileName:fileName mimeType:@"image/png"];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject [@"code"] integerValue] == 200) {
                
                NSLog(@"responseObject:%@",responseObject);
                
                NSDictionary *dic =responseObject [@"data"];
                
                [User shareUser].userAvatar = dic [@"userAvatar"];
                NSLog(@"头像地址：%@",[User shareUser].userAvatar);
                [User saveUserInfo];
                
                ///回到主线程跟新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI
                    [_tableView reloadData];
                });
                
                [SVProgressHUD dismiss];
                [SVProgressHUD dismissWithSuccess:@"头像上传成功" afterDelay:2.0];
                NSLog(@"StringHeading:%@",responseObject [@"data"] [@"userAvatar"]);
                
            }
            else
            {
                [SVProgressHUD dismissWithError:@"设置头像失败" afterDelay:2.0];
                NSLog(@"上传失败");
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"上传失败 %@", error);
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)getFileName
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyyMMddHHmmss";
    NSString * str              = [formatter stringFromDate:[NSDate date]];
    NSString * fileName         = [NSString stringWithFormat:@"%@.png", str];
    return fileName;
}
//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
