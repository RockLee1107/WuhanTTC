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
#import "PXAlertView.h"
#import "PXAlertView+Customization.h"
#import "LocationUtil.h"
#import "VerifyUtil.h"
#import "BaseTableViewDelegate.h"
#import "LoginViewController.h"

@interface BaseStaticTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) Page *page;
@property (nonatomic,strong) HttpService *service;
@property (nonatomic,strong) UITextField *currentTextField;
- (void)setDynamicLayout;
- (void)goBack;
@property (strong, nonatomic) BaseTableViewDelegate *tableViewDelegate;

@end
