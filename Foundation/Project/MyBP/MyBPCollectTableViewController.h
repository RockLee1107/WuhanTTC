//
//  MyBPCollectTableViewController.h
//  Foundation
//
//  Created by 李志强 on 16/6/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface MyBPCollectTableViewController : BaseStaticTableViewController
@property (nonatomic, strong) NSString *SEQ_queryType;
@property (nonatomic,strong) NSString *userId;
- (void)fetchData;
@end
