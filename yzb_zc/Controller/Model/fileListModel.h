//
//  fileListModel.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/20.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileListModel : NSObject
@property(nonatomic,copy)NSString *archiveName;
@property(nonatomic,copy)NSString *certId;
@property(nonatomic,copy)NSString *dirId;
@property(nonatomic,copy)NSString *fileExt;
@property(nonatomic,copy)NSString *fileSize;
@property(nonatomic,copy)NSString *fileType;
@property(nonatomic,copy)NSString *listType;
@property(nonatomic,copy)NSString *remarks;
@property(nonatomic,copy)NSString *securityExpires;
@property(nonatomic,copy)NSString *securityTime;
@property(nonatomic,copy)NSString *storageFlag;
@property(nonatomic,copy)NSString *storageState;
@property(nonatomic,copy)NSString *usedStatus;
@end
