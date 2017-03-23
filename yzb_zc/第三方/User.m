//
//  User.m
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

#import "User.h"

@implementation User

static User * sharedUser = nil;

+ (instancetype)shareUser
{
    @synchronized(self)
    {
        if (sharedUser   == nil)
        {
            sharedUser   = [[User alloc]init];
        }
    }
    return sharedUser;
}

+ (void)exitSign
{
    [User shareUser].appKey                 =@"";
    [User shareUser].authToken              =@"";
    [User shareUser].userTel                =@"";
    [User shareUser].userName               =@"";
    [User shareUser].userAvatar             =@"";
    [User shareUser].userSex                =@"";
    [User shareUser].defaultAddressId       =@"";
    [User shareUser].userSn                 =@"";
    [User shareUser].addressShen            =@"";
    [User shareUser].addressShi             =@"";
    [User shareUser].addressQu              =@"";
    [User shareUser].addressDetailed        =@"";
    [User shareUser].addressShenID          =@"";
    [User shareUser].addressShiID           =@"";
    [User shareUser].addressQuID            =@"";
    
    [User shareUser].zhenshuDelete          =0;
    [User shareUser].zhengshuchuzheng       =0;
    [User shareUser].yuanwenjianxiazai      =0;
    [User shareUser].yuanwenjianDelete      =0;
    [User shareUser].RenlianType            =0;
    [User shareUser].fingerprint            =0;
    [User shareUser].Noremind               =0;
    [User shareUser].zhengshuchuzhengNoremind               =0;
    [User shareUser].yuanwenjianxiazaiNoremind               =0;
    [User shareUser].yuanwenjianshanchuNoremind               =0;
    
    
    [User shareUser].upExpires              =@"";
    [User shareUser].upHost                 =@"";
    [User shareUser].upKeyId                =@"";
    [User shareUser].upKeySecret            =@"";
    [User shareUser].upPath                 =@"";
    [User shareUser].upSubPath              =@"";
    [User shareUser].upToken                =@"";
    [User shareUser].upCallBack             =@"";
    
    [User shareUser].delCertState           =@"";
    [User shareUser].delFileState           =@"";
    [User shareUser].downFileState          =@"";
    [User shareUser].numExpires             =@"";
    [User shareUser].numUsed                =@"";
     [User shareUser].restSize              =@"";
    [User shareUser].securityRestNum        =@"";
    [User shareUser].securityTotalNum       =@"";
    [User shareUser].securityTotalSize      =@"";
    [User shareUser].securityUsedNum        =@"";
    [User shareUser].securityUsedSize       =@"";
    
    [User shareUser].sizeExpires            =@"";
    [User shareUser].sizeUsed               =@"";
    [User shareUser].testRestNum            =@"";
    [User shareUser].testTotalNum           =@"";
    [User shareUser].testifyType            =@"";
    [User shareUser].usedStatus             =@"";
    
    [User shareUser].totalSize              =@"";
    [User shareUser].usedSize               =@"";
    [User shareUser].verifyType             =@"";
    [User shareUser].msgId                  = @"";
    
    [NSUserDeFaults setBool:NO forKey:LOGINED];
    [NSUserDeFaults setObject:nil forKey:AdailyShopUser];
    [NSUserDeFaults synchronize];
}

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_appKey                forKey:@"appKey"];
    [aCoder encodeObject:_msgId                forKey:@"msgId"];
    [aCoder encodeObject:_authToken             forKey:@"authToken"];
    [aCoder encodeObject:_userTel               forKey:@"userTel"];
    [aCoder encodeObject:_userName              forKey:@"userName"];
    [aCoder encodeObject:_userAvatar            forKey:@"userAvatar"];
    [aCoder encodeObject:_userSex               forKey:@"userSex"];
    [aCoder encodeObject:_defaultAddressId      forKey:@"defaultAddressId"];
    [aCoder encodeObject:_userSn                forKey:@"userSn"];
    [aCoder encodeObject:_addressShen           forKey:@"addressShen"];
    [aCoder encodeObject:_addressShenID         forKey:@"addressShenID"];
    [aCoder encodeObject:_addressShi            forKey:@"addressShi"];
    [aCoder encodeObject:_addressShiID          forKey:@"addressShiID"];
    [aCoder encodeObject:_addressQu             forKey:@"addressQu"];
    [aCoder encodeObject:_addressQuID           forKey:@"addressQuID"];
    [aCoder encodeObject:_addressDetailed       forKey:@"addressDetailed"];
    
    [aCoder encodeObject:[NSNumber numberWithDouble:self.zhenshuDelete]         forKey:@"zhenshuDelete"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.zhengshuchuzheng]      forKey:@"zhengshuchuzheng"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.yuanwenjianxiazai]     forKey:@"yuanwenjianxiazai"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.yuanwenjianDelete]     forKey:@"yuanwenjianDelete"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.RenlianType]           forKey:@"RenlianType"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.fingerprint]           forKey:@"fingerprint"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.Noremind]           forKey:@"Noremind"];
     [aCoder encodeObject:[NSNumber numberWithDouble:self.zhengshuchuzhengNoremind]           forKey:@"zhengshuchuzhengNoremind"];
     [aCoder encodeObject:[NSNumber numberWithDouble:self.yuanwenjianshanchuNoremind]           forKey:@"yuanwenjianshanchuNoremind"];
     [aCoder encodeObject:[NSNumber numberWithDouble:self.yuanwenjianxiazaiNoremind]           forKey:@"yuanwenjianxiazaiNoremind"];
    
    
    [aCoder encodeObject:_upExpires             forKey:@"upExpires"];
    [aCoder encodeObject:_upHost                forKey:@"upHost"];
    [aCoder encodeObject:_upKeyId               forKey:@"upKeyId"];
    [aCoder encodeObject:_upKeySecret           forKey:@"upKeySecret"];
    [aCoder encodeObject:_upPath                forKey:@"upPath"];
    [aCoder encodeObject:_upSubPath             forKey:@"upSubPath"];
    [aCoder encodeObject:_upToken               forKey:@"upToken"];
    [aCoder encodeObject:_upCallBack            forKey:@"upCallBack"];
    [aCoder encodeObject:_delCertState          forKey:@"delCertState"];
    [aCoder encodeObject:_delFileState          forKey:@"delFileState"];
    [aCoder encodeObject:_downFileState         forKey:@"downFileState"];
    [aCoder encodeObject:_numExpires               forKey:@"numExpires"];
    [aCoder encodeObject:_numUsed               forKey:@"numUsed"];
    [aCoder encodeObject:_restSize               forKey:@"restSize"];
    [aCoder encodeObject:_securityRestNum       forKey:@"securityRestNum"];
    [aCoder encodeObject:_securityTotalNum      forKey:@"securityTotalNum"];
    [aCoder encodeObject:_securityTotalSize     forKey:@"securityTotalSize"];
    [aCoder encodeObject:_securityUsedNum      forKey:@"securityUsedNum"];
    [aCoder encodeObject:_securityUsedSize      forKey:@"securityUsedSize"];
    [aCoder encodeObject:_sizeUsed              forKey:@"sizeUsed"];
    [aCoder encodeObject:_testRestNum           forKey:@"testRestNum"];
    [aCoder encodeObject:_testTotalNum          forKey:@"testTotalNum"];
    [aCoder encodeObject:_testifyType           forKey:@"testifyType"];
    [aCoder encodeObject:_usedStatus            forKey:@"usedStatus"];
    [aCoder encodeObject:_totalSize            forKey:@"totalSize"];
    [aCoder encodeObject:_usedSize            forKey:@"usedSize"];
    [aCoder encodeObject:_verifyType            forKey:@"verifyType"];
    
}
// 解档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        
        
        _msgId=                     [aDecoder decodeObjectForKey:@"msgId"];
        _delCertState=              [aDecoder decodeObjectForKey:@"delCertState"];
        _delFileState=              [aDecoder decodeObjectForKey:@"delFileState"];
        _downFileState=             [aDecoder decodeObjectForKey:@"downFileState"];
        _numUsed=                   [aDecoder decodeObjectForKey:@"numUsed"];
         _numExpires=               [aDecoder decodeObjectForKey:@"numExpires"];
        _restSize=                  [aDecoder decodeObjectForKey:@"restSize"];
        _securityRestNum=           [aDecoder decodeObjectForKey:@"securityRestNum"];
        _securityTotalNum=          [aDecoder decodeObjectForKey:@"securityTotalNum"];
        _securityTotalSize=         [aDecoder decodeObjectForKey:@"securityTotalSize"];
        _securityUsedSize=          [aDecoder decodeObjectForKey:@"securityUsedSize"];
        _securityUsedNum=           [aDecoder decodeObjectForKey:@"securityUsedNum"];
        _sizeExpires=               [aDecoder decodeObjectForKey:@"sizeExpires"];
        _sizeUsed=                  [aDecoder decodeObjectForKey:@"sizeUsed"];
        _testRestNum=               [aDecoder decodeObjectForKey:@"testRestNum"];
        _testTotalNum=              [aDecoder decodeObjectForKey:@"testTotalNum"];
        _testifyType=               [aDecoder decodeObjectForKey:@"testifyType"];
        _totalSize=                 [aDecoder decodeObjectForKey:@"totalSize"];
        _verifyType=                [aDecoder decodeObjectForKey:@"verifyType"];
        _usedStatus=                [aDecoder decodeObjectForKey:@"usedStatus"];
        _appKey=                    [aDecoder decodeObjectForKey:@"appKey"];
        _authToken=                 [aDecoder decodeObjectForKey:@"authToken"];
        _userTel=                   [aDecoder decodeObjectForKey:@"userTel"];
        _userName=                  [aDecoder decodeObjectForKey:@"userName"];
        _userAvatar=                [aDecoder decodeObjectForKey:@"userAvatar"];
        _userSex=                   [aDecoder decodeObjectForKey:@"userSex"];
         _usedSize=                 [aDecoder decodeObjectForKey:@"usedSize"];
        _defaultAddressId=          [aDecoder decodeObjectForKey:@"defaultAddressId"];
        _userSn=                    [aDecoder decodeObjectForKey:@"userSn"];
        _addressShen=               [aDecoder decodeObjectForKey:@"addressShen"];
        _addressShi=                [aDecoder decodeObjectForKey:@"addressShi"];
        _addressQu=                 [aDecoder decodeObjectForKey:@"addressQu"];
        _addressDetailed=           [aDecoder decodeObjectForKey:@"addressDetailed"];
        _addressShenID=             [aDecoder decodeObjectForKey:@"addressShenID"];
        _addressShiID=              [aDecoder decodeObjectForKey:@"addressShiID"];
        _addressQuID=               [aDecoder decodeObjectForKey:@"addressQuID"];
        _zhenshuDelete=             [[aDecoder decodeObjectForKey:@"zhenshuDelete"] intValue];
        _zhengshuchuzheng=          [[aDecoder decodeObjectForKey:@"zhengshuchuzheng"] intValue];
        _yuanwenjianxiazai=         [[aDecoder decodeObjectForKey:@"yuanwenjianxiazai"] intValue];
        _yuanwenjianDelete=         [[aDecoder decodeObjectForKey:@"yuanwenjianDelete"] intValue];
        _RenlianType=               [[aDecoder decodeObjectForKey:@"RenlianType"] intValue];
        _fingerprint=               [[aDecoder decodeObjectForKey:@"fingerprint"] intValue];
        _upExpires=                 [aDecoder decodeObjectForKey:@"upExpires"];
        _upHost=                    [aDecoder decodeObjectForKey:@"upHost"];
        _upKeyId=                   [aDecoder decodeObjectForKey:@"upKeyId"];
        _upKeySecret=               [aDecoder decodeObjectForKey:@"upKeySecret"];
        _upPath=                    [aDecoder decodeObjectForKey:@"upPath"];
        _upSubPath=                 [aDecoder decodeObjectForKey:@"upSubPath"];
        _upToken=                   [aDecoder decodeObjectForKey:@"upToken"];
        _upCallBack=                [aDecoder decodeObjectForKey:@"upCallBack"];
        
        _Noremind=                  [[aDecoder decodeObjectForKey:@"Noremind"] intValue];
        _zhengshuchuzhengNoremind=                  [[aDecoder decodeObjectForKey:@"zhengshuchuzhengNoremind"] intValue];
        _yuanwenjianxiazaiNoremind=                  [[aDecoder decodeObjectForKey:@"yuanwenjianxiazaiNoremind"] intValue];
        _yuanwenjianshanchuNoremind=                  [[aDecoder decodeObjectForKey:@"yuanwenjianshanchuNoremind"] intValue];
        
    }
    return self;
}

+ (void)saveUserInfo
{
    NSData * USER                              = [NSKeyedArchiver archivedDataWithRootObject:[User shareUser]];
    [NSUserDeFaults setBool:YES forKey:LOGINED];
    [NSUserDeFaults setObject:USER forKey:AdailyShopUser];
    [NSUserDeFaults synchronize];
    //    [[User shareUser] setTagAlias:[User shareUser].appKey];
}

//- (void)setTagAlias:(NSString *)alias
//{
//    [APService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//}
//
//
//- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
//{
//    if (iResCode             == 0)
//    {
//        NSLog(@"别名设置________%@______________成功",alias);
//    }
//}



@end
