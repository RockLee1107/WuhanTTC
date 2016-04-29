//
//  MyProjectTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyProjectTableViewController.h"
#import "ProjectTableViewDelegate.h"

@interface MyProjectTableViewController ()

@end

@implementation MyProjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self initRefreshControl];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if ([self.SEQ_queryType isEqualToString:@"CREATE"]) {
        self.navigationItem.title = @"创建的项目";
    } else if ([self.SEQ_queryType isEqualToString:@"JOIN"]) {
        self.navigationItem.title = @"参与的项目";
    } else if ([self.SEQ_queryType isEqualToString:@"ATTENTION"]) {
        self.navigationItem.title = @"关注的项目";
    } else if ([self.SEQ_queryType isEqualToString:@"RECEIVED"]) {
        self.navigationItem.title = @"收到的项目";
    } else {
        self.navigationItem.title = @"项目";
    }
    // Do any additional setup after loading the view.
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
    self.tableViewDelegate = [[ProjectTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    //    硬编码判断类型，先行强转
    ProjectTableViewDelegate *tableViewDelegate = (ProjectTableViewDelegate *)self.tableViewDelegate;
    self.tableViewDelegate = tableViewDelegate;
    NSDictionary *dict = @{
                           @"CREATE":@"create",
                           @"JOIN":@"join",
                           @"ATTENTION":@"attention",
                           @"RECEIVED":@"received"
                           };
    if (!self.userId) {
        //self.userId代表从创友录等用户资料点击而进来的
        tableViewDelegate.delType = dict[self.SEQ_queryType];
    }
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/**创连接项目*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   //                                  @"SEQ_typeCode":@"",
//                                                                     @"IEQ_status":@"2",
                                   //                                  @"SEQ_city":@0,
                                   //                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                   @"SEQ_userId":self.userId != nil ? self.userId : [User getInstance].uid,
                                   @"SEQ_queryType":self.SEQ_queryType
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
    }];
}

@end
