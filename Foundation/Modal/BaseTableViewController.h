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

@interface BaseTableViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *dataArray;

@end
