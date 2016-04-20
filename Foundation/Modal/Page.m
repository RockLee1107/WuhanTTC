//
//  Page.m
//  Foundation
//
//  Created by Dotton on 16/3/5.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "Page.h"

@implementation Page
- (instancetype)init{
    self = [super init];
    self.pageSize = 25;
    self.pageNo = 1;
    return self;
}

- (NSDictionary *)dictionary {
//    NSDictionary *dict = @{@"pageNo":[NSNumber numberWithInteger:self.pageNo],
//                           @"pageSize":[NSNumber numberWithInteger:self.pageSize]
//                           };
    NSDictionary *dict = @{@"pageNo":[NSString stringWithFormat:@"%zi",self.pageNo],
                           @"pageSize":[NSString stringWithFormat:@"%zi",self.pageSize]
                           };    return dict;
}
@end
