//
//  SearchSpBookListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SearchSpBookListViewController.h"
#import "BookSearcher.h"
#import "BookDetailViewController.h"
#import "SubTabBarController.h"
#import "BookListDelegate.h"

@interface SearchSpBookListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *nameNavigationItem;

@end

@implementation SearchSpBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameNavigationItem.title = ((SubTabBarController *)self.tabBarController).specialName;
    [self initDelegate];
    [self initRefreshControl];
//    self.nameNavigationItem.title = @"2";
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
    self.tableViewDelegate = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

-(void)fetchData {

    BookSearcher *searcher = [[BookSearcher alloc] init];
    searcher.specialCode = ((SubTabBarController *)self.tabBarController).specialCode;
    NSDictionary *dict = [searcher dictionary];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
//    NSLog(@"json:%@",param);
//    [self.service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataImmutableArray = responseObject[@"result"];
//        [self.tableView reloadData];
////        NSLog(@"responseObject:%@",responseObject);
//    }];
    [self.service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject[@"result"]];
        [self.tableView reloadData];
    }];
}




@end
