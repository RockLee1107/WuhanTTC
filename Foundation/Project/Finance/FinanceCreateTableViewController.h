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
@property (nonatomic,assign) BOOL isFromAdd;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, copy) NSString *financeTimeStr;//融资时间
@property (nonatomic, copy) NSString *fi;
@property (nonatomic, copy) NSString *fi3;

@end
