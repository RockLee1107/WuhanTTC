//
//  StatusDict.m
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "StatusDict.h"

@implementation StatusDict
///项目阶段
+ (NSArray *)procStatus {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"procStatus"];
}
///融资阶段
+ (NSArray *)financeProc {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"financeProc"];
}
///项目领域
+ (NSArray *)industry {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"industry"];
}
///活动类型
+ (NSArray *)activityType {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"activityType"];
}
///专题
+ (NSArray *)specialType {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"specialType"];
}
///文献二级列表
+ (NSArray *)bookCategory {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bookCategory"];
}
///融资阶段查询
+ (NSString *)financeProcByCode:(NSString *)code {
    NSArray *financeProcArray = [StatusDict financeProc];
    for (NSDictionary *financeDict in financeProcArray) {
        if ([financeDict[@"financeProcCode"] isEqualToString:code]) {
            return financeDict[@"financeProcName"];
        }
    }
    return nil;
}
///文献二级列表分组查询
+ (NSArray *)bookCategoryBySpecialCode:(NSString *)specialCode {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in [StatusDict bookCategory]) {
        if ([dict[@"specialCode"] isEqualToString:specialCode]) {
            [resultArray addObject:dict];
        }
    }
    return resultArray;
}

@end
