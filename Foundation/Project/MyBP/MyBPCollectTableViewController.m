//
//  MyBPTableViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***我的BP--->我创建的***/

#import "MyBPCollectTableViewController.h"
#import "ProjectBPDetailViewController.h"
#import "ProjectBPCell.h"
#import "VerifyTableViewController.h"

@interface MyBPCollectTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *myDataArray;

@end

@implementation MyBPCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myDataArray = [NSMutableArray array];
    [self fetchData];
    [self createUI];
    //    [self initRefreshControl];
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
    //    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.myTableView];
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
    [self.tableView.legendHeader beginRefreshing];
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
                                   @"sEQ_queryType":@"COLLECT",
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
    
    cell.viewCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"readNum"]]];
    cell.supportCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"likeNum"]]];
    cell.collectLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"collectNum"]]];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, object[@"bpLogo"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];

    
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
    //判断可见权限
    if ([object[@"bpVisible"] intValue] == 1) {
        [cell.lockImageView setImage:[UIImage imageNamed:@"app_lock"]];
    }    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.myDataArray[indexPath.row];
    ProjectBPDetailViewController *detailVC = [[ProjectBPDetailViewController alloc] init];
    detailVC.bpId = self.myDataArray[indexPath.row][@"bpId"];
    detailVC.isAppear = YES;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    //判断可见权限
    //仅投资人可见
    if ([object[@"bpVisible"] intValue] == 1) {
        //登录状态下
        if ([User getInstance].isLogin) {
            //是投资人
            if ([[User getInstance].isInvestor isEqual:@1]) {
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            //申请认证投资人
            else {
                if ([[User getInstance].bizStatus isEqualToString:@"0"]) {
                    //待审核
                    [SVProgressHUD showErrorWithStatus:@"您已提交申请,请耐心等待审核哦"];
                }else {
                    //审核不通过
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此BP仅限投资人查看,是否立即申请认证投资人?" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"我要认证", nil];
                    [alertView show];
                }
            }
            
        }
        //游客状态
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
    }
    //所有人可见
    else {
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //我要认证
    if (buttonIndex == 1) {
        //登录状态点击我要认证
        if ([User getInstance].isLogin) {
            VerifyTableViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateViewControllerWithIdentifier:@"verify"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //游客状态
        else {
            //进入团团创登陆页面
            LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        }
    }
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
