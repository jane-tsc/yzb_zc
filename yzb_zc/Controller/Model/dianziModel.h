//
//  dianziModel.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/17.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dianziModel : NSObject
@property (nonatomic,copy)NSString *archiveName;
@property (nonatomic,copy)NSString *certId;
@property (nonatomic,copy)NSString *certSn;
@property (nonatomic,copy)NSString *fileHash;
@property (nonatomic,copy)NSString *fileExt;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString *fileSize;
@property (nonatomic,copy)NSString *fileStorage;
@property (nonatomic,copy)NSString *fileType;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,copy)NSString *path;
@property (nonatomic,copy)NSString *result;
@property (nonatomic,copy)NSString *securityExpires;
@property (nonatomic,copy)NSString *securityTime;
@end
