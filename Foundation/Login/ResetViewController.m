//
//  ResetViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ResetViewController.h"
#import "LXPasswordView.h"
#import "LXSmsCodeButton.h"
#import "LoginViewController.h"
#import "SingletonObject.h"
#import "User.h"

@interface ResetViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;
@property (weak, nonatomic) IBOutlet LXButton *cancelButton;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.usernameTextField.delegate = self;
    self.authCodeTextField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.cancelButton.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
}

///获取验证码
- (IBAction)authCodeButtonPress:(LXSmsCodeButton *)sender {
    NSString *username = self.usernameTextField.text;
    
    if (![VerifyUtil isMobile:username]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    //GCD倒计时
    [sender startTime];
    
    NSDictionary *param = @{@"username":username};
    [self.service POST:@"getAuthenMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[sender reSend];
    } noResult:nil];
}

///忘记密码
- (IBAction)resetButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordView.textField.text;
    NSString *authCode = self.authCodeTextField.text;
    NSDictionary *param = @{@"username":username,
                            @"password":password,
                            @"msgAuthenCode":authCode
                            };
    [self.service POST:@"resetPassword" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
        
        
        for(UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[LoginViewController class]]){
                LoginViewController *loginVC = (LoginViewController *)controller;
                [self.navigationController popToViewController:loginVC animated:YES];
            
            }
        }
        
    } noResult:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
