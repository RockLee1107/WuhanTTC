//
//  ActivityDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityDetailTableViewController.h"
#import "LXGallery.h"

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
//图集
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (nonatomic,strong) NSArray *urlArray;

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
        self.activityTitleLabel.text = [StringUtil toString:responseObject[@"activityTitle"]];
        self.typeLabel.text = [StringUtil toString:responseObject[@"type"]];
        self.statusLabel.text = ACTIVITY_STATUS_ARRAY[[responseObject[@"status"] integerValue]];
        self.planDatetimeLabel.text = [DateUtil toString:responseObject[@"planDate"] time:responseObject[@"planTime"]];
        self.endDatetimeLabel.text = [DateUtil toString:responseObject[@"endDate"] time:responseObject[@"endTime"]];
        NSString *applyNum = [responseObject[@"applyNum"] stringValue];
        NSString *planJoinNum = [responseObject[@"planJoinNum"] stringValue];
        self.applyNumLabel.text = [NSString stringWithFormat:@"%@/%@",applyNum,planJoinNum];
        self.cityLabel.text = [StringUtil toString:responseObject[@"city"]];
        self.planSiteLabel.text = [StringUtil toString:responseObject[@"planSite"]];
        self.applyRequirementLabel.text = [StringUtil toString:self.dataDict[@"applyRequirement"]];
        self.activityDetailsLabel.text = [StringUtil toString:self.dataDict[@"activityDetails"]];
//        图集
        self.urlArray = [[StringUtil toString:self.dataDict[@"detailPictURL"]] componentsSeparatedByString:@","];
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.urlArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.urlArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [self.pictureView addSubview:gallery];
//        [self.pictureView addSubview:[UIView new]];
        [self.tableView reloadData];
    } noResult:nil];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
//        活动要求
        CGRect frame = [[StringUtil toString:self.dataDict[@"applyRequirement"]] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX)
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                        context:nil];
        return frame.size.height + 110.0;
    } else if (indexPath.row == 3) {
//        活动详情
        CGRect frame = [[StringUtil toString:self.dataDict[@"activityDetails"]] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX)
                                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                                        context:nil];
        return frame.size.height + 110.0;
    } else if (indexPath.row == 4) {
//        详情图片
        CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil(self.urlArray.count / 4.0);
        return 40 + height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
