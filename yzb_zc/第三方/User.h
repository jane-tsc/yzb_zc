//
//  User.h
//  AdailyShop
//
//  Created by 重庆阿达西科技有限公司 on 15/9/21.
//  Copyright (c) 2015年 com.adaxi.AdailyShop. All rights reserved.
/* A Da Xi of Chongqing Science and Technology Co., Ltd. is a high-tech enterprise specialized in software development and its affiliated sales of electronic products. Is a professional engaged in software development, software customization, software implementation of high-tech enterprises.
 The company has a number of long-term professional engaged in software development, software customization of professional personnel, with strong technology development strength, the full range of government and business information needs.
 Company's purpose: scientific and technological innovation, excellence, pioneering and enterprising, pragmatic and efficient.
 Business philosophy: people-oriented, integrity, mutual benefit.
 Service tenet: "the first-class technology, the first-class product, the thoughtful customer service" is our tenet. "Customer satisfaction" is our eternal pursuit.
 Main business: website development and maintenance, software outsourcing, software customization development, system maintenance, OA office systems, mobile APP customization, micro channel two development, etc..
 The language used include: JAVA/JSF/JSP,.NET, VB/VBA, OC, Swift, PHP, etc..
 The company's business goal is to become a leader in the software development market, innovative technology, developed a series of popular consumer favorite software. */

#import <Foundation/Foundation.h>
#import "Public.h"
@interface User : NSObject

///appKey
@property (nonatomic,copy)NSString *appKey;
///authToken
@property (nonatomic,copy)NSString *authToken;
///地址id
@property (nonatomic,copy)NSString *defaultAddressId;
@property (nonatomic,copy)NSString *delCertState;
@property (nonatomic,copy)NSString *delFileState;
@property (nonatomic,copy)NSString *downFileState;
@property (nonatomic,copy)NSString *numExpires;
@property (nonatomic,copy)NSString *numUsed;
@property (nonatomic,copy)NSString *restSize;
@property (nonatomic,copy)NSString *securityRestNum;
@property (nonatomic,copy)NSString *securityTotalNum;
@property (nonatomic,copy)NSString *securityTotalSize;
@property (nonatomic,copy)NSString *securityUsedNum;
@property (nonatomic,copy)NSString *securityUsedSize;
@property (nonatomic,copy)NSString *sizeExpires;
@property (nonatomic,copy)NSString *sizeUsed;
@property (nonatomic,copy)NSString *testRestNum;
@property (nonatomic,copy)NSString *testTotalNum;
@property (nonatomic,copy)NSString *testifyType;
@property (nonatomic,copy)NSString *totalSize;
@property (nonatomic,copy)NSString *usedSize;
@property (nonatomic,copy)NSString *usedStatus;

///极光别名
@property (nonatomic,copy)NSString *msgId;

@property (nonatomic,copy)NSString *verifyType;
///电话
@property (nonatomic,copy)NSString *userTel;
///名字
@property (nonatomic,copy)NSString *userName;
///头像地址
@property (nonatomic,copy)NSString *userAvatar;
///性别
@property (nonatomic,copy)NSString *userSex;
///身份证号
@property (nonatomic,copy)NSString *userSn;


///所在省
@property (nonatomic,copy)NSString *addressShen;
@property (nonatomic,copy)NSString *addressShenID;
///地址市
@property (nonatomic,copy)NSString *addressShi;
@property (nonatomic,copy)NSString *addressShiID;

///地址区／县
@property (nonatomic,copy)NSString *addressQu;
@property (nonatomic,copy)NSString *addressQuID;

///详细地址
@property (nonatomic,copy)NSString *addressDetailed;


///密码验证状态／指纹验证状态
@property (nonatomic,assign)int zhenshuDelete;
@property (nonatomic,assign)int zhengshuchuzheng;
@property (nonatomic,assign)int yuanwenjianxiazai;
@property (nonatomic,assign)int yuanwenjianDelete;
@property (nonatomic,assign)int RenlianType;
@property (nonatomic,assign)int fingerprint;


///OSS  上传临时授权保存的信息
@property (nonatomic,copy)NSString *upCallBack;
@property (nonatomic,copy)NSString *upExpires;
@property (nonatomic,copy)NSString *upHost;
@property (nonatomic,copy)NSString *upKeyId;
@property (nonatomic,copy)NSString *upKeySecret;
@property (nonatomic,copy)NSString *upPath;
@property (nonatomic,copy)NSString *upSubPath;
@property (nonatomic,copy)NSString *upToken;


///不再提醒状态
@property (nonatomic,assign) int Noremind;
@property (nonatomic,assign) int zhengshuchuzhengNoremind;
@property (nonatomic,assign) int yuanwenjianxiazaiNoremind;
@property (nonatomic,assign) int yuanwenjianshanchuNoremind;

//// 用户单例
+ (instancetype)shareUser;

/// 退出登录
+ (void)exitSign;

/// 将用户信息存进本地
+ (void)saveUserInfo;

/// 设置推送别名
- (void)setTagAlias;

@end
