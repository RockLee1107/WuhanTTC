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
//基本属性
@property (nonatomic,strong,nonnull) NSString *username;
@property (nonatomic,strong,nonnull) NSString *password;
@property (nonatomic,strong,nonnull) NSString *realname;
@property (nonatomic,strong,nonnull) NSString *uid;
//附加属性
@property (nonatomic,strong,nonnull) NSString *company;
@property (nonatomic,strong,nonnull) NSString *email;
@property (nonatomic,strong,nonnull) NSString *wechat;
@property (nonatomic,strong,nonnull) NSString *duty;
//管理员属性-文献查询与社区管理用
@property (nonatomic,strong,nonnull) NSNumber *isAdmin;
@property (nonatomic,strong,nonnull) NSNumber *isBm;
//是否投资人
@property (nonatomic,strong,nonnull) NSNumber *isInvestor;
- (void)logout;
- (BOOL)isLogin;
@end
