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

- (NSString *)password {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (NSString *)realname {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"realname"];
}

- (NSString *)uid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

- (void)setRealname:(NSString *)realname {
    [[NSUserDefaults standardUserDefaults] setObject:realname forKey:@"realname"];
}


- (void)setUid:(NSString *)uid {
    if (uid == nil) {
        uid = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
}

- (BOOL)isLogin {
    if (self.uid) {
        return YES;
    }
    return NO;
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
}

@end
