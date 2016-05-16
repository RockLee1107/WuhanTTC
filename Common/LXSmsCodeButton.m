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

//执行初始化
-(void)doInit{
    [self addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
}

-(void)reSend{
//    //获取验证码，重发
//    self.enabled = NO;
//    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClock) userInfo:nil repeats:YES];
//    if ([self.codeTimer isValid]) {
//        [self.codeTimer setFireDate:[NSDate date]];
//    }
    
   
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

-(void)startTime{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
