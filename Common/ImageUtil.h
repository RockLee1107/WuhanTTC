//
//  ImageUtil.h
//  Foundation
//
//  Created by Dotton on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject
@property (nonatomic,strong) NSArray *filenames;
+ (instancetype)getInstance;
//保存图片到沙盒
+ (NSString *)savePicture:(NSString *)filename image:(UIImage *)image;
//保存图片到沙盒-多图方式
- (NSArray *)savePicture:(NSString *)filename images:(NSArray *)images;
//生成图片名称
//- (NSArray *)generateFilename:(NSString *)name num:(NSInteger)num;
@end
