//
//  ActivityListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/17.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityListViewController.h"

@interface ActivityListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchActivityData];
//    [self fetchProjectData];
//    [self fetchInvestorData];
//    [self fetchSubjectData];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addLegendFooterWithRefreshingBlock:^{
//        weakSelf.pageIndex++;
//        [weakSelf fetchData];
//        // 拿到当前的上拉刷新控件，结束刷新状态
//        [weakSelf.tableView.footer endRefreshing];
//    }];
}

/**创活动*/
- (void)fetchActivityData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                @{
//                                  @"SEQ_typeCode":@"",
                                  @"IIN_status":@"2",
//                                  @"SEQ_city":@0,
                                  @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        NSLog(@"json:%@",param);
    [self.service GET:@"/activity/queryActivityList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataArray = responseObject[@"result"];
        [self.tableView reloadData];
                NSLog(@"responseObject:%@",responseObject);
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
