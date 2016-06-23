//
//  ProjectBasicInfoViewController.h
//  Foundation
//
//  Created by 李志强 on 16/6/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

typedef void (^MyBlock) (NSString *);

@interface ProjectBasicInfoViewController : BaseStaticTableViewController

@property (nonatomic, copy) NSString *bpId;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *bizStatus;
@property (nonatomic, assign) BOOL hasProject;//

@property (nonatomic, copy) MyBlock block;

@end
