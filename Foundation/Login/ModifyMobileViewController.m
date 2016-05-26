//
//  ModifyMobileViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ModifyMobileViewController.h"
#import "LXPasswordView.h"
#import "LXSmsCodeButton.h"

@interface ModifyMobileViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *oldMobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;

@end

@implementation ModifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.oldMobileTextField.delegate = self;
    self.authCodeTextField.delegate = self;
    self.oldMobileTextField.text = [User getInstance].username;
    // Do any additional setup after loading the view.
}

///获取验证码
- (IBAction)authCodeButtonPress:(LXSmsCodeButton *)sender {
    NSString *oldMobile = self.oldMobileTextField.text;
    if (![VerifyUtil isMobile:oldMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    [sender startTime];
    
    NSDictionary *param = @{@"username":oldMobile};
    [self.service POST:@"getAuthenMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [sender reSend];
    } noResult:nil];
}

//拨打电话
- (IBAction)call:(id)sender {
    NSString *callNum = @"18607166298";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",callNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

///会员注册
- (IBAction)submitButtonPress:(id)sender {
    NSString *oldMobile = self.oldMobileTextField.text;
    NSString *authCode = self.authCodeTextField.text;
    if (![VerifyUtil isMobile:oldMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSDictionary *param = @{
                            @"oldMobile":oldMobile,
                            @"msgAuthenCode":authCode
                            };
    [self.service POST:@"personal/info/getMobile" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self performSegueWithIdentifier:@"confirm" sender:self];
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
