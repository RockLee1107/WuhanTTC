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

///日期类型转日期字符串 20141214
+ (NSString *)dateToDatePart:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

///日期类型转不带秒数的时间字符串 0059
+ (NSString *)dateToTimePart:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmm"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

///20160808->2016年08月
+ (NSString *)toYYYYMMCN:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *dateStr = str;
    NSString *month = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(4, 2)];
    return [NSString stringWithFormat:@"%@年%@月",month,day];
}

///20160808->2016-08
+ (NSString *)toYYYYMMDD:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *dateStr = str;
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

///转非全年份的日期时间，分别传入日期与时间
+ (NSString *)toShortDateCN:(id)date time:(id)time {
    NSString *datePart = [DateUtil toShortDateCN:date];
    NSString *timePart = [DateUtil toTime:time];
    return [NSString stringWithFormat:@"%@ %@",datePart,timePart];
}

///内部调用，20161111->11月11日
+ (NSString *)toShortDateCN:(id)str {
    if (str == [NSNull null]) {
        return @"";
    }
    NSString *dateStr = str;
    NSString *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@月%@日",month,day];
}

///20151112090801->2015-11-12
//+ (NSString *)toDate:(id)str {
//}

///日期类型转日期时间字符串 20141214235959
+ (NSString *)dateToCompactString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

///日期类型转日期时间字符串 2014/12/14 23:59
+ (NSString *)dateToCompactStringWithoutSecond:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

///跟当前时间比较YYYYMMddHHmmss
 +(BOOL)isDestDateInFuture:(NSString *)destStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
 
    NSDate *destDate = [dateFormatter dateFromString:destStr];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSComparisonResult result = [destDate compare:currentDate];
 
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
  
    return 0;
    
}

///两个日期的比较
+(BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

///日期比较For未读红点
+ (BOOL)compare:(NSString *)latestUpdateTime lastRequestTime:(NSString *)lastRequestTime {
//    lastRequestTime可能为空
    NSDate *lastRequestTimeDate = [NSDate dateWithTimeIntervalSince1970:[[StringUtil toString:lastRequestTime] doubleValue] / 1000];
//    NSLog(@"1.%@",lastRequestTimeDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *latestUpdateTimeDate = [formatter dateFromString:latestUpdateTime];
//    NSLog(@"2.%@",latestUpdateTimeDate);
    if ([latestUpdateTimeDate compare:lastRequestTimeDate] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

///转成标准日期
+ (NSDate *)toDate:(NSString *)str format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

@end
