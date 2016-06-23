//
//  ProjectBPViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***项目BP列表***/

#import "ProjectBPViewController.h"
#import "StatusDict.h"
#import "DTKDropdownMenuView.h"
#import "MyBPViewController.h"
#import "LoginViewController.h"
#import "ProjectBPCell.h"
#import "ProjectBPDetailViewController.h"
#import "CreateBPViewController.h"
#import "ProjectModel.h"
#import "ProjectTableViewDelegate.h"

@interface ProjectBPViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_sectionOneArray;
    NSMutableArray *_sectionTwoArray;
    NSMutableArray *_sectionThreeArray;
    ProjectModel   *_model;
}

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
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *bizCode;
@property (nonatomic,strong) NSString *typeCode;

@property (nonatomic,strong) NSMutableArray *sIN_processStatusCodeArray;//项目阶段参数数组
@property (nonatomic,strong) NSMutableArray *sIN_bizCodeArray;//项目领域参数数组
@property (nonatomic,strong) NSMutableArray *sIN_financeProcCodeArray;//融资阶段参数数组

@property (nonatomic,strong) NSString *sIN_processStatusCode;//项目阶段参数数组
@property (nonatomic,strong) NSString *sIN_bizCode;//项目领域参数数组
@property (nonatomic,strong) NSString *sIN_financeProcCode;//融资阶段参数数组

@end

@implementation ProjectBPViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sIN_processStatusCodeArray = [[NSMutableArray alloc] init];
    self.sIN_bizCodeArray = [[NSMutableArray alloc] init];
    self.sIN_financeProcCodeArray = [[NSMutableArray alloc] init];
    self.title = @"项目BP列表";
    self.myDataArray = [[NSMutableArray alloc] init];
    [self initSearchConditionView];
    [self addRightItem];
    self.bizCode = @"all";
    self.orderBy = @"pbDate";

}

- (void)createUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+12, SCREEN_WIDTH, SCREEN_HEIGHT-64-12) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.myTableView];
    
    [self initRefreshControl];
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
    //[self.myTableView.legendHeader beginRefreshing];
    [self.myTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf loadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.myTableView.footer endRefreshing];
    }];
}

#pragma mark - 下拉筛选菜单
- (void)initSearchConditionView{
    self.dataTitle = @[@"按发布时间",@"全国",@"筛选"];
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
    NSArray *array = [StatusDict financeProc];
    if(array != nil && array.count > 0){
        for (NSDictionary *dict in array) {
            [names addObject:@[dict[@"financeProcCode"],dict[@"financeProcName"]]];
        }
    }
    
    self.data3 = names;
    
//    NSMutableArray *names = [NSMutableArray array];
//    [names addObject:@[@"all",@"全部"]];
//    //获得本地存储的数据源 第一组
//    NSArray *arrayOne = [StatusDict procStatus];
//    _sectionOneArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *dictOne in arrayOne) {
//        _model = [[ProjectModel alloc] init];
//        _model.title = @"项目阶段";
//        [_sectionOneArray addObject:@[dictOne[@"procStatusCode"],dictOne[@"procStatusName"]]];
//        _model.sectionArray = _sectionOneArray;
//    }
//    [names addObject:_model];
    
//    //第二组
//    NSArray *arrayTwo = [StatusDict industry];
//    _sectionTwoArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *dictTwo in arrayTwo) {
//        _model = [[ProjectModel alloc] init];
//        _model.title = @"项目领域";
//        [_sectionTwoArray addObject:@[dictTwo[@"bizCode"],dictTwo[@"bizName"]]];
//        _model.sectionArray = _sectionTwoArray;
//    }
//    [names addObject:_model];
//    
//    //第三组
//    NSArray *arrayThree = [StatusDict financeProc];
//    _sectionThreeArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *dictThree in arrayThree) {
//        _model = [[ProjectModel alloc] init];
//        _model.title = @"融资阶段";
//        [_sectionThreeArray addObject:@[dictThree[@"financeProcCode"],dictThree[@"financeProcName"]]];
//        _model.sectionArray = _sectionThreeArray;
//    }
//    [names addObject:_model];
//    
//    self.data3 = names;
    
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

//搜索旁的编辑按钮
- (void)addRightItem {
    __weak typeof(self) weakSelf = self;
    //点击我的BP
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的BP" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            MyBPViewController *vc = [[MyBPViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }];
    //点击创建BP
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建BP" iconName:@"menu_create" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateBPViewController" bundle:nil];
            UINavigationController *createBPVC = [storyboard instantiateViewControllerWithIdentifier:@"createBP"];
            createBPVC.title = @"创建BP";
            [weakSelf.navigationController pushViewController:createBPVC animated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 20, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu" extraIcon:@"" extraButtunCallBack:^{
        //跳转搜索页
//        [self performSegueWithIdentifier:@"search" sender:nil];
    }];
//    menuView.backgroundColor = [UIColor redColor];
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
    if (self.area != nil) {
        [dict setObject:self.area forKey:@"SEQ_area"];
        
    }
    //    条件3
    if (![self.bizCode isEqualToString:@"all"]) {
        [dict setObject:self.bizCode forKey:@"procStatusCode"];
        
    }
    
    if ([[User getInstance] isLogin]) {
        [dict setObject:[User getInstance].uid forKey:@"SEQ_curUserId"];
        
    }
    
    //默认查询已发布的项目
    [dict setObject:@"2" forKey:@"IEQ_bizStatus"];
   
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    
    [self.service POST:@"/bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

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

//筛选栏
- (void)fetchRankData {
    //如果用户筛选了三组信息
    if (![self.sIN_processStatusCode isEqualToString:@""] && ![self.sIN_bizCode isEqualToString:@""] && ![self.sIN_financeProcCode isEqualToString:@""]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"iEQ_bizStatus":@"2",
                                       @"sEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
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
//        if ([[User getInstance] isLogin]) {
//            [dict setObject:[User getInstance].uid forKey:@"SEQ_curUserId"];
//        }
        //默认查询已发布的项目
//        [dict setObject:@"2" forKey:@"IEQ_bizStatus"];
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111222333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111222");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
   
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"222333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"111");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"222");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
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
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        
        NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
        
        [self.service POST:@"bp/queryBpList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"333");
            if (self.page.pageNo == 1) {
                
                //由于下拉刷新时页面而归零
                [self.tableViewDelegate.dataArray removeAllObjects];
                [self.myTableView.footer resetNoMoreData];
            }
            [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
            [self.myTableView reloadData];
            
        } noResult:^{
            NSLog(@"222222222");
            [self.myTableView.footer noticeNoMoreData];
        }];
    }
    
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
    
    cell.titleLabel.text = [StringUtil toString:object[@"bpName"]];
    
    cell.separatorLine.backgroundColor = SEPARATORLINE;
    cell.viewCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"readNum"]]];
    cell.supportCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"likeNum"]]];
    cell.collectLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"collectNum"]]];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, object[@"bpLogo"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];
    
    //切圆角
    cell.iconImageView.layer.cornerRadius  = 39.5;
    cell.iconImageView.layer.masksToBounds = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.myDataArray[indexPath.row];
    ProjectBPDetailViewController *detailVC = [[ProjectBPDetailViewController alloc] init];
    //正向传值
    detailVC.bpId = [StringUtil toString:object[@"bpId"]];
    detailVC.isAppear = YES;//公共区域入口
    detailVC.isUpdateBP = NO;//不出现更新BP
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 第三栏代理传值
- (void)sendInfoWithSectionOne:(NSArray *)sectionOneArray SectionTwo:(NSArray *)sectionTwoArray SectionThree:(NSArray *)sectionThreeArray {
    
//    //项目阶段
//    [self.sIN_processStatusCodeArray addObjectsFromArray:sectionOneArray];
//    //项目领域
//    [self.sIN_bizCodeArray addObjectsFromArray:sectionTwoArray];
//    //融资阶段
//    [self.sIN_financeProcCodeArray addObjectsFromArray:sectionThreeArray];
//    
//    
//    self.sIN_processStatusCode = [self.sIN_processStatusCodeArray componentsJoinedByString:@","];
//    self.sIN_bizCode = [self.sIN_bizCodeArray componentsJoinedByString:@","];
//    self.sIN_financeProcCode = [self.sIN_financeProcCodeArray componentsJoinedByString:@","];
//    
//    [self fetchRankData];
//    //请求完成一次后删掉之前的数据
//    [self.sIN_processStatusCodeArray removeAllObjects];
//    [self.sIN_bizCodeArray removeAllObjects];
//    [self.sIN_financeProcCodeArray removeAllObjects];
}



- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 2;
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
    [self.myTableView reloadData];
    //    页码归零
    self.page.pageNo = 1;
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        self.orderBy = self.data1[indexPath.row][0];
    } else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
        self.area = self.data2[indexPath.row][0];
    } else{
        _currentData3Index = indexPath.row;
        self.typeCode = self.data3[indexPath.row][0];
    }
    /**刷新表格*/
    [self loadData];
    
}



//#pragma mark - 筛选栏
//- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
//    return 3;
//}
//
//-(BOOL)displayByCollectionViewInColumn:(NSInteger)column {
//    if (column == 0 || column == 1) {
//        return NO;
//    }
//    //第三个是CollectionView
//    else {
//        return YES;
//    }
//}
//
//-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
//    return NO;
//}
//
//-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
//    return 1;
//}
//
//-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
//    if (column == 0) {
//        return _currentData1Index;
//    }
//    if (column == 1) {
//        return _currentData2Index;
//    }
//    if (column == 2) {
//        return _currentData3Index;
//    }
//    return 0;
//}
//
//- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
//    if (column==0) {
//        return _data1.count;
//    } else if (column == 1){
//        return _data2.count;
//    } else if (column == 2){
//        
//    }
//    return 0;
//}
//
//- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
//    return self.dataTitle[column];
//}
//
//- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
//    if (indexPath.column == 0) {
//        return _data1[indexPath.row][1];
//    } else if (indexPath.column ==1 ) {
//        return _data2[indexPath.row][1];
//    } else {
//        
//    }
//    return nil;
//}
//
//- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
//    //    清空
//    [self.tableViewDelegate.dataArray removeAllObjects];
//    [self.myTableView reloadData];
//    //    页码归零
//    self.page.pageNo = 1;
//    if (indexPath.column == 0) {
//        _currentData1Index = indexPath.row;
//        self.orderBy = self.data1[indexPath.row][0];
//        [self loadData];
//    }
//    
//    else if(indexPath.column == 1){
//        
//        _currentData2Index = indexPath.row;
//        self.area = self.data2[indexPath.row][0];
//        [self loadData];
//    }
//    
//    else{
//        
//        //        _currentData3Index = indexPath.row;
//        //        self.bizCode = self.data3[indexPath.row][0];
//        //        [self fetchData];
//    }
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
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
