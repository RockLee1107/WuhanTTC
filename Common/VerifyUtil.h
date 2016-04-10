//
//  VerifyUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VerifyUtil : NSObject
/**验证邮箱*/
+ (BOOL)isEmail:(NSString *)email;

/**验证手机*/
+ (BOOL)isMobile:(NSString *)mobile;

/**验证简单密码长度>=6*/
+ (BOOL)isSimplePassword:(NSString *)password;

/**验证复杂密码长度8～16位，字母与数字组合*/
+ (BOOL)isAdvancePassword:(NSString *)password;

/**非空*/
+ (BOOL)hasValue:(NSString *)str;

/**数字*/
+ (BOOL)isDecimal:(NSString *)number;

/**密码相等*/
+ (BOOL)isEqualToString:(NSString *)password With:(NSString *)rePassword;

/**非零*/
+ (BOOL)isNotZero:(NSInteger)value;

/**字符长度区间*/
+ (BOOL)isValidStringLengthRange:(NSString *)str between:(NSInteger)from and:(NSInteger)to;
@end
