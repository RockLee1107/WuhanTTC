//
//  DateUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DateUtil : NSObject
//+ (NSString *)prettyString:(NSString *)str;
///转长日期20151112090801->2015-11-12
+ (NSString *)toString:(id)str;
+ (NSString *)toShortDate:(id)str;
///转长日期，20160305120859
//+ (NSString *)toStrFromYmdHis:(id)str;
///转日期时间，分别传入日期与时间
+ (NSString *)toString:(id)date time:(id)time;
///转非全年份的日期时间，分别传入日期与时间
+ (NSString *)toShortDate:(id)date time:(id)time;
//NSDate类型转成String类型
+ (NSString *)dateToString:(NSDate *)date;
///长日期
+ (NSString *)dateToFullString:(NSDate *)date;
+ (NSString *)dateToYYMM:(NSDate *)date;
///日期类型转日期字符串 20141214
+ (NSString *)dateToDatePart:(NSDate *)date;
+ (NSString *)dateToSecondPart:(NSDate *)date;
///日期类型转不带秒数的时间字符串 0059
+ (NSString *)dateToTimePart:(NSDate *)date;
///20160808->2016年08月
+ (NSString *)toYYYYMMCN:(id)str;
///20160808->2016-08
+ (NSString *)toYYYYMMDD:(id)str;
///转非全年份的日期时间，分别传入日期与时间，CN环境
+ (NSString *)toShortDateCN:(id)date time:(id)time;
///日期类型转日期时间字符串 20141214235959
+ (NSString *)dateToCompactString:(NSDate *)date;
///日期类型转日期时间字符串 2014/12/14 23:59
+ (NSString *)dateToCompactStringWithoutSecond:(NSDate *)date;
///日期比较For未读红点
+ (BOOL)compare:(NSString *)latestUpdateTime lastRequestTime:(NSString *)lastRequestTime;
///转成标准日期
+ (NSDate *)toDate:(NSString *)str format:(NSString *)format;
///指定的日期跟当前时间比较
+(BOOL)isDestDateInFuture:(NSString *)destStr;
@end
