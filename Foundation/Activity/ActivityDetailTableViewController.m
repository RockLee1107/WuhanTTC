//
//  ActivityDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityDetailTableViewController.h"
#import "LXGallery.h"
#import "JCTagListView.h"
#import "ApplyListTableViewController.h"

@interface ActivityDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDatetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDatetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *planSiteLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *applyRequirementLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDetailsLabel;
//图集
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (nonatomic,strong) NSArray *urlArray;
//报名人信息
@property (nonatomic, strong) JCTagListView *tagListView;
//非本人隐藏之
@property (weak, nonatomic) IBOutlet UIView *applyListView;
@property (weak, nonatomic) IBOutlet UIButton *applyListButton;

@end

@implementation ActivityDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//从编辑页面返回时要刷新自身，因为是本地dict传值，没有访问网络
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"activityId":self.activityId
                            };
    
    [self.service POST:@"/activity/getActivity" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        [self.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"pictUrl"]]]]];
        self.pictUrlImageView.clipsToBounds = YES;
        self.activityTitleLabel.text = [StringUtil toString:responseObject[@"activityTitle"]];
        self.typeLabel.text = [StringUtil toString:responseObject[@"type"]];
        
//        self.statusLabel.text = ACTIVITY_STATUS_ARRAY[[responseObject[@"status"] integerValue]];
        
        //如果报名人数未满，且报名时间未截止，显示报名中
        if([responseObject[@"applyNum"] integerValue] < [responseObject[@"planJoinNum"] integerValue]
           && [DateUtil isDestDateInFuture:[[StringUtil toString:responseObject[@"endDate"]] stringByAppendingString:[StringUtil toString:responseObject[@"endTime"]]]]){
            /**状态*/
            self.statusLabel.text = @"报名中";
            self.statusLabel.backgroundColor = ACTIVITY_STATUS_ON_COLOR;
        }
        //如果报名人数已满，且报名时间未截止，显示已满
        else if([responseObject[@"applyNum"] integerValue] == [responseObject[@"planJoinNum"] integerValue]
                && [DateUtil isDestDateInFuture:[[StringUtil toString:responseObject[@"endDate"]] stringByAppendingString:[StringUtil toString:responseObject[@"endTime"]]]]){
            /**状态*/
            self.statusLabel.text = @"已满";
            self.statusLabel.backgroundColor = ACTIVITY_STATUS_FULL_COLOR;
        }
        else{
            self.statusLabel.text = @"已结束";
            self.statusLabel.backgroundColor = ACTIVITY_STATUS_OVER_COLOR;
        }
        
        
        self.planDatetimeLabel.text = [DateUtil toString:responseObject[@"planDate"] time:responseObject[@"planTime"]];
        self.endDatetimeLabel.text = [DateUtil toString:responseObject[@"endDate"] time:responseObject[@"endTime"]];
        NSString *applyNum = [responseObject[@"applyNum"] stringValue];
        NSString *planJoinNum = [responseObject[@"planJoinNum"] stringValue];
        [self.applyButton setTitle:[NSString stringWithFormat:@"%@/%@",applyNum,planJoinNum] forState:(UIControlStateNormal)];
        self.cityLabel.text = [StringUtil toString:responseObject[@"city"]];
        self.planSiteLabel.text = [StringUtil toString:responseObject[@"planSite"]];
        self.applyRequirementLabel.text = [StringUtil toString:self.dataDict[@"applyRequirement"]];
        self.activityDetailsLabel.text = [StringUtil toString:self.dataDict[@"activityDetails"]];
        if ([self.dataDict[@"createById"] isEqualToString:[User getInstance].uid]) {
            //    报名人要求
            self.tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH + 10, 110)];
            [self.applyListView addSubview:self.tagListView];
            self.tagListView.canSelectTags = NO;
            self.applyListButton.hidden = NO;
        }
        //    初始
        self.tagListView.tags = [NSMutableArray arrayWithArray:@[@"姓名",@"手机",@"公司",@"职务",@"微信",@"邮箱"]];
        //已选
        self.tagListView.selectedTags = [NSMutableArray arrayWithArray:[self.dataDict[@"infoType"] componentsSeparatedByString:@","]];
        //        图集
        self.urlArray = [[StringUtil toString:self.dataDict[@"detailPictURL"]] componentsSeparatedByString:@","];
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.urlArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.urlArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [self.pictureView addSubview:gallery];
        [self.tableView reloadData];
    } noResult:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (![self.dataDict[@"createById"] isEqualToString:[User getInstance].uid]) {
            return 0;
        }
    } else if (indexPath.row == 2) {
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

- (IBAction)applyButtonPress:(id)sender {
    if ([self.dataDict[@"createById"] isEqualToString:[User getInstance].uid]) {
        ApplyListTableViewController *vc = [[ApplyListTableViewController alloc] init];
        vc.activityId = self.activityId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
