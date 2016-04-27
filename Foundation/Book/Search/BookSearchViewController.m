//
//  BookSearchViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BookListDelegate.h"
#import "BookSearchTableViewCell.h"
#import "BookSearchByTitleOrOthersTableViewController.h"
#import "Masonry.h"

@interface BookSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate ,UISearchDisplayDelegate>
@property (weak,nonatomic) IBOutlet UITableView *parentTableView;
@property (strong,nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *keyWords;
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) Page *hotPage;
@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentTableView.delegate = self;
    self.parentTableView.dataSource = self;
    self.tableView = [[UITableView alloc] init];
    [self initDelegate];
    self.searchBar.delegate = self;
    [self.parentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.scrollEnabled = NO;
    self.hotPage = [[Page alloc] init];
    self.hotPage.pageSize = 9;
    [self initGridView];
    // Do any additional setup after loading the view.
}

//网格视图-热搜
- (void)initGridView {
//    init 容器
    self.gridView = [[UIView alloc] init];
    self.gridView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    [self.view addSubview:self.gridView];
//    init 标题
    UILabel *captionLabel = [[UILabel alloc] init];
    captionLabel.tintColor = [UIColor darkGrayColor];
    captionLabel.font = [UIFont systemFontOfSize:16.0];
    captionLabel.text = @"大家都在搜:";
    [self.gridView addSubview:captionLabel];
//    init 右按钮
    UIButton *rightButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rightButton setImage:[UIImage imageNamed:@"app_next.png"] forState:(UIControlStateNormal)];
    [self.gridView addSubview:rightButton];
//    init 左按钮
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [leftButton setImage:[UIImage imageNamed:@"app_pre.png"] forState:(UIControlStateNormal)];
    [self.gridView addSubview:leftButton];
//    update 容器
    [self.gridView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(108);
        
    }];
//    update 标题
    [captionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gridView.mas_left).offset(10);
        make.top.equalTo(self.gridView.mas_top).offset(20);
    }];
//    update 右按钮
    [rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gridView.mas_right).offset(-10);
        make.top.equalTo(self.gridView.mas_top).offset(20);
    }];
//    update 左按钮
    [leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightButton.mas_left).offset(-20);
        make.top.equalTo(self.gridView.mas_top).offset(20);
    }];
    [self fetchHotLabel];
}

//热门
- (void)fetchHotLabel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.specialCode) {
        [dict setObject:self.specialCode forKey:@"SEQ_specialCode"];
    }
    NSDictionary *param = @{
                            @"QueryParams":[StringUtil dictToJson:dict],
                            @"Page":[StringUtil dictToJson:[self.hotPage dictionary]]
                            };
    [self.service POST:@"book/label/queryHotLabel" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //render grid view
        for (int i = 0; i < [responseObject count]; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [button setTitleColor:MAIN_COLOR forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [button setTitle:responseObject[i][@"labelName"] forState:(UIControlStateNormal)];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.cornerRadius = 4.0;
            [self.gridView addSubview:button];
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.gridView.mas_top).with.offset(50 + i / 3 * (40 + 10));
                switch (i % 3) {
                    case 0:
                        make.left.equalTo(self.gridView.mas_left).offset(5);
                        break;
                    case 1:
                        make.centerX.equalTo(self.gridView.mas_centerX);
                        break;
                    case 2:
                        make.right.equalTo(self.gridView.mas_right).offset(-5);
                        break;
                    default:
                        break;
                }
                make.width.mas_equalTo(SCREEN_WIDTH / 3 - 10);
                make.height.mas_equalTo(40);
            }];
        }
    } noResult:nil];
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
    self.page.pageSize = 10;
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.gridView.hidden = NO;
//        self.tableView.hidden = YES;
    } else {
        self.gridView.hidden = YES;
//        self.tableView.hidden = NO;
    }
}
#pragma mark - tb delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    共3组
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.keyWords == nil) {
        return 0;
    }
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
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        //    第一组第一行，第二组、第三组返回平常的cell
        BookSearchTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookSearchTableViewCell" owner:nil options:nil] firstObject];
        [cell.titleButton setTitle:@"相关文章" forState:(UIControlStateNormal)];
        cell.moreLabel.hidden = NO;
        return cell;
    } else if (indexPath.section == 1) {
        BookSearchTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookSearchTableViewCell" owner:nil options:nil] firstObject];
        [cell.titleButton setTitle:@"搜索作者" forState:(UIControlStateNormal)];
        return cell;
    } else if (indexPath.section == 2) {
        BookSearchTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookSearchTableViewCell" owner:nil options:nil] firstObject];
        [cell.titleButton setTitle:@"搜索标签" forState:(UIControlStateNormal)];
        return cell;
    }
    return [UITableViewCell new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return self.tableViewDelegate.dataArray.count * 70.0;
    }
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookSearchByTitleOrOthersTableViewController *vc = [[BookSearchByTitleOrOthersTableViewController alloc] init];
    vc.keyWords = self.keyWords;
    if (indexPath.section == 0 && indexPath.row == 0) {
        vc.type = @"SLIKE_bookTitle";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        vc.type = @"SLIKE_authorName";
        [self.navigationController pushViewController:vc animated:YES];
    } else if(indexPath.section == 2 && indexPath.row == 0) {
        vc.type = @"SLIKE_labelName";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
