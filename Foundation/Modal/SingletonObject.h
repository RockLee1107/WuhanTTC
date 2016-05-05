//
//  StaticObject.h
//  Foundation
//
//  Created by Dotton on 16/3/22.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonObject : NSObject
+ (instancetype)getInstance;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,assign) BOOL isMaticLogout;
@end
