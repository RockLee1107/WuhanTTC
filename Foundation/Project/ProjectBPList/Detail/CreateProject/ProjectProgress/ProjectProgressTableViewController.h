//
//  ProjectProgressTableViewController.h
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

typedef void (^MyBlock) (NSString *);

@interface ProjectProgressTableViewController : BaseStaticTableViewController

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) MyBlock block;
@property (nonatomic, assign) BOOL hasProcess;

@end
