//
//  MailViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface MailViewController : BaseStaticTableViewController
@property (nonatomic,strong) NSString *userType;
- (void)fetchData;
@end
