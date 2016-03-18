//
//  DateUtil.m
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "DateUtil.h"
#import "StringUtil.h"

@implementation DateUtil
+ (NSString *)prettyString:(NSString *)str {
    str = [StringUtil toString:str];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    NSDate *date = [formatter dateFromString:str];
    [formatter setDateFormat:@"YY/MM/dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)toString:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *dateStr = str;
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@/%@/%@",year,month,day];
}

+ (NSString *)toShortDate:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *dateStr = str;
    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@/%@",month,day];
}
@end
