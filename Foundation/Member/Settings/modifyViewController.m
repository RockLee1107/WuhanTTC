//
//  modifyViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "modifyViewController.h"
#import "LXPasswordView.h"
#import "LXSmsCodeButton.h"

@interface modifyViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LXPasswordView *oldPasswordView;
@property (weak, nonatomic) IBOutlet LXPasswordView *currentPasswordView;
@property (weak, nonatomic) IBOutlet LXButton *cancelButton;
@end

@implementation modifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.oldPasswordView.textField.delegate = self;
    self.currentPasswordView.textField.delegate = self;
    self.cancelButton.backgroundColor = [UIColor grayColor];
}

///修改密码
- (IBAction)modifyButtonPress:(id)sender {
    NSString *oldPassword = self.oldPasswordView.textField.text;
    NSString *newPassword = self.currentPasswordView.textField.text;
    NSDictionary *param = @{@"userId":[User getInstance].uid,
                            @"oldPassword":oldPassword,
                            @"newPassword":newPassword
                            };
    [self.service POST:@"modifyPassword" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        
        [self jumpLogin];
    } noResult:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
