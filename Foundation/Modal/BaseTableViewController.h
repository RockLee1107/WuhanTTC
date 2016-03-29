//
//  BasicDynamicTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/3/18.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "Page.h"
#import "MJRefresh.h"
#import "BaseTableView.h"
#import "BaseTableViewDelegate.h"
#import "JSDropDownMenu.h"
#import "LocationUtil.h"

@interface BaseTableViewController : BaseViewController
@property (nonatomic, strong) Page *page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (strong, nonatomic) BaseTableViewDelegate *tableViewDelegate;

@end
