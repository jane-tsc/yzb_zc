

#import <UIKit/UIKit.h>

@interface UIImageView (JunCache)

/// 异步缓存加载网络图片 并缓存到本地文件夹
- (void)setCacheImageAddress:(NSString *)imageAdress withplaceholderImage:(NSString *)placeHolder;

@end
