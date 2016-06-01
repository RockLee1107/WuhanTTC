//
//  SearchSpBookListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

//创成长->内容

#import "SearchSpBookListViewController.h"
#import "BookSearcher.h"
#import "BookDetailViewController.h"
#import "SubTabBarController.h"
#import "BookListDelegate.h"
#import "DTKDropdownMenuView.h"
#import "StatusDict.h"
#import "ContributeTableViewController.h"
#import "BookSearchViewController.h"

@interface SearchSpBookListViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *nameNavigationItem;
//搜索条件
@property (nonatomic,strong) NSArray *dataTitle;//顺序，分类，格式
@property (nonatomic,strong) NSArray *data1;//顺序数据源
@property (nonatomic,strong) NSArray *data2;//分类数据源
@property (nonatomic,strong) NSArray *data3;//格式数据源
@property (nonatomic,assign) NSInteger currentData1Index;
@property (nonatomic,assign) NSInteger currentData2Index;
@property (nonatomic,assign) NSInteger currentData3Index;
//条件值
@property (nonatomic,strong) NSString *orderBy;//顺序
@property (nonatomic,strong) NSString *categoryCode;//全部
@property (nonatomic,strong) NSString *bookType;//格式
@end

@implementation SearchSpBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameNavigationItem.title = ((SubTabBarController *)self.tabBarController).specialName;
    [self initDelegate];
    [self initRefreshControl];
    [self initSearchConditionView];
    [self addRightItem];
    [self performSelector:@selector(hideNaviBar) withObject:nil afterDelay:0.025];
    self.categoryCode = @"all";
    self.bookType = @"all";
    self.orderBy = @"pbDate";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//回到主页
- (IBAction)goBack:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)hideNaviBar {
    //    隐藏父级导航栏
    self.tabBarController.navigationController.navigationBarHidden = YES;
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
    self.tableViewDelegate = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/*********???????**********/

-(void)fetchData {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"SEQ_specialCode":((SubTabBarController *)self.tabBarController).specialCode                                                                                  }];
//    游客判断
    if ([[User getInstance] isLogin]) {
        [query setObject:[User getInstance].uid forKey:@"SEQ_userId"];
        //管理员判断
        [query setObject:[[User getInstance].isAdmin stringValue] forKey:@"SEQ_isAdmin"];
    }
    //    条件1
    if (self.orderBy != nil) {
        [query setObject:self.orderBy forKey:@"SEQ_orderBy"];
        
    }
    //    条件2
    if (![self.categoryCode isEqualToString:@"all"]) {
        [query setObject:self.categoryCode forKey:@"SEQ_categoryCode"];
        
    }
    //    条件3
    if (![self.bookType isEqualToString:@"all"]) {
        [query setObject:self.bookType forKey:@"SEQ_bookType"];
        
    }
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:query],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};;
    
    [self.service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject[@"result"]];
        [self.tableView reloadData];
        if ([responseObject[@"result"] count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"推荐好文" iconName:@"menu_contribute" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            ContributeTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"contribute"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0] icon:@"ic_menu" extraIcon:@"app_search" extraButtunCallBack:^{
        //跳转搜索页
        BookSearchViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"find"];
        vc.specialCode = ((SubTabBarController *)self.tabBarController).specialCode;
        [self.navigationController pushViewController:vc animated:YES];
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
    self.dataTitle = @[@"顺序",@"分类",@"格式"];
    self.data1 = @[
                   @[@"pbDate",@"顺序"],
                   @[@"readNum",@"按阅读量"],
                   @[@"commNum",@"按评论数量"],
                   @[@"collNum",@"按收藏数"]
                   ];
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@[@"all",@"全部"]];
    NSArray *array = [StatusDict bookCategoryBySpecialCode:((SubTabBarController *)self.tabBarController).specialCode];
    for (NSDictionary *dict in array) {
        [names addObject:@[dict[@"categoryCode"],dict[@"categoryName"]]];
    }
    
    self.data2 = names;
    self.data3 = @[
                   @[@"all",@"全部"],
                   @[@"DOC",@"图文"],
                   @[@"PPT",@"PPT"],
                   @[@"VIDEO",@"视频"]
                   ];
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
    } else if (indexPath.column == 1 ) {
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
        /**刷新表格*/
        [self fetchData];
    } else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
        self.categoryCode = self.data2[indexPath.row][0];
        [self fetchData];
    } else{
        _currentData3Index = indexPath.row;
        self.bookType = self.data3[indexPath.row][0];
        [self fetchData];
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
