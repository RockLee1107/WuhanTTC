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
//+ (NSString *)prettyString:(NSString *)str {
//    str = [StringUtil toString:str];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYMMddHHmmss"];
//    NSDate *date = [formatter dateFromString:str];
//    [formatter setDateFormat:@"YY-MM-dd"];
//    return [formatter stringFromDate:date];
//}

//+ (NSString *)toStrFromYmdHis:(id)str {
//    if (str == [NSNull null]) {
//        return @"";
//    }
//    NSString *dateStr = str;
//    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
//    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
//    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
//    return [NSString stringWithFormat:@"%@/%@/%@",year,month,day];
//}

///转日期时间，分别传入日期与时间
+ (NSString *)toString:(id)date time:(id)time {
    NSString *datePart = [DateUtil toString:date];
    NSString *timePart = [DateUtil toTime:time];
    return [NSString stringWithFormat:@"%@ %@",datePart,timePart];
}

///转非全年份的日期时间，分别传入日期与时间
+ (NSString *)toShortDate:(id)date time:(id)time {
    NSString *datePart = [DateUtil toShortDate:date];
    NSString *timePart = [DateUtil toTime:time];
    return [NSString stringWithFormat:@"%@ %@",datePart,timePart];
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

+ (NSString *)toTime:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *timeStr = str;
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 2)];
    NSString *month = [timeStr substringWithRange:NSMakeRange(2, 2)];
    return [NSString stringWithFormat:@"%@:%@",year,month];
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

+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)dateToFullString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}
@end
