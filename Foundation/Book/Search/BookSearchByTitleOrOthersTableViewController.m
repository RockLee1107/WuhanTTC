//
//  BookSearchViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookSearchByTitleOrOthersTableViewController.h"
#import "BookListDelegate.h"
#import "BookSearchTableViewCell.h"

@interface BookSearchByTitleOrOthersTableViewController ()
@end

@implementation BookSearchByTitleOrOthersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initRefreshControl];
    [self initDelegate];
    if ([self.type isEqualToString:@"SLIKE_bookTitle"]) {
        self.navigationItem.title = @"按文章标题搜索";
    } else if ([self.type isEqualToString:@"SLIKE_authorName"]) {
        self.navigationItem.title = @"按文章作者搜索";
    } else if ([self.type isEqualToString:@"SLIKE_labelName"]) {
        self.navigationItem.title = @"按文章标签搜索";
    } else if ([self.type isEqualToString:@"SEQ_labelId"]) {
        self.navigationItem.title = @"创成长";
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
    self.tableViewDelegate    = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate   = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

///请求网络
- (void)fetchData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{self.type:self.keyWords}];
    if (self.specialCode) {
        [dict setObject:self.specialCode forKey:@"SEQ_specialCode"];
    }
    
    if ([[User getInstance] isLogin]) {
        //管理员判断
        [dict setObject:[[User getInstance].isAdmin stringValue] forKey:@"SEQ_isAdmin"];
    }
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        //当小于每页条数，就判定加载完毕
        if ([responseObject[@"result"] count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

@end
