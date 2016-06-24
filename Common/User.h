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
@property (nonatomic,strong,nonnull) NSString *bpId;
@property (nonatomic,strong,nonnull) NSString *friendId;
@property (nonatomic,strong,nonnull) NSString *projectId;//更新项目时从服务器取的老projectId
@property (nonatomic,strong,nonnull) NSString *createProjectId;//创建项目时保存的老projectId
@property (nonatomic,strong,nonnull) NSString *sEQ_visible;//可见状态,用来传 从我的和公共进入的参数
@property (nonatomic,assign) BOOL isClick;//项目详情五大块是否可以点击
@property (nonatomic,strong,nonnull) NSString *srcId;//记录项目原id
@property (nonatomic,strong,nonnull) NSString *originalBpId;//记录原bpId
@property (nonatomic,assign) BOOL isCloseItem;//提交审核后返回关闭容器右上的更新项目
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
- (void)removePassword;
@end
