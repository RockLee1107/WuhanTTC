//
//  ActivityListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/17.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityTableViewCell.h"

@interface ActivityListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self fetchProjectData];
//    [self fetchInvestorData];
//    [self fetchSubjectData];
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.pageIndex++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataMutableArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:object[@"pictUrl"]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    /**标题*/
    cell.activityTitleLabel.text = object[@"activityTitle"];
    /**状态*/
    cell.statusLabel.text = ACTIVITY_STATUS_ARRAY[[object[@"status"] integerValue]];
    /**开始时间*/
    cell.planDateLabel.text = [ DateUtil toShortDate:object[@"planDate"]];
    /**城市*/
    cell.cityLabel.text = object[@"city"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0;
}

/**创活动*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                @{
//                                  @"SEQ_typeCode":@"",
//                                  @"IIN_status":@"2",
//                                  @"SEQ_city":@0,
                                  @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
//        NSLog(@"json:%@",param);
    [self.service GET:@"/activity/queryActivityList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataArray = responseObject[@"result"];
        [self.dataMutableArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
//                NSLog(@"responseObject:%@",responseObject);
    }];
}

/**创连接项目*/
- (void)fetchProjectData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   //@"SEQ_typeCode":@"",
//                                   @"SEQ_area":@2,
//                                   @"SEQ_bizCode":
//                                   @"SEQ_processStatusCode":项目阶段状态
//                                    @"SEQ_financeProcCode":融资情况
//                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    NSLog(@"json:%@",param);
    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataArray = responseObject[@"result"];
//        [self.tableView reloadData];
        NSLog(@"responseObject:%@",responseObject);
    }];
}

/**创活动投资人*/
- (void)fetchInvestorData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{

                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    NSLog(@"json:%@",param);
    [self.service GET:@"/personal/info/queryInvestorInfoDtoList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataArray = responseObject[@"result"];
//        [self.tableView reloadData];
        NSLog(@"responseObject:%@",responseObject);
    }];
}

/**创活动投资人*/
- (void)fetchSubjectData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"SEQ_specialCode":@"zl0001"
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    NSLog(@"json:%@",param);
    [self.service GET:@"/book/postSubject/queryPostSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        self.dataArray = responseObject[@"result"];
        //        [self.tableView reloadData];
        NSLog(@"responseObject:%@",responseObject);
    }];
}
@end
