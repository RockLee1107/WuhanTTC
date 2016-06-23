//
//  ProcessCreateViewController.h
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "ProcessTableViewController.h"

@interface ProcessCreateTableViewController : BaseStaticTableViewController
@property (strong,nonatomic) NSString *pid;
@property (strong,nonatomic) ProcessTableViewController *parentVC;
@property (nonatomic, assign) BOOL isFromAdd;
@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *dateText;
@property (nonatomic, copy) NSString *descText;

@end
