//
//  ImageUtil.m
//  Foundation
//
//  Created by Dotton on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
//保存图片到沙盒
+ (NSString *)savePicture:(NSString *)filename image:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
    if (result) {
        return filePath;
    }
    return nil;
}
@end
