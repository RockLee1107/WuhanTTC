//
//  CommonUtil.m
//  Beauty
//
//  Created by HuangXiuJie on 15/3/12.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

/**
 * 手机版本约束差异 宽度
 * @return  YES/NO
 */
+ (CGFloat)getVersionWidth{
    CGFloat app_width = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        app_width = 16;
    }
    return app_width;
}


//图片缩放
+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    if (originalAspect > targetAspect) {
        // original is wider than target
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
    } else if (originalAspect < targetAspect) {
        // original is narrower than target
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
    } else {
        // original and target have same aspect ratio
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    //    targetRect = CGRectMake(0, 0, .5*original.size.width, .5*original.size.height);
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}


/**
 *验证邮箱
 * @param NSString email
 * @return BOOL YES/NO
 */
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *Regex = @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    if (![test evaluateWithObject:email]) {
        return NO;
    }
    return YES;
}

/**
 *验证手机
 * @param NSString mobile
 * @return BOOL YES/NO
 */
+ (BOOL)isValidateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if (![phoneTest evaluateWithObject:mobile]) {
        return NO;
    }
    return YES;
}
/**
 *验证密码长度8～16位，字母与数字组合
 */
+ (BOOL)validatePassword:(NSString *)password {
    NSString *passwordReg = @"^(?!([a-zA-Z]+|\\d+)$)[a-zA-Z\\d]{8,16}$";
    NSPredicate *regexPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordReg];
    if (![regexPwd evaluateWithObject:password] == YES) {
        return NO;
    }
    return YES;
}
/**
 *非空
 */
+ (BOOL)hasValue:(NSString *)str {
    if ([str length] > 0) {
        return YES;
    }
    return NO;
}

/**数值*/
+ (BOOL)isDecimal:(NSString *)number {
    NSString *passwordReg = @"^\\d+(\\.\\d+)?$";
    NSPredicate *regexPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordReg];
    if (![regexPwd evaluateWithObject:number] == YES) {
        return NO;
    }
    return YES;
}
@end
