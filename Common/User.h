//
//  UserUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface User : NSObject
+ (nonnull instancetype)getInstance;
@property (nonatomic,strong,nonnull) NSString *username;
@property (nonatomic,strong,nonnull) NSString *realname;
@property (nonatomic,strong,nonnull) NSString *uid;
@property (nonnull,strong) NSNumber *hasInfo;
@property (nonatomic,strong,nonnull) NSNumber *isAdmin;
- (void)logout;
- (BOOL)isLogin;
@end
