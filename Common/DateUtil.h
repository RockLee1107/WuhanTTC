//
//  DateUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DateUtil : NSObject
+ (NSString *)prettyString:(NSString *)str;
+ (NSString *)toString:(id)str;
+ (NSString *)toShortDate:(id)str;
///转长日期，20160305120859
//+ (NSString *)toStrFromYmdHis:(id)str;
@end
