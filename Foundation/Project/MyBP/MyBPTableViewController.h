//
//  MyBPTableViewController.h
//  Foundation
//
//  Created by 李志强 on 16/6/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface MyBPTableViewController : BaseStaticTableViewController
@property (nonatomic, strong) NSString *SEQ_queryType;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL fromMember;//从我-->我的BP进入
@end
