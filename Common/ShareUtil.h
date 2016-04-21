//
//  ShareUtil.h
//  Commune
//
//  Created by Dotton on 16/3/23.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareUtil : NSObject
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) UIViewController *vc;
+ (instancetype)getInstance;
- (void)shareWithUrl;
@end
