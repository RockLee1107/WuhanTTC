//
//  MyBPTableViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***我的BP--->我创建的***/

#import "MyBPTableViewController.h"
#import "ProjectIndexTableViewDelegate.h"
#import "ProjectBPDetailViewController.h"
#import "ProjectBPCell.h"
#import "User.h"

@interface MyBPTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *myDataArray;

@end

@implementation MyBPTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [User getInstance].projectId = @"";
    NSString *pid = [User getInstance].projectId;
    NSLog(@"===========置空老id\n pid:%@", pid);
    
    //从项目详情返回到我创建的BP后，将单例置空
    [User getInstance].isCloseItem = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.fromMember == YES) {
        self.tableView.contentInset = UIEdgeInsetsMake(-36.0, 0, 0, 0);
    }else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self fetchData];
    self.myDataArray = [NSMutableArray array];
    
    [self createUI];
    
    if ([self.SEQ_queryType isEqualToString:@"CREATE"]) {
        self.navigationItem.title = @"创建的项目";
    } else if ([self.SEQ_queryType isEqualToString:@"COLLECT"]) {
        self.navigationItem.title = @"收藏的项目";
    } else {
        self.navigationItem.title = @"项目";
    }
}

- (void)createUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self initRefreshControl];
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf.myDataArray removeAllObjects];
        [weakSelf fetchData];
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    //[self.myTableView.legendHeader beginRefreshing];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
}

/**创连接项目*/
- (void)fetchData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"sEQ_orderBy":@"pbDate",
                                   @"sEQ_queryType":@"CREATE",
                                   @"sEQ_userId":[User getInstance].uid
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"/bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.myDataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:nil];
}
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBPCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectBPCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.myDataArray[indexPath.row];
    
    cell.titleLabel.text = [StringUtil toString:object[@"bpName"]];
    
    cell.separatorLine.backgroundColor = SEPARATORLINE;
    cell.viewCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"readNum"]]];
    cell.supportCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"likeNum"]]];
    cell.collectLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"collectNum"]]];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, object[@"bpLogo"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];
    
    //切圆角
    cell.iconImageView.layer.cornerRadius  = 5;
    cell.iconImageView.layer.masksToBounds = YES;
    
    //待审核
    if ([[object[@"bizStatus"] stringValue] isEqualToString:@"1"] ) {
        cell.statusLabel.text = @"待审核";
        cell.statusLabel.backgroundColor = [UIColor orangeColor];
    }else if ([[object[@"bizStatus"] stringValue] isEqualToString:@"2"] ) {
        cell.statusLabel.text = @"已发布";
        cell.statusLabel.backgroundColor = [UIColor greenColor];
    }else {
        cell.statusLabel.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectBPDetailViewController *detailVC = [[ProjectBPDetailViewController alloc] init];
    detailVC.bpId = self.myDataArray[indexPath.row][@"bpId"];
    detailVC.isAppear = NO;//private   isAppear 入口是私有的private
    detailVC.isUpdateBP = YES;//private进入的可以修改BP
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
