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

@interface BasicDynamicTableViewController : BaseViewController
@property (nonatomic, strong) Page *page;
//@property (nonatomic,strong) NSMutableDictionary *dataMutableDict;
@property (nonatomic,strong) NSMutableArray *dataMutableArray;
@end
