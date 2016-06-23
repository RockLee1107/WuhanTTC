//
//  LXGallery.h
//  Foundation
//
//  Created by Dotton on 16/5/1.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXGallery : UIView
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) NSArray *urlArray;
- (void)reloadImagesList;
- (void)reloadImagesListList;
@end
