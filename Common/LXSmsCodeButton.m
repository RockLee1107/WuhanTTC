//
//  LX_UIButton.m
//  Wash
//
//  Created by Dotton on 15/7/13.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LXSmsCodeButton.h"
#import "Global.h"

@implementation LXSmsCodeButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //不闪
    [super drawRect:rect];
//    [[self class] setAnimationsEnabled:NO];
    [self initLabel:rect];
    self.timerNum = 60;

}

-(void)reSend{
    //获取验证码，重发
    self.enabled = NO;
    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClock) userInfo:nil repeats:YES];
    if ([self.codeTimer isValid]) {
        [self.codeTimer setFireDate:[NSDate date]];
    }
}

-(void)timerClock{
    [self setTitle:@"" forState:(UIControlStateNormal)];
    self.secondLabel.text = [NSString stringWithFormat:@"%d秒可重发",--self.timerNum];
    if (self.timerNum == 0) {
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.secondLabel.text = @"";
        [self.codeTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)initLabel:(CGRect)rect {
    self.secondLabel = [[UILabel alloc] initWithFrame:rect];
    self.secondLabel.font = [UIFont systemFontOfSize:14.0];
    self.secondLabel.textColor = [UIColor whiteColor];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.secondLabel];
}
@end
