//
//  UserInfoTableViewController.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "CityViewController.h"

@interface UserInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dutyTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.realnameTextField.delegate = self;
    self.mobileTextField.delegate = self;
    self.wechatTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.dutyTextField.delegate = self;
    self.companyTextField.delegate = self;
    self.areaTextField.delegate = self;
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"userId":[User getInstance].uid
                            };
    [self.service POST:@"/personal/info/getUserInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = responseObject[@"userinfo"];
        self.realnameTextField.text = [StringUtil toString:responseObject[@"realName"]];
        self.mobileTextField.text = [StringUtil toString:responseObject[@"mobile"]];
        self.wechatTextField.text = [StringUtil toString:responseObject[@"weChat"]];
        self.emailTextField.text = [StringUtil toString:responseObject[@"email"]];
        self.dutyTextField.text = [StringUtil toString:responseObject[@"duty"]];
        self.companyTextField.text = [StringUtil toString:responseObject[@"company"]];
        self.areaTextField.text = [StringUtil toString:responseObject[@"area"]];
    } noResult:nil];
}

- (IBAction)selectArea:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setArea {
    self.areaTextField.text = [LocationUtil getInstance].locatedCityName;
}
@end
