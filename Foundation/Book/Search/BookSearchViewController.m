//
//  BookSearchViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/********搜索栏下是9个button********/

#import "BookSearchViewController.h"
#import "BookListDelegate.h"
#import "BookSearchTableViewCell.h"
#import "BookSearchByTitleOrOthersTableViewController.h"
#import "Masonry.h"

@interface BookSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak,nonatomic) IBOutlet UITableView *parentTableView;
@property (strong,nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;//搜索栏
@property (strong, nonatomic) NSString *keyWords;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) Page *hotPage;
@property (strong, nonatomic) NSArray *labelArray;
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
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
    [self initContainerView];
    // Do any additional setup after loading the view.
}
#pragma mark - containerView
//网格视图-热搜
- (void)initContainerView {
//    init 容器
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    [self.view addSubview:self.containerView];
//    init 标题
    UILabel *captionLabel = [[UILabel alloc] init];
    captionLabel.tintColor = [UIColor darkGrayColor];
    captionLabel.font = [UIFont systemFontOfSize:16.0];
    captionLabel.text = @"大家都在搜:";
    [self.containerView addSubview:captionLabel];
//    init 右按钮
    self.rightButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.rightButton setImage:[UIImage imageNamed:@"app_next.png"] forState:(UIControlStateNormal)];
    [self.containerView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(pageGoNext:) forControlEvents:(UIControlEventTouchUpInside)];

//    init 左按钮
    self.leftButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.leftButton setImage:[UIImage imageNamed:@"app_pre.png"] forState:(UIControlStateNormal)];
    [self.containerView addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(pageGoPre:) forControlEvents:(UIControlEventTouchUpInside)];
//    init gridView
    self.gridView = [[UIView alloc] init];
    [self.containerView addSubview:self.gridView];
//    update 容器
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(108);
        
    }];
//    update 标题
    [captionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(10);
        make.top.equalTo(self.containerView.mas_top).offset(20);
    }];
//    update 右按钮
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-10);
        make.top.equalTo(self.containerView.mas_top).offset(20);
    }];
//    update 左按钮
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightButton.mas_left).offset(-20);
        make.top.equalTo(self.containerView.mas_top).offset(20);
    }];
//    update gridView
    [self.gridView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(captionLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        
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
        //render container view
        self.labelArray = responseObject;
        //如果热门栏目少于9个，就不能向右滑动
        if ([responseObject count] < 9) {
            self.rightButton.enabled = NO;
        } else {
            self.rightButton.enabled = YES;
        }
        [self reloadLabel];
    } noResult:nil];
}

- (void) reloadLabel {
    //清空原来的Label
    for (UIView *button in self.gridView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    
//    加载新的Label
    for (int i = 0; i < [self.labelArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setTitleColor:MAIN_COLOR forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:self.labelArray[i][@"labelName"] forState:(UIControlStateNormal)];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 4.0;
        [self.gridView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(searchByLabelId:) forControlEvents:(UIControlEventTouchUpInside)];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gridView.mas_top).with.offset(i / 3 * (40 + 10));
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
}

//标签按钮点击
- (void)searchByLabelId:(UIButton *)sender {
    NSString *labelId = self.labelArray[sender.tag][@"id"];
    BookSearchByTitleOrOthersTableViewController *vc = [[BookSearchByTitleOrOthersTableViewController alloc] init];
    vc.keyWords = labelId;
    vc.type = @"SEQ_labelId";
    if (self.specialCode) {
        vc.specialCode = self.specialCode;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//上翻
- (void)pageGoPre:(UIButton *)sender {
    if (self.hotPage.pageNo == 1) {
        [SVProgressHUD showErrorWithStatus:@"已经是第一页了"];
    } else {
        self.hotPage.pageNo--;
    }
    [self fetchHotLabel];
}

//下翻
- (void)pageGoNext:(UIButton *)sender {
    self.hotPage.pageNo++;
    [self fetchHotLabel];
}
#pragma mark - init
//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

//请求网络
- (void)fetchData {
    self.page.pageSize = 10;
//    specialCode
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                         @"SLIKE_bookTitle":self.keyWords
                                                                         }];
    if (self.specialCode) {
        [dict setObject:self.specialCode forKey:@"SEQ_specialCode"];
    }
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
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
        self.containerView.hidden = NO;
//        self.tableView.hidden = YES;
    } else {
        self.containerView.hidden = YES;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
