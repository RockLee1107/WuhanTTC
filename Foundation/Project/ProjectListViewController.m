//
//  ProjectListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***创投融->项目***/

#import "ProjectListViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectTableViewDelegate.h"
#import "DTKDropdownMenuView.h"
#import "MyProjectPageController.h"
#import "UserInfoTableViewController.h"
#import "StatusDict.h"
#import "ProjectModel.h"

@interface ProjectListViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    NSMutableArray *_sectionOneArray;
    NSMutableArray *_sectionTwoArray;
    NSMutableArray *_sectionThreeArray;
    ProjectModel   *_model;
}

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
@property (nonatomic,strong) NSString *orderBy;//按发布时间
@property (nonatomic,strong) NSString *area;//全国
@property (nonatomic,strong) NSString *bizCode;//类型

@property (nonatomic,strong) NSMutableArray *sIN_processStatusCodeArray;//项目阶段参数数组
@property (nonatomic,strong) NSMutableArray *sIN_bizCodeArray;//项目领域参数数组
@property (nonatomic,strong) NSMutableArray *sIN_financeProcCodeArray;//融资阶段参数数组

@property (nonatomic,strong) NSString *sIN_processStatusCode;//项目阶段参数数组
@property (nonatomic,strong) NSString *sIN_bizCode;//项目领域参数数组
@property (nonatomic,strong) NSString *sIN_financeProcCode;//融资阶段参数数组

@end

@implementation ProjectListViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

//视图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sIN_processStatusCodeArray = [[NSMutableArray alloc] init];
    self.sIN_bizCodeArray = [[NSMutableArray alloc] init];
    self.sIN_financeProcCodeArray = [[NSMutableArray alloc] init];
    
    [self initDelegate];
    [self initRefreshControl];
    [self initSearchConditionView];
    [self addRightItem];
    self.bizCode = @"all";//默认按全国加载
    self.orderBy = @"pbDate";//加载时默认是按发布时间加载
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
    //请求的参数
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
    if (self.area != nil) {
        [dict setObject:self.area forKey:@"SEQ_area"];
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
    NSLog(@"~~~~~~~~~\n%@", dict);
    
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};

    
    /***此处GET请求把参数处理下也可以***/
//    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        if (self.page.pageNo == 1) {
//            
//            
//            //由于下拉刷新时页面而归零
//            [self.tableViewDelegate.dataArray removeAllObjects];
//            [self.tableView.footer resetNoMoreData];
//        }
//        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
//        [self.tableView reloadData];
//    } noResult:^{
//        [self.tableView.footer noticeNoMoreData];
//    }];
    
    
    [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

- (void)fetchRankData {
    //如果用户筛选了三组信息
    if (![self.sIN_processStatusCode isEqualToString:@""] && ![self.sIN_bizCode isEqualToString:@""] && ![self.sIN_financeProcCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_processStatusCode":self.sIN_processStatusCode,
                                       @"sIN_bizCode":self.sIN_bizCode,
                                       @"sIN_financeProcCode":self.sIN_financeProcCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111222333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //筛选了两组信息 第一组和第二组
    if (![self.sIN_processStatusCode isEqualToString:@""] && ![self.sIN_bizCode isEqualToString:@""] && [self.sIN_financeProcCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_processStatusCode":self.sIN_processStatusCode,
                                       @"sIN_bizCode":self.sIN_bizCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111222");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //第一组和第三组
    if (![self.sIN_processStatusCode isEqualToString:@""] && ![self.sIN_financeProcCode isEqualToString:@""] && [self.sIN_bizCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_processStatusCode":self.sIN_processStatusCode,
                                       @"sIN_financeProcCode":self.sIN_financeProcCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //第二组和第三组
    if (![self.sIN_bizCode isEqualToString:@""] && ![self.sIN_financeProcCode isEqualToString:@""] && [self.sIN_processStatusCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_bizCode":self.sIN_bizCode,
                                       @"sIN_financeProcCode":self.sIN_financeProcCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"222333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //只筛选了第一组
    if (![self.sIN_processStatusCode isEqualToString:@""] && [self.sIN_bizCode isEqualToString:@""] && [self.sIN_financeProcCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_processStatusCode":self.sIN_processStatusCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //只筛选了第二组
    if (![self.sIN_bizCode isEqualToString:@""] && [self.sIN_processStatusCode isEqualToString:@""] && [self.sIN_financeProcCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_bizCode":self.sIN_bizCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"222");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    //只筛选了第三组
    if (![self.sIN_financeProcCode isEqualToString:@""] && [self.sIN_processStatusCode isEqualToString:@""] && [self.sIN_bizCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"IEQ_status":@"2",
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"sIN_bizCode":self.sIN_financeProcCode
                                       }];
        //    条件1
        if (self.orderBy != nil) {
            [dict setObject:self.orderBy forKey:@"SEQ_orderBy"];
        }
        //    条件2
        if (self.area != nil) {
            [dict setObject:self.area forKey:@"SEQ_area"];
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
        NSLog(@"~~~~~~~~~\n%@", dict);
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        NSLog(@"%@", param);
        
        [self.service POST:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.tableView.footer noticeNoMoreData];
        }];
    }
    
}

///导航栏下拉菜单
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    //点击我的项目
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的项目" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            MyProjectPageController *vc = [[MyProjectPageController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }];
    //点击创建项目
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建项目" iconName:@"menu_create" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
           [self performSegueWithIdentifier:@"create" sender:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }];
    //点击搜索
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

#pragma mark - 下拉筛选菜单
- (void)initSearchConditionView{
    self.dataTitle = @[@"按发布时间",@"全国",@"类型"];
    self.data1 = @[
                   @[@"pbDate",@"按发布时间"],
                   @[@"commNum",@"按关注度"]
                   ];
    
    //第二个元素 武汉 暂时去掉
    self.data2 = @[
                   @[@"",@"全国"],
                   @[@"武汉",@"武汉"]
                   ];
    
    
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@[@"all",@"全部"]];
    

    //获得本地存储的数据源 第一组
    NSArray *arrayOne = [StatusDict procStatus];
    _sectionOneArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictOne in arrayOne) {
        _model = [[ProjectModel alloc] init];
        _model.title = @"项目阶段";
        [_sectionOneArray addObject:@[dictOne[@"procStatusCode"],dictOne[@"procStatusName"]]];
        _model.sectionArray = _sectionOneArray;
    }
    [names addObject:_model];
    
    //第二组
    NSArray *arrayTwo = [StatusDict industry];
    _sectionTwoArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictTwo in arrayTwo) {
        _model = [[ProjectModel alloc] init];
        _model.title = @"项目领域";
        [_sectionTwoArray addObject:@[dictTwo[@"bizCode"],dictTwo[@"bizName"]]];
        _model.sectionArray = _sectionTwoArray;
    }
    [names addObject:_model];
    
    //第三组
    NSArray *arrayThree = [StatusDict financeProc];
    _sectionThreeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictThree in arrayThree) {
        _model = [[ProjectModel alloc] init];
        _model.title = @"融资阶段";
        [_sectionThreeArray addObject:@[dictThree[@"financeProcCode"],dictThree[@"financeProcName"]]];
        _model.sectionArray = _sectionThreeArray;
    }
    [names addObject:_model];

    self.data3 = names;
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.bigArray = self.data3;
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    //搜索条件的代理
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

#pragma mark - 第三栏代理传值
- (void)sendInfoWithSectionOne:(NSArray *)sectionOneArray SectionTwo:(NSArray *)sectionTwoArray SectionThree:(NSArray *)sectionThreeArray {
    
    //项目阶段
    [self.sIN_processStatusCodeArray addObjectsFromArray:sectionOneArray];
    //项目领域
    [self.sIN_bizCodeArray addObjectsFromArray:sectionTwoArray];
    //融资阶段
    [self.sIN_financeProcCodeArray addObjectsFromArray:sectionThreeArray];
    
    
    self.sIN_processStatusCode = [self.sIN_processStatusCodeArray componentsJoinedByString:@","];
    self.sIN_bizCode = [self.sIN_bizCodeArray componentsJoinedByString:@","];
    self.sIN_financeProcCode = [self.sIN_financeProcCodeArray componentsJoinedByString:@","];
    
    [self fetchRankData];
    //请求完成一次后删掉之前的数据
    [self.sIN_processStatusCodeArray removeAllObjects];
    [self.sIN_bizCodeArray removeAllObjects];
    [self.sIN_financeProcCodeArray removeAllObjects];
}

#pragma mark - 筛选栏
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column {
    if (column == 0 || column == 1) {
        return NO;
    }
    //第三个是CollectionView
    else {
        return YES;
    }
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
    
    }
    return nil;
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
        [self fetchData];
    }
    
    else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        self.area = self.data2[indexPath.row][0];
        [self fetchData];
    }
    
    else{
        
//        _currentData3Index = indexPath.row;
//        self.bizCode = self.data3[indexPath.row][0];
//        [self fetchData];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

@end
