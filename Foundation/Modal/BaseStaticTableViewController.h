//
//  BaseTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "StringUtil.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "DateUtil.h"
#import "Page.h"
#import "MJRefresh.h"

@interface BaseStaticTableViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, strong) Page *page;
@property (nonatomic,strong) HttpService *service;
- (void)setDynamicLayout;

@end
