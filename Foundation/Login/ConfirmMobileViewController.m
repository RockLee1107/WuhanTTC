//
//  ModifyMobileViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ConfirmMobileViewController.h"
#import "LXPasswordView.h"
#import "LXSmsCodeButton.h"

@interface ConfirmMobileViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentMobileTextField;

@end

@implementation ConfirmMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.authCodeTextField.delegate = self;
    self.currentMobileTextField.delegate = self;
    // Do any additional setup after loading the view.
}

///获取验证码
- (IBAction)authCodeButtonPress:(LXSmsCodeButton *)sender {
    NSString *newMobile = self.currentMobileTextField.text;
    if (![VerifyUtil isMobile:newMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    [sender startTime];
    
    NSDictionary *param = @{@"username":newMobile};
    [self.service POST:@"getAuthenMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[sender reSend];
    } noResult:nil];
}

///会员注册
- (IBAction)submitButtonPress:(id)sender {
    NSString *oldMobile = [User getInstance].username;
    NSString *newMobile = self.currentMobileTextField.text;
    NSString *oldPwd = [User getInstance].password;
    NSString *authCode = self.authCodeTextField.text;
    if (![VerifyUtil isMobile:oldMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (![VerifyUtil isMobile:newMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSDictionary *param = @{@"oldMobile":oldMobile,
                            @"newMobile":newMobile,
                            @"oldPwd":oldPwd,
                            @"msgAuthenCode":authCode
                            };
    [self.service POST:@"personal/info/setMobile" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
