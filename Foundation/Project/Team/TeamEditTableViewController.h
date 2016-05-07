//
//  TeamEditTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "TeamListTableViewController.h"

@interface TeamEditTableViewController : BaseStaticTableViewController
@property (strong,nonatomic) TeamListTableViewController *parentVC;

@end
