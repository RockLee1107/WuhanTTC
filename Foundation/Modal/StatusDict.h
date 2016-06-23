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
///活动类型
+ (NSArray *)activityType;
///专题
+ (NSArray *)specialType;
///融资阶段查询
+ (NSString *)financeProcByCode:(NSString *)code;
///文献二级列表
+ (NSArray *)bookCategory;
///筛选栏数字
+ (NSArray *)bookType;
///文献二级列表分组查询
+ (NSArray *)bookCategoryBySpecialCode:(NSString *)specialCode;

+ (NSArray *)bookTypeBySpecialCode:(NSString *)specialCode;
@end
