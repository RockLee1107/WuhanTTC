//
//  BaseTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewDelegate.h"

@implementation BaseTableViewDelegate
- (instancetype)init {
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}
@end
