//
//  ActivityDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityDetailTableViewController.h"

@interface ActivityDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDatetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDatetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *planSiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyRequirementLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDetailsLabel;
@end

@implementation ActivityDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *param = @{
                            @"activityId":self.activityId
                            };
    [self.service POST:@"/activity/getActivity" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        [self.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"pictUrl"]]]]];
        self.pictUrlImageView.clipsToBounds = YES;
        self.activityTitleLabel.text = responseObject[@"activityTitle"];
        self.typeLabel.text = responseObject[@"type"];
        self.statusLabel.text = ACTIVITY_STATUS_ARRAY[[responseObject[@"status"] integerValue]];
        self.planDatetimeLabel.text = [DateUtil toString:responseObject[@"planDate"] time:responseObject[@"planTime"]];
        self.endDatetimeLabel.text = [DateUtil toString:responseObject[@"endDate"] time:responseObject[@"endTime"]];
        NSString *applyNum = [responseObject[@"applyNum"] stringValue];
        NSString *planJoinNum = [responseObject[@"planJoinNum"] stringValue];
        self.applyNumLabel.text = [NSString stringWithFormat:@"%@/%@",applyNum,planJoinNum];
        self.cityLabel.text = responseObject[@"city"];
        self.planSiteLabel.text = responseObject[@"planSite"];
        self.applyRequirementLabel.text = self.dataDict[@"applyRequirement"];
        self.activityDetailsLabel.text = self.dataDict[@"activityDetails"];
    } noResult:nil];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        CGRect frame = [self.dataDict[@"applyRequirement"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX)
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                        context:nil];
        return frame.size.height + 110.0;
    } else if (indexPath.row == 3) {
        CGRect frame = [self.dataDict[@"activityDetails"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX)
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                        context:nil];
        return frame.size.height + 110.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end
