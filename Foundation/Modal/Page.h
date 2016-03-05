//
//  Page.h
//  Foundation
//
//  Created by Dotton on 16/3/5.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,assign) NSInteger pageSize;
- (NSDictionary *)dictionary;
@end
