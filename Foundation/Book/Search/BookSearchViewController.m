//
//  BookSearchViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BookListDelegate.h"

@interface BookSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate ,UISearchDisplayDelegate>
@property (weak,nonatomic) IBOutlet UITableView *parentTableView;
@property (strong,nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *keyWords;
@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentTableView.delegate = self;
    self.parentTableView.dataSource = self;
    self.tableView = [[UITableView alloc] init];
    [self initDelegate];
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view.
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

///请求网络
- (void)fetchData {
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:@{
                                                                     @"SLIKE_bookTitle":self.keyWords
                                                                     }],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tableViewDelegate.dataArray = responseObject[@"result"];
        [self.tableView reloadData];
        [self.parentTableView reloadData];
    } noResult:^{
        
    }];
}

#pragma mark - search delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keyWords = searchBar.text;
    [searchBar resignFirstResponder];
    [self fetchData];
}

#pragma mark - tb delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    共3组
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//        第一组2个
        return 2;
    }
//    第二、三组1个
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
//        第一组、第二行内嵌表格
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70.0 * self.tableViewDelegate.dataArray.count);
        [cell addSubview:self.tableView];
    }
//    第一组第一行，第二组、第三组返回平常的cell
    return [UITableViewCell new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return self.dataArray.count * 70.0;
    }
    return 55.0;
}
@end
