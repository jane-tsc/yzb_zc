//
//  PayWCViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/11.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "PayWCViewController.h"
#import "PayWcViewCell.h"
#import "dianziModel.h"
#import "DetailsViewController.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

@interface PayWCViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    UIView *view;
    OSSClient *client;
    
    UIImage *OSSimage;
    NSString *OSSfilePath;
    NSString *OSSmd5;
    NSString *OSSprice;
    NSString *OSStextName;
    NSString *OSSzhao;
    NSString *OSSfilePathlujin;
    
    int inder;

    NSString *fileID;
    NSString *fileIDs;
}
@property(nonatomic,strong) UIButton *backButton;///返回首页
@property(nonatomic,strong)NSData *imageData;
@property(nonatomic,strong)NSMutableDictionary *imagedata;

@property(nonatomic,strong)NSMutableArray *httpArray;

@property(nonatomic,strong)NSMutableArray *fileidArray;
@end

static NSString *kTempFolder = @"temp";

@implementation PayWCViewController

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
    self.title = @"电子保全";
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [self setupView];

    
    self.ListArray = [NSMutableArray array];
    self.httpArray = [NSMutableArray array];
    self.fileidArray = [NSMutableArray array];
    
   
   
    if ([self.paytype isEqualToString:@"1"]) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:self.yanzhenDic];
         NSLog(@"arr ++++++:%@",arr);
        self.ListArray = [dianziModel objectArrayWithKeyValuesArray:arr];
        
        NSLog(@"这是重没有原文件界面跳转过来的1");
        
    }else{
    
       self.ListArray = [dianziModel objectArrayWithKeyValuesArray:self.Dictionary [@"list"]];
    }

    NSLog(@"保全的文件－－－－－－－－：%@",self.Dictionary [@"list"]);
    NSLog(@"images -------------:%@",self.imageArray);
    
    
     ///需要上传的多个图片以数组形式保存 ，将图片保存在数组中
    for (int i = 0; i < self.imageArray.count; i ++) {
        
        OSSimage = [self.imageArray [i] objectForKey:@"image"];
        OSSfilePath = [self.imageArray [i] objectForKey:@"filePath"];
        OSSmd5 = [self.imageArray [i] objectForKey:@"md5"];
        OSStextName = [self.imageArray [i] objectForKey:@"textName"];
        OSSprice = [self.imageArray [i] objectForKey:@"price"];
        OSSzhao = [self.imageArray [i] objectForKey:@"zhao"];
        OSSfilePathlujin = [self.imageArray [i] objectForKey:@"filePathlujin"];
        
        [self.httpArray addObject:OSSfilePathlujin];
    }
    NSLog(@"self.httpDictionary ------:%@",self.httpArray);
    
    
    if ([self.paytype isEqualToString:@"1"]) {
        
        NSString *fle = self.Dictionary [@"certId"];
        
        NSDictionary *ddd = @{@"certId":fle};
        [self.fileidArray addObject:ddd];
        
    }else{
        ///的到文件id
        NSMutableArray *array = self.Dictionary [@"list"];
        NSLog(@"array:%lu",(unsigned long)array.count);
        
        for (int i = 0; i < array.count; i++) {
            NSString *fle = [array [i] objectForKey:@"certId"];
            NSLog(@"fle:%@",fle);
            
            NSDictionary *ddd = @{@"certId":fle};
            
            [self.fileidArray addObject:ddd];
        }
    
    }
    ///拼接后返回的id
    fileIDs = [self.fileidArray JSONString];
    
    
//    NSLog(@"fileIDs ------:%@",fileIDs);
    
//    if ([self.paytype isEqualToString:@"400"])
//    {
//        ///单个图片上传oss 方法
//        [self OSShttpWithup];
//        NSLog(@"fild :%@---image:%@",self.image,self.finder);
//        
//    }
//    else
//    {
        ///上传多个图片
        [self OSSduogeHttpwith];
//    }
  
}
///多个图片上传
- (void)OSSduogeHttpwith{
    
    [self asyncUploadImages:self.httpArray complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (state == 1) {
            [SVProgressHUD dismissWithSuccess:@"保全成功" afterDelay:2.0];
        }
    }];
}

- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    NSLog(@"%@", timeNow);
    return timeNow;
}

- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//字典转data
- (NSData *)returnDataWithDictionary:(NSDictionary *)dict
{
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    return data;
}

- (void)setupView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 200)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [view addSubview:_tableView];
    
    
    UIView *view1= [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [view addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(_tableView.bottom).offset(20);
        make.width.equalTo(screen_width);
        make.height.equalTo(300);
    }];
    
    ///确认支付按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    self.backButton.layer.cornerRadius = 15.0;
    [self.backButton setBackgroundColor:RGB(251, 140, 142)];
    
    ///給按钮添加阴影
    self.backButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.backButton.layer.shadowOpacity = 0.5;
    self.backButton.layer.shadowOffset = CGSizeMake(1, 6);
    
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:self.backButton];
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 4);
        make.top.equalTo(_tableView.bottom).offset(20);
        make.width.equalTo(screen_width / 2);
        make.height.equalTo(30);
    }];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
    PayWcViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[PayWcViewCell alloc]init];
    }
    dianziModel *model =self.ListArray [indexPath.row];
//    NSDictionary *diction = self.imageArray [indexPath.row];
//    cell.image.image = [diction objectForKey:@"image"];
//    cell.imgType.image = [UIImage imageNamed:@"save_all_3_n.png"];
    cell.title.text = model.archiveName;
    cell.time.text = model.securityTime;
    //    NSString *str = [NSString stringWithFormat:@"(%@)",model.archiveName];
    //    cell.endBB.text = str;
    
    ///根据后缀名去判断显示图片类型
    if ([model.fileType isEqualToString:@"10"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanwendang.png"];
    }
    else if([model.fileType isEqualToString:@"20"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquantupian.png"];
    }
    else if ([model.fileType isEqualToString:@"30"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanyingping.png"];
    }
    else if ([model.fileType isEqualToString:@"40"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanshiping.png"];
    }
    else if ([model.fileType isEqualToString:@"50"])
    {
        cell.image.image = [UIImage imageNamed:@"baoquanqita.png"];
    }

    
    if (inder == 2)
    {
        cell.typeNum.text =@"失败";
        cell.typeNum.textColor = RGB(252, 174, 176);
        [cell.csBtn setBackgroundImage:[UIImage imageNamed:@"sx_n.png"] forState:UIControlStateNormal];
        [cell.csBtn addTarget:self action:@selector(csclick:) forControlEvents:UIControlEventTouchUpInside];
    }else if(inder == 1){
        cell.num.text = @"100%";
        cell.typeNum.text =@"成功";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    dianziModel *model =self.ListArray [indexPath.row];
    DetailsViewController *details = [[DetailsViewController alloc]init];
    details.fileid = model.certId;
    //                details.chenggongType = @"1";
    details.labletitle = model.archiveName;
    [self.navigationController pushViewController:details animated:YES];

}

- (void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

#pragma mark -  重新上传按钮
- (void)csclick:(UIButton *)sender{
    
    NSLog(@"重新上传");
    ///OSS上传多个图片
    [self OSSduogeHttpwith];
}


- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}


#pragma 这是上传文件的方法／／／可以直接调用
///单个文件上传
- (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:YES complete:complete];
}

- (void)syncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:NO complete:complete];
}
///多个文件上传
- (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:YES complete:complete];
}

- (void)syncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:NO complete:complete];
}

- (void)uploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [SVProgressHUD showWithStatus:@"托管中..." maskType:SVProgressHUDMaskTypeGradient];
    
    ///oss  上传文件到阿里云
    NSString *endpoint = [NSString stringWithFormat:@"http://%@",[User shareUser].upHost];
    
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [User shareUser].upKeyId;
        token.tSecretKey = [User shareUser].upKeySecret;
        token.tToken = [User shareUser].upToken;
        token.expirationTimeInGMTFormat = [User shareUser].upExpires;
        NSLog(@"get token: %@", token);
        return token;
    }];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2 clientConfiguration:conf];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = [User shareUser].upPath;
                
                NSString *md5Name;
                NSString *fileExt;
                NSString *imageName;
                NSString *path;
                
//                NSLog(@"images++++++++++:%@",images);
             
                if ([self.paytype isEqualToString:@"1"]) {

                    fileExt = [[self.imageArray objectAtIndex:i] objectForKey:@"fileExt"];
                    md5Name = [[self.imageArray objectAtIndex:i] objectForKey:@"md5"];
                    path = [[self.imageArray objectAtIndex:i] objectForKey:@"filePathlujin"];
                    
                     NSLog(@"这是重没有原文件界面跳转过来的2");
                   
                }else{
                    
                    dianziModel *model = self.ListArray [i];
                    fileExt =model.fileExt;
                    md5Name = model.fileHash;
                    path    = model.path;
                }
                
                
                imageName =[NSString stringWithFormat:@"%@%@.%@",[User shareUser].upSubPath,md5Name,fileExt];
                put.objectKey = imageName;
                put.uploadingFileURL = [NSURL URLWithString:path];
                
                [callBackNames addObject:imageName];
                
                NSLog(@"imageName:%@",imageName);
                NSLog(@"path:%@",path);
                NSLog(@"callBackNames;------------:%@",callBackNames);
                
                
//                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                //put.uploadingData = data;
 
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
                    NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                };
                
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                
                
                if (!putTask.error) {
                    [SVProgressHUD dismiss];
                     ///inder ＝ 1   成功的状态
                    
                    NSString *certId;
                    
                    if ([self.paytype isEqualToString:@"1"]) {
                        
//                        certId = self.Dictionary [@"certId"];
                        
                        [self httpOSSwithType:self.Dictionary [@"certId"]];
                         NSLog(@"这是重没有原文件界面跳转过来的3");
                        inder = 1;
                    }else{
                        NSMutableArray *array = self.Dictionary [@"list"];
                        certId = [array [i] objectForKey:@"certId"];
                        [self httpOSSwithType:certId];
                        inder = 1;
                    }
                    ///上传成功后就触发这个方法
//                    [self httpOSSwithType:certId];
                   
                } else {
                    
                    ///inder ＝ 2   失败的状态
                    inder = 2;
                    [SVProgressHUD dismiss];
//                    [SVProgressHUD dismissWithError:@"上传失败！"];
                    ///刷新表格
                    [_tableView reloadData];
                    NSLog(@"上传失败！, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (image == images.lastObject) {
                        NSLog(@"上传文件完成！");
                        if (complete) {
                            complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        NSLog(@"haha");
        if (complete) {
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
            }
        }
    }
}

///上传成功后触发这个方法
- (void)httpOSSwithType:(NSString *)certId{
   
    [[TSCCntc sharedCntc] queryWithPoint:@"setFileStorage" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&certId=%@&actType=%@",[User shareUser].appKey,[User shareUser].authToken,certId,@"1"] andURL:@"Cert" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD dismissWithSuccess:@"保全成功" afterDelay:2.0];
            [_tableView reloadData];
            
            NSLog(@"上传成功!");
        }else{
            [SVProgressHUD dismiss];
            //                            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];

}


#pragma mark - 转换为JSON
- (NSData *)JSONData
{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self JSONObject] options:kNilOptions error:nil];
}

- (id)JSONObject
{
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]]) {
        return self;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    
    return self.keyValues;
}

- (NSString *)JSONString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

- (void)NavigationBackItemClick{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

@end
