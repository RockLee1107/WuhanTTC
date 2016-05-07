//
//  ProjectDetailViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectDetailViewController.h"
#import "ProjectSummaryTableViewController.h"
#import "TeamListTableViewController.h"
#import "ProcessTableViewController.h"
#import "FinanceTableViewController.h"
#import "EvaluateTableViewController.h"
#import "SingletonObject.h"
#import "DTKDropdownMenuView.h"
#import "HttpService.h"
#import "Global.h"
#import "ProjectPrefectViewController.h"
#import "ImageBrowserViewController.h"
#import "EYInputPopupView.h"

@interface ProjectDetailViewController ()
@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    [SingletonObject getInstance].dataDict = self.dataDict;
    [SingletonObject getInstance].isBrowse = YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [ProjectSummaryTableViewController class],
                                           [TeamListTableViewController class],
                                           [ProcessTableViewController class],
                                           [FinanceTableViewController class],
                                           [EvaluateTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"详情",
                            @"团队",
                            @"进展",
                            @"融资",
                            @"评析"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"pid",
                      @"pid",
                      @"pid",
                      @"pid",
                      @"pid"
                      ];
        self.values = @[
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid
                        ];
    }
    return self;
}
///导航栏下拉菜单
- (void)addRightItem
{
//    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"关注" iconName:@"menu_attention" callBack:^(NSUInteger index, id info) {
        //        //        访问网络
        NSDictionary *param = @{
                                @"Attention":[StringUtil dictToJson:@{
                                                                        @"projectId":[SingletonObject getInstance].pid,
                                                                        @"userId":[User getInstance].uid,
                                                                        @"isAttention":@1
                                                                        }]
                                };
        [[HttpService getInstance] GET:@"/project/projectAttention" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        } noResult:nil];
    }];
//    除审核中以外
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"更新项目" iconName:@"menu_edit" callBack:^(NSUInteger index, id info) {
        ProjectPrefectViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"prefect"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
//    成员或投资人身份
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"项目BP" iconName:@"menu_bp" callBack:^(NSUInteger index, id info) {
        if (self.dataDict[@"bppictUrl"] == [NSNull null]) {
            [SVProgressHUD showErrorWithStatus:@"暂无项目BP"];
        } else {
            ImageBrowserViewController *vc = [[ImageBrowserViewController alloc] init];
            vc.imageArray = [self.dataDict[@"bppictUrl"] componentsSeparatedByString:@","];
            vc.selectedIndex = 0;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }];
//    成员或投资人身份
    DTKDropdownItem *item3 = [DTKDropdownItem itemWithTitle:@"评析" iconName:@"menu_add_comment" callBack:^(NSUInteger index, id info) {
        [EYInputPopupView popViewWithTitle:@"添加评析" contentText:@"请填写评析内容(1-200字)"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:1 and:200]) {
                                       [SVProgressHUD showErrorWithStatus:@"请举报评析内容(1-200字)"];
                                       return ;
                                   }
                                   NSDictionary *param = @{
                                                           @"Evaluate":[StringUtil dictToJson:@{
                                                                                                  @"projectId":[SingletonObject getInstance].pid,
                                                                                                  @"content":text,
                                                                                                  @"userId":[User getInstance].uid,
                                                                                                  @"duty":[User getInstance].duty
                                                                                                  }]
                                                           };
                                   [[HttpService getInstance] POST:@"evaluate/saveEvaluate" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }
         ];
        
    }];
    NSMutableArray *array = [NSMutableArray array];
    //        成员或投资人
    if ([[self.dataDict[@"parterIds"] componentsSeparatedByString:@","] containsObject:[User getInstance].uid] || [[User getInstance].isInvestor boolValue]) {
        [array addObject:item2];
        [array addObject:item3];
    }
//    是创建人
    if ([[User getInstance].uid isEqualToString:self.dataDict[@"createdById"]]) {
//        非审核中
        if ([self.dataDict[@"bizStatus"] integerValue] != BizStatusPublish) {
            [array addObject:item1];
        }
    } else {
        [array addObject:item0];
    }
    
    
//    [array addObject:item1];
//    [array addObject:item2];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:array icon:@"ic_menu"];
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
@end
