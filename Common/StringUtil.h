//
//  StringUtil.h
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StringUtil : NSObject
+(NSString*)dictToJson:(id)object;
+(NSString*)toString:(id)object;
+(NSString*)toPlaceHolderString:(id)object;
+ (NSString *)labelArrayToStr:(NSArray *)array;
///标准文本格式，大小16，间距7
+ (NSDictionary *)textViewAttribute;
///适配多行文本，返回文本应有高度，行数相关
+ (CGFloat)heightToFit:(NSString *)str;
@end
