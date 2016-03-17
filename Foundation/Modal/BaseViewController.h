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
#import "MJRefresh.h"
#import "StringUtil.h"
#import "Page.h"

@interface BaseViewController : UIViewController
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) Page *page;
@property (nonatomic,strong) NSMutableDictionary *dataMutableDict;
@property (nonatomic,strong) NSMutableArray *dataMutableArray;
@property (nonatomic,strong) HttpService *service;
@end
