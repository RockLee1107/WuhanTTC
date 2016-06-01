//
//  InvestorDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/2.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***创投融->投资人列表->投资人详情***/

#import "InvestorDetailTableViewController.h"
#import "ShouldPostProjectTableViewController.h"
#import "LXButton.h"

@interface InvestorDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *investIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProjectLabel;
@property (weak, nonatomic) IBOutlet LXButton *postButton;

@end

@implementation InvestorDetailTableViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

//视图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self fetchData];
//    如果是本人，那么隐藏按钮
    if ([self.dataDict[@"userId"] isEqualToString:[User getInstance].uid]) {
        self.postButton.hidden = YES;
    }
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    NSString *investorId = self.dataDict[@"userId"];
    NSDictionary *param = @{
                            @"userId":investorId
                            };
    [self.service GET:@"/personal/info/getInvestorInfoDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"pictUrl"]]]]];
        self.pictUrlImageView.clipsToBounds = YES;
        self.realNameLabel.text = [StringUtil toPlaceHolderString:responseObject[@"realName"]];
        self.areaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"area"]];
        self.companyLabel.text = [StringUtil toPlaceHolderString:responseObject[@"company"]];
        self.investAreaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investArea"]];
        self.investProcessLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investProcess"]];
        self.investProjectLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investProject"]];
        self.investIdeaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investIdea"]];

    } noResult:nil];
}

- (IBAction)postButtonPress:(id)sender {
    if ([User getInstance].isLogin) {
        ShouldPostProjectTableViewController *vc = [[ShouldPostProjectTableViewController alloc] init];
        vc.financeId = self.dataDict[@"userId"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

@end
