//
//  ProjectBPDetailViewController.h
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ProjectBPDetailViewController : BaseTableViewController

@property (nonatomic, copy) NSString *bpId;
@property (nonatomic, copy) NSString *statusTitle;//按钮状态
@property (nonatomic, assign) BOOL isAppear;//是从公共区域(YES)进入还是我的(NO)进入
@property (nonatomic, assign) BOOL isUpdateBP;//是从公共区域(NO)进入不能更新BP 我的(YES)进入可以

@end
