

#import "JunCache.h"

@implementation JunCache

+ (long)getLocalImageCacheSize
{
    NSArray * path     = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString * docDir  = [path objectAtIndex:0];
    NSString * tmpPath = [docDir stringByAppendingPathComponent:@"AdailyShop"];
    NSFileManager *fm  = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:tmpPath])
    {
        return 0;
    }
    else
    {
        return (long)[[fm attributesOfItemAtPath:tmpPath error:nil] fileSize];
    }
    
}
+ (BOOL)clearLocalImagesCache
{
    NSArray * path     = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString * docDir  = [path objectAtIndex:0];
    NSString * tmpPath = [docDir stringByAppendingPathComponent:@"AdailyShop"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:tmpPath])
    {
        return NO;
    }
    else
    {
        BOOL blDele= [fm removeItemAtPath:tmpPath error:nil];
        if (blDele)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}






@end
