//
//  RapidViewController.h
//  YZBao
//
//  Created by 兴手付科技 on 16/6/10.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "BasicViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

@interface Rapid1ViewController : BasicViewController

@property (nonatomic , copy) NSString *baoquanType;

@property (nonatomic , strong) NSDictionary *Dictionary;

/////判断是否是试用还是不是的状态
//@property (nonatomic , copy) NSString *trialType;

@end
