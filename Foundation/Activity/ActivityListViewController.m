//
//  ActivityListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/17.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/******创活动首页******/

#import "ActivityListViewController.h"
#import "ActivityTableViewDelegate.h"
#import "DTKDropdownMenuView.h"
#import "MyActivityPageController.h"
#import "StatusDict.h"
#import "LoginViewController.h"

@interface ActivityListViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
//搜索条件
@property (nonatomic,strong) NSArray *dataTitle;//按发布时间；全国；类型
@property (nonatomic,strong) NSArray *data1;//按发布时间
@property (nonatomic,strong) NSArray *data2;//全国
@property (nonatomic,strong) NSArray *data3;//类型
@property (nonatomic,assign) NSInteger currentData1Index;
@property (nonatomic,assign) NSInteger currentData2Index;
@property (nonatomic,assign) NSInteger currentData3Index;
//条件值
@property (nonatomic,strong) NSString *orderBy;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *typeCode;
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化代理
    [self initDelegate];
    //上拉下拉控件
    [self initRefreshControl];
    [self initSearchConditionView];
    [self addRightItem];
    self.typeCode = @"all";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    self.tableViewDelegate = [[ActivityTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/**创活动*/
- (void)fetchData{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                @{
                                  @"IEQ_bizStatus":@"2",
                                  @"SEQ_orderBy":@"planDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
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
    if (![self.typeCode isEqualToString:@"all"]) {
        [dict setObject:self.typeCode forKey:@"SEQ_typeCode"];
        
    }
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    
    [SVProgressHUD dismiss];
    [self.service POST:@"/activity/queryActivityList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
        
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
        NSLog(@"%ld", self.page.pageNo);
    }];
    
}

///导航栏下拉菜单 1
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的活动" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
         if ([[User getInstance] isLogin]) {
             MyActivityPageController *vc = [[MyActivityPageController alloc] init];
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }else{
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
             [alertView show];
         }
           }];
    
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建活动" iconName:@"menu_create" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            [self performSegueWithIdentifier:@"create" sender:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 下拉筛选菜单
- (void)initSearchConditionView{
    self.dataTitle = @[@"按发布时间",@"全国",@"类型"];
    self.data1 = @[
                   @[@"pbDate",@"按发布时间"],
                   @[@"readNum",@"按开始时间"],
                   @[@"commNum",@"按参与数"]
                   ];
    /** 定位问题  第二个元素修改 @[@"1",@"线上"],  第三个元素修改 [LocationUtil getInstance].cityName == nil ? @"" : [LocationUtil getInstance].cityName,[LocationUtil getInstance].isSuccess == YES ? [LocationUtil getInstance].cityName : @"定位失败"]**/
    self.data2 = @[
                   @[@"",@"全国"],
                   @[@"线上",@"线上"],
                   @[@"武汉",@"武汉"]
                   ];
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@[@"all",@"全部"]];
    NSArray *array = [StatusDict activityType];
    if(array != nil && array.count > 0){
        for (NSDictionary *dict in array) {
            [names addObject:@[dict[@"typeCode"],dict[@"typeName"]]];
        }
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
    if (column == 0) {
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
        _currentData2Index = indexPath.row;
        self.city = self.data2[indexPath.row][0];
    } else{
        _currentData3Index = indexPath.row;
        self.typeCode = self.data3[indexPath.row][0];
    }
    /**刷新表格*/
    [self fetchData];
   
}

@end
