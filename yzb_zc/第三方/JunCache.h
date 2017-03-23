

#import <Foundation/Foundation.h>

@interface JunCache : NSObject

/// 获得本地图片文件夹缓存大小
+ (long)getLocalImageCacheSize;
/// 清空本地图片缓存文件夹
+ (BOOL)clearLocalImagesCache;


@end
