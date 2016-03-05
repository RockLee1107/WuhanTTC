//
//  UserUtil.m
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "User.h"

@implementation User
+ (instancetype)getInstance {
    static User *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

- (NSString *)username {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)uid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
}

- (void)setUid:(NSString *)uid {
    if (uid == nil) {
        uid = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
}
@end
