//
//  ImageUtil.m
//  Foundation
//
//  Created by Dotton on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
+ (instancetype)getInstance {
    static ImageUtil *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}
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

//保存图片到沙盒-多图方式
- (NSArray *)savePicture:(NSString *)filename images:(NSArray *)images {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *filenames = [self generateFilename:filename num:images.count];
    for (int i = 0; i < images.count; i++) {
        [array addObject:[ImageUtil savePicture:filenames[i] image:images[i]]];
    }
    return array;
}

//生成图片名称
- (NSArray *)generateFilename:(NSString *)name num:(NSInteger)num {
    int timestamp = (int)([[NSDate date] timeIntervalSince1970]);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < num; i++) {
        [array addObject:[NSString stringWithFormat:@"%@_%d_%zi.jpg",name,timestamp,i]];
    }
    self.filenames = array;
    return array;
}
@end
