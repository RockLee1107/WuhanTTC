//
//  CaptionButton.m
//  Foundation
//
//  Created by Dotton on 16/3/22.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CaptionButton.h"
#import "Global.h"

@implementation CaptionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    imageView.backgroundColor = HGColor(15, 122, 236);
    [self addSubview:imageView];
}

@end
