//
//  MyProjectTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface MyProjectTableViewController : BaseStaticTableViewController
@property (nonatomic, strong) NSString *SEQ_queryType;
- (void)fetchData;
@end
