//
//  TeamListTableViewController.h
//  Foundation
//
//  Created by HuangXiuJie on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TeamListTableViewController : BaseTableViewController
@property (strong,nonatomic) NSString *pid;
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, copy) NSString *projectId;
@end
