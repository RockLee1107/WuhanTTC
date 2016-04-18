//
//  ImageUtil.h
//  Foundation
//
//  Created by Dotton on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject
//保存图片到沙盒
+ (NSString *)savePicture:(NSString *)filename image:(UIImage *)image;
@end
