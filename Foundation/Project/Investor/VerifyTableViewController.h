//
//  VerifyTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/5/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

typedef void (^MyBlock) (NSString *);

@interface VerifyTableViewController : BaseStaticTableViewController

@property (nonatomic, copy) MyBlock block;

@end
