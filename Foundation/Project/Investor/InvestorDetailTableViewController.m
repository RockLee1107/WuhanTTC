//
//  InvestorDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/2.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

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
    ShouldPostProjectTableViewController *vc = [[ShouldPostProjectTableViewController alloc] init];
    vc.financeId = self.dataDict[@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
