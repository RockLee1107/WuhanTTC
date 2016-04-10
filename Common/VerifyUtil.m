//
//  VerifyUtil.m
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "VerifyUtil.h"

@implementation VerifyUtil

/**验证手机*/
+ (BOOL)isMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([phoneTest evaluateWithObject:mobile]) {
        return YES;
    }
    return NO;
}

/**验证邮箱*/
+ (BOOL)isEmail:(NSString *)email {
    NSString *Regex = @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    if ([test evaluateWithObject:email]) {
        return YES;
    }
    return NO;
}

/**验证简单密码长度>=6*/
+ (BOOL)isSimplePassword:(NSString *)password {
    if (password.length >= 6) {
        return YES;
    }
    return NO;
}

/**验证复杂密码长度8～16位，字母与数字组合*/
+ (BOOL)isAdvancePassword:(NSString *)password {
    NSString *passwordReg = @"^(?!([a-zA-Z]+|\\d+)$)[a-zA-Z\\d]{8,16}$";
    NSPredicate *regexPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordReg];
    if ([regexPwd evaluateWithObject:password] == YES) {
        return YES;
    }
    return NO;
}

/**非空*/
+ (BOOL)hasValue:(NSString *)str {
    if ([str length] > 0) {
        return YES;
    }
    return NO;
}

/**数字*/
+ (BOOL)isDecimal:(NSString *)number {
    NSString *passwordReg = @"^\\d+(\\.\\d+)?$";
    NSPredicate *regexPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordReg];
    if ([regexPwd evaluateWithObject:number] == YES) {
        return YES;
    }
    return NO;
}

/**密码相等*/
+ (BOOL)isEqualToString:(NSString *)password With:(NSString *)rePassword {
    if ([password isEqualToString:rePassword]) {
        return YES;
    }
    return NO;
}

/**非零*/
+ (BOOL)isNotZero:(NSInteger)value {
    if (value != 0) {
        return YES;
    }
    return NO;
}

/**字符长度区间*/
+ (BOOL)isValidStringLengthRange:(NSString *)str between:(NSInteger)from and:(NSInteger)to {
    if (str.length >= from && str.length <= to) {
        return YES;
    }
    return NO;
}
@end
