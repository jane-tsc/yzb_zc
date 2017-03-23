//
//  AllObject.h
//  
//
//  Created by gd on 15/7/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Public.h"
@interface AllObject : NSObject
///转json字符串
+(NSString*)DataTOjsonString:(id)object;
///添加点击事件
+(void)setTapclicl:(SEL)_selector andtarget:(id)target addObserver:(id)server;

///计算时间
+(NSString *)getUTCFormateDate:(NSString *)newsDate;
///画圆
+(void)setYuan:(id )tage andflat:(double )fl;
///获取控件在那个位置
+(NSIndexPath *)GetCellIndexPath:(id)view;
///画线
+(UIView *)addLine:(CGRect)frame;
/// 去掉表格多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
/// 返回ImageView
+ (UIImageView *)getIamgeViewWithImageName:(NSString *)imageName;

/// 去掉单元格选中样式
+ (void)clearTableViewSelectedStyle:(UITableView *)tableView;
// 计算Label占用的长宽
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font andwidth:(CGFloat )width;

///判断是不是输入的手机号
+ (NSString *)valiMobile:(NSString *)mobile;


///判断是不是合法身份证
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;
+ (BOOL)verificationPhoneNumber:(NSString *)phoneNumber;

// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;

/// 判断字符串是否有值
+ (BOOL)isBlankString:(NSString *)string;

+(BOOL )sendImage:(NSData *)data1 boundry:(NSString *)boundry;


/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;



@end
