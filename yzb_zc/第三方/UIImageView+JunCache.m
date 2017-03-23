
#import "UIImageView+JunCache.h"

@implementation UIImageView (JunCache)

- (void)setCacheImageAddress:(NSString *)imageAdress withplaceholderImage:(NSString *)placeHolder
{
    if (imageAdress.length  != 0)
    {
        // 设置默认图片
        self.image           = [UIImage imageNamed:placeHolder];
        //确定图片的缓存地址
        NSArray * path       = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString * docDir    = [path objectAtIndex:0];
        NSString * tmpPath   = [docDir stringByAppendingPathComponent:@"AdailyShop"];
        NSFileManager *fm    = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray * lineArray;
        if ([imageAdress rangeOfString:@"http://tp3.sinaimg.cn"].length > 0)
        {
            lineArray          = [imageAdress componentsSeparatedByString:@"http://tp3.sinaimg.cn/"];
        }
        else if ([imageAdress rangeOfString:@"http://wx.qlogo.cn/mmopen/"].length > 0)
        {
            lineArray          = [imageAdress componentsSeparatedByString:@"http://wx.qlogo.cn/mmopen/"];
        }
        else if ([imageAdress rangeOfString:@"http://qzapp.qlogo.cn/"].length > 0)
        {
            lineArray          = [imageAdress componentsSeparatedByString:@"qzapp/"];
        }
        else
        {
            lineArray          = [imageAdress componentsSeparatedByString:@"upload/"];
        }
        
        
        NSString * subString   = [[lineArray objectAtIndex:[lineArray count] - 1] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString * imagePath   = [NSString stringWithFormat:@"%@/%@", tmpPath, subString];
        
        if ([imageAdress rangeOfString:@"http://wx.qlogo.cn/"].length > 0)
        {
            imagePath          = [NSString stringWithFormat:@"%@.png",imagePath];
        }
        
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            //下载图片，保存到本地缓存中
            NSString * logoUrl          = imageAdress;
            NSURL *imgurl               = [NSURL URLWithString:logoUrl];
            NSURLRequest *request       = [NSURLRequest requestWithURL:imgurl];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                 if (res.statusCode     == 200)
                 {
                     NSError * error;
                     [data writeToFile:imagePath options:NSDataWritingAtomic error:&error];
                     UIImage *img       = [UIImage imageWithData:data];
                     self.image         = img;
                 }
                 else
                 {
                     self.image         = [UIImage imageNamed:placeHolder];
                     NSLog(@"_______图片下载失败");
                 }
             }];
        }
        else
        {
            //本地缓存中已经存在，直接指定请求的网络图片
            self.image              = [UIImage imageWithContentsOfFile:[imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    else
    {
        self.image                  = [UIImage imageNamed:placeHolder];
    }
}


@end
