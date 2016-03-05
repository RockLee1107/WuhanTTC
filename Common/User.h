//
//  UserUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface User : NSObject
+ (instancetype)getInstance;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *uid;
@end
