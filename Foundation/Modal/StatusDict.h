//
//  StatusDict.h
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusDict : NSObject
///项目阶段
+ (NSArray *)procStatus;
///融资阶段
+ (NSArray *)financeProc;
///项目领域
+ (NSArray *)industry;
@end