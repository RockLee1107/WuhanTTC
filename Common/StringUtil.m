//
//  StringUtil.m
//  Beauty
//
//  Created by HuangXiuJie on 16/3/5.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil
+(NSString*)dictToJson:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(NSString*)toString:(id)object {
    if (object == [NSNull null]) {
        object = @"";
    }
    return object;
}

+(NSString*)toPlaceHolderString:(id)object {
    if (object == [NSNull null]) {
        object = @"暂无";
    }
    return object;
}

+ (NSString *)labelArrayToStr:(NSArray *)array {
    if (array.count == 0) {
        return @"";
    }
    NSMutableArray *labelStrArray = [NSMutableArray array];
    for (NSDictionary *label in array) {
        [labelStrArray addObject:label[@"labelName"]];
    }
    return [labelStrArray componentsJoinedByString:@","];
}

///自适应TextView高度
+ (NSDictionary *)textViewAttribute {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}
@end
