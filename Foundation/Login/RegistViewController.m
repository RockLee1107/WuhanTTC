//
//  RegistViewController.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "RegistViewController.h"
#import "LXPasswordView.h"
#import "LXSmsCodeButton.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.usernameTextField.delegate = self;
    self.authCodeTextField.delegate = self;
    self.realnameTextField.delegate = self;
    self.passwordView.textField.delegate = self;
    // Do any additional setup after loading the view.
}

///获取验证码
- (IBAction)authCodeButtonPress:(LXSmsCodeButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSDictionary *param = @{@"username":username};
    [self.service POST:@"getAuthenMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [sender reSend];
    } noResult:nil];
}

///会员注册
- (IBAction)registButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordView.textField.text;
    NSString *authCode = self.authCodeTextField.text;
    NSString *realname = self.realnameTextField.text;
    NSDictionary *param = @{@"realName":realname,
                            @"username":username,
                            @"password":password,
                            @"msgAuthenCode":authCode
                            };
    [self.service POST:@"register" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self goBack:nil];
    } noResult:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
