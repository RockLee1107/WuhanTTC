//
//  LX_UIButton.m
//  Wash
//
//  Created by Dotton on 15/7/13.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LXButton.h"
#import "Global.h"

@implementation LXButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.backgroundColor = [MAIN_COLOR CGColor];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}

@end
