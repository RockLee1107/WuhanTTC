//
//  BaseTableView.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


@end
