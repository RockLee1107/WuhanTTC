//
//  UserDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/28.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutyLabel;
@property (weak, nonatomic) IBOutlet UILabel *investIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProjectLabel;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    self.avatarImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"hisUserId":self.userId,
                            @"curUserId":[User getInstance].uid,
                            };
    [self.service GET:@"/personal/info/getUserDetails" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        /**图片*/
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"userinfo"][@"pictUrl"]]];
        
        //    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
        self.avatarImageView.clipsToBounds = YES;
        self.realnameLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"realName"]];
        self.companyLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"company"]];
        self.dutyLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"duty"]];
        self.areaLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"area"]];
        self.investAreaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investArea"]];
        self.investProcessLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investProcess"]];
        self.investProjectLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investProject"]];
        self.investIdeaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investIdea"]];
    } noResult:nil];
}

@end
