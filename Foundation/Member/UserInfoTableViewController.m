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

//访问网络
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

- (IBAction)updateUserInfo:(id)sender {
    NSDictionary *dict = @{
              @"userinfo":@{
                                                    @"userId":[User getInstance].uid,
                                                    @"realName":self.realnameTextField.text,
                                                    @"mobile":self.mobileTextField.text,
                                                    @"email":self.emailTextField.text,
                                                    @"duty":self.dutyTextField.text,
                                                    @"company":self.companyTextField.text,
                                                    @"area":self.areaTextField.text,
                                                    @"weChat":self.wechatTextField.text
                                                    }
              ,
              @"investorInfo":@{
                                                       
                                                       }
//              ,
//              @"userId":[User getInstance].uid
              };
    
    NSDictionary *param = @{@"UserInfoDto":[StringUtil dictToJson:dict]};
    [self.service POST:@"/personal/info/setUserTotalInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        if (![self.companyTextField.text isEqualToString:@""]
            && ![self.dutyTextField.text isEqualToString:@""]
            && ![self.realnameTextField.text isEqualToString:@""]) {
            [User getInstance].hasInfo = [NSNumber numberWithBool:YES];
        } else {
            [User getInstance].hasInfo = [NSNumber numberWithBool:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}

//选择城市
- (IBAction)selectArea:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    vc.vc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//回调填充城市
- (void)fillArea {
    self.areaTextField.text = [LocationUtil getInstance].locatedCityName;
}
@end
