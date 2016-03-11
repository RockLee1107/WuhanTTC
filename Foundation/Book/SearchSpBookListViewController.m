//
//  SearchSpBookListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SearchSpBookListViewController.h"
#import "StringUtil.h"
#import "BookSearcher.h"
#import "BookTableViewCell.h"
#import "StringUtil.h"
#import "BookDetailViewController.h"
#import "SubTabBarController.h"

@interface SearchSpBookListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchSpBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchData];
    // Do any additional setup after loading the view.
}

-(void)fetchData {
    HttpService *service = [HttpService getInstance];
    BookSearcher *searcher = [[BookSearcher alloc] init];
    searcher.specialCode = ((SubTabBarController *)self.tabBarController).specialCode;
    NSDictionary *dict = [searcher dictionary];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    Page *page = [[Page alloc] init];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[page dictionary]]};
//    NSLog(@"json:%@",param);
    [service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject[@"result"];
        [self.tableView reloadData];
//        NSLog(@"responseObject:%@",responseObject);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:nil options:nil] firstObject];
    cell.bookNameLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"bookName"]];
    cell.bookTypeLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"bookType"]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataArray[indexPath.row][@"bookId"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
@end
