//
//  ActivityListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/17.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityTableViewDelegate.h"

@interface ActivityListViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self initRefreshControl];
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf fetchData];
        [weakSelf.tableView.header endRefreshing];
    }];
    [self.tableView.legendHeader beginRefreshing];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[ActivityTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
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
    [self.service GET:@"/activity/queryActivityList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    }];
}

///**创连接项目*/
//- (void)fetchProjectData{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
//                                 @{
//                                   //@"SEQ_typeCode":@"",
////                                   @"SEQ_area":@2,
////                                   @"SEQ_bizCode":
////                                   @"SEQ_processStatusCode":项目阶段状态
////                                    @"SEQ_financeProcCode":融资情况
////                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
//                                   }];
//    NSString *jsonStr = [StringUtil dictToJson:dict];
//    
//    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
//    NSLog(@"json:%@",param);
//    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        self.dataArray = responseObject[@"result"];
////        [self.tableView reloadData];
//        NSLog(@"responseObject:%@",responseObject);
//    }];
//}
//
///**创活动投资人*/
//- (void)fetchInvestorData{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
//                                 @{
//
//                                   }];
//    NSString *jsonStr = [StringUtil dictToJson:dict];
//    
//    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
//    NSLog(@"json:%@",param);
//    [self.service GET:@"/personal/info/queryInvestorInfoDtoList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        self.dataArray = responseObject[@"result"];
////        [self.tableView reloadData];
//        NSLog(@"responseObject:%@",responseObject);
//    }];
//}
//
///**创活动投资人*/
//- (void)fetchSubjectData{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
//                                 @{
//                                   @"SEQ_specialCode":@"zl0001"
//                                   }];
//    NSString *jsonStr = [StringUtil dictToJson:dict];
//    
//    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
//    NSLog(@"json:%@",param);
//    [self.service GET:@"/book/postSubject/queryPostSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        self.dataArray = responseObject[@"result"];
//        //        [self.tableView reloadData];
//        NSLog(@"responseObject:%@",responseObject);
//    }];
//}
@end
