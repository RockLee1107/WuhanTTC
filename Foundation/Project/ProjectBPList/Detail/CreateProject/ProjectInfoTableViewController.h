//
//  ProjectInfoTableViewController.h
//  Foundation
//
//  Created by 李志强 on 16/6/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface ProjectInfoTableViewController : BaseStaticTableViewController

@property (nonatomic, copy) NSString *bpId;
@property (nonatomic, assign) BOOL isFlag;//入口  YES：创建项目  NO：更新项目
@property (nonatomic, copy) NSString *showStatus;//ok:勾选

@end
