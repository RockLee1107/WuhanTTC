//
//  BookSearchViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface BookSearchByTitleOrOthersTableViewController : BaseStaticTableViewController
@property (strong, nonatomic) NSString *keyWords;
@property (strong, nonatomic) NSString *type;

@end
