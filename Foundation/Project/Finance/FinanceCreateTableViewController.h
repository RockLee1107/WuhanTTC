//
//  FinanceCreateTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/5/6.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "FinanceTableViewController.h"

@interface FinanceCreateTableViewController : BaseStaticTableViewController
@property (strong,nonatomic) NSString *pid;
@property (strong,nonatomic) FinanceTableViewController *parentVC;

@end
