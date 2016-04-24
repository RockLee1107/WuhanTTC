//
//  ProjectListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectTableViewDelegate.h"
#import "DTKDropdownMenuView.h"
#import "MyProjectPageController.h"
#import "UserInfoTableViewController.h"
#import "StatusDict.h"

@interface ProjectListViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
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

@implementation ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self initRefreshControl];
    [self initSearchConditionView];
    [self addRightItem];
    self.bizCode = @"all";
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
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/**创连接项目*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                                                     @"IEQ_status":@"2",
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


///导航栏下拉菜单
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的项目" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        MyProjectPageController *vc = [[MyProjectPageController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建项目" iconName:@"app_create" callBack:^(NSUInteger index, id info) {
        if ([[[User getInstance] hasInfo] boolValue]) {
//            跳转到创建页面
            [self performSegueWithIdentifier:@"create" sender:nil];
        } else {
            [[PXAlertView showAlertWithTitle:@"请先完善个人资料" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UserInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateViewControllerWithIdentifier:@"userinfo"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }] useDefaultIOS7Style];
        }
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu" extraIcon:@"app_search" extraButtunCallBack:^{
        //跳转搜索页
        [self performSegueWithIdentifier:@"search" sender:nil];
    }];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
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
                   @[[LocationUtil getInstance].cityName,[LocationUtil getInstance].isSuccess == YES ? [LocationUtil getInstance].cityName : @"定位失败"]
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
    [self.tableViewDelegate.dataArray removeAllObjects];
    [self.tableView reloadData];
    //    页码归零
    self.page.pageNo = 1;
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        self.orderBy = self.data1[indexPath.row][0];
    } else if(indexPath.column == 1){
        [self fetchData];
        _currentData2Index = indexPath.row;
        self.city = self.data2[indexPath.row][0];
    } else{
        [self fetchData];
        _currentData3Index = indexPath.row;
        self.bizCode = self.data3[indexPath.row][0];
    }
    [self fetchData];
}

@end
