//
//  StaticObject.m
//  Foundation
//
//  Created by Dotton on 16/3/22.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SingletonObject.h"

@implementation SingletonObject
+ (instancetype)getInstance {
    static SingletonObject *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

@end
