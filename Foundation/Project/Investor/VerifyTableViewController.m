//
//  VerifyTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "VerifyTableViewController.h"
#import "StandardViewController.h"

@interface VerifyTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *investInstitutionTextField;
@property (weak, nonatomic) IBOutlet UITextField *investUrlTextField;

@end

@implementation VerifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    self.realnameLabel.text = [User getInstance].realname;
    self.mobileLabel.text = [User getInstance].username;
    // Do any additional setup after loading the view.
}

///活动规范
- (IBAction)standardButtonPress:(id)sender {
    StandardViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"standard"];
    vc.type = @"1";
    vc.naviTitle = @"活动发布规范";
    [self.navigationController pushViewController:vc animated:YES];
}

///提交按钮点击
- (IBAction)submitButtonPress:(id)sender {
    if (![VerifyUtil isValidStringLengthRange:self.investInstitutionTextField.text between:3 and:200]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资机构(3-200字)"];
        return;
    }
    
    if (![VerifyUtil hasValue:self.investUrlTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资机构网址"];
        return;
    }
    
    NSDictionary *param = @{
                            @"InvestorInfo":[StringUtil dictToJson:@{
                                                                     @"investInstitution":self.investInstitutionTextField.text,
                                                                     @"userId":[User getInstance].uid
                                                                     }]
                            };
    
    [self.service POST:@"personal/info/setInvestorInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
