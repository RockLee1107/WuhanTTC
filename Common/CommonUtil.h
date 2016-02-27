//
//  CommonUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 15/3/12.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommonUtil : NSObject
+ (CGFloat)getVersionWidth;
+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size;
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateEmail:(NSString *)email;
/**
 *验证密码长度8～16位，字母与数字组合
 */
+ (BOOL)validatePassword:(NSString *)password;
+ (BOOL)hasValue:(NSString *)str;
+ (BOOL)isDecimal:(NSString *)number;
@end
