//
//  ProjectBPViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectBPViewController.h"
#import "StatusDict.h"
#import "DTKDropdownMenuView.h"
#import "MyProjectPageController.h"
#import "LoginViewController.h"
#import "ProjectBPCell.h"
#import "ProjectBPDetailViewController.h"

@interface ProjectBPViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *myDataArray;

//搜索条件
@property (nonatomic,strong) NSArray *dataTitle;
@property (nonatomic,strong) NSArray *data1;
@property (nonatomic,strong) NSArray *data2;
@property (nonatomic,strong) NSArray *data3;
@property (nonatomic,assign) NSInteger currentData1Index;
@property (nonatomic,assign) NSInteger currentData2Index;
@property (nonatomic,assign) NSInteger currentData3Index;
//条件值
@property (nonatomic,strong) NSString *orderBy;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *bizCode;

@end

@implementation ProjectBPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myDataArray = [[NSMutableArray alloc] init];
    
    [self initRefreshControl];
    [self initSearchConditionView];
    [self addRightItem];
    self.bizCode = @"all";
    self.orderBy = @"pbDate";
    [self loadData];
}

- (void)createUI {
    
    self.title = @"项目BP列表";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 64+44+12, SCREEN_WIDTH-24, SCREEN_HEIGHT-64-44-49-12) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    for (int i=0; i<self.myDataArray.count; i++) {
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, i*(220)+200, SCREEN_WIDTH, 20)];
        separator.backgroundColor = [UIColor lightGrayColor];
        [self.myTableView addSubview:separator];
    }
    [self.view addSubview:self.myTableView];
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.myTableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf loadData];
        [weakSelf.myTableView.header endRefreshing];
    }];
    [self.myTableView.legendHeader beginRefreshing];
    [self.myTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf loadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.myTableView.footer endRefreshing];
    }];
}

#pragma mark - 下拉筛选菜单
- (void)initSearchConditionView{
    self.dataTitle = @[@"按发布时间",@"全国",@"类型"];
    self.data1 = @[
                   @[@"pbDate",@"按发布时间"],
                   @[@"commNum",@"按关注度"]
                   ];
    self.data2 = @[
                   @[@"",@"全国"],
                   @[[LocationUtil getInstance].cityName == nil ? @"" : [LocationUtil getInstance].cityName,[LocationUtil getInstance].isSuccess == YES ? [LocationUtil getInstance].cityName : @"定位失败"]
                   ];
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@[@"all",@"全部"]];
    NSArray *array = [StatusDict industry];
    for (NSDictionary *dict in array) {
        [names addObject:@[dict[@"bizCode"],dict[@"bizName"]]];
    }
    self.data3 = names;
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //搜索条件的代理
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)addRightItem {
    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的项目" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            MyProjectPageController *vc = [[MyProjectPageController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建项目" iconName:@"menu_create" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            [self performSegueWithIdentifier:@"create" sender:nil];
        }else{
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu" extraIcon:@"app_search" extraButtunCallBack:^{
        //跳转搜索页
        [self performSegueWithIdentifier:@"search" sender:nil];
    }];
    menuView.cellColor = MENU_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"IEQ_status":@"2",
                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                   
                                   }];
    //    条件1
    if (self.orderBy != nil) {
        [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        
    }
    //    条件2
    if (self.city != nil) {
        [dict setObject:self.city forKey:@"SEQ_city"];
        
    }
    //    条件3
    if (![self.bizCode isEqualToString:@"all"]) {
        [dict setObject:self.bizCode forKey:@"SIN_bizCode"];
        
    }
    
    if ([[User getInstance] isLogin]) {
        [dict setObject:[User getInstance].uid forKey:@"SEQ_curUserId"];
        
    }
    
    //默认查询已发布的项目
    [dict setObject:@"2" forKey:@"IEQ_bizStatus"];
    
    
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.myDataArray removeAllObjects];
            [self.myTableView.footer resetNoMoreData];
        }
        [self.myDataArray addObjectsFromArray:responseObject];
        
        [self.myTableView reloadData];
        [self createUI];
    } noResult:^{
        [self.myTableView.footer noticeNoMoreData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectBPCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectBPCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.myDataArray[indexPath.row];
    
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"headPictUrl"]]]]];
    cell.titleLabel.text = @"团团创";
    cell.contentLabel.text = [StringUtil toString:object[@"projectResume"]];
    cell.typeLabel.text = @"教育培训,创业服务";
    cell.statusLabel.text = @"武汉|天使轮·已上线";
    cell.viewCount.text = @"103";
    cell.supportCount.text = @"103";
    cell.commentCount.text = @"103";

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *object = self.myDataArray[indexPath.row];
    ProjectBPDetailViewController *detailVC = [[ProjectBPDetailViewController alloc] init];
    detailVC.dataDic = object;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column == 0) {
        return _currentData1Index;
    }
    if (column == 1) {
        return _currentData2Index;
    }
    if (column == 2) {
        return _currentData3Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        return _data1.count;
    } else if (column == 1){
        return _data2.count;
    } else if (column == 2){
        return _data3.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    return self.dataTitle[column];
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return _data1[indexPath.row][1];
    } else if (indexPath.column ==1 ) {
        return _data2[indexPath.row][1];
    } else {
        return _data3[indexPath.row][1];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    //    清空
    [self.myDataArray removeAllObjects];
    [self.myTableView reloadData];
    //    页码归零
    self.page.pageNo = 1;
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        self.orderBy = self.data1[indexPath.row][0];
    } else if(indexPath.column == 1){
        [self loadData];
        _currentData2Index = indexPath.row;
        self.city = self.data2[indexPath.row][0];
    } else{
        [self loadData];
        _currentData3Index = indexPath.row;
        self.bizCode = self.data3[indexPath.row][0];
    }
    [self loadData];
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
