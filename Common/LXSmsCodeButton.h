//
//  LX_UIButton.h
//  Wash
//
//  Created by Dotton on 15/7/13.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXButton.h"

@interface LXSmsCodeButton : LXButton

@property (assign, nonatomic) int timerNum;
@property (strong, nonatomic) NSTimer *codeTimer;
@property (strong, nonatomic) UILabel *secondLabel;
-(void)doInit;
-(void)timerClock;
-(void)reSend;
@end
