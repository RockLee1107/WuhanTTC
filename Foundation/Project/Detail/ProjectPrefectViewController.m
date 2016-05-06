//
//  ProjectDetailViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectPrefectViewController.h"
#import "ProjectCreateTableViewController.h"
#import "TeamListTableViewController.h"
#import "ProcessTableViewController.h"
#import "FinanceTableViewController.h"
#import "ProductTableViewController.h"
#import "SingletonObject.h"
#import "DTKDropdownMenuView.h"
#import "HttpService.h"
#import "Global.h"
#import "LXButton.h"
#import "Masonry.h"

@interface ProjectPrefectViewController ()
@end

@implementation ProjectPrefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *containerView = [[UIView alloc] init];
//    包裹按钮的白底背景图层
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(60.0);
    }];
//    提交按钮
    LXButton *publishButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
    [publishButton setTitle:@"发布项目" forState:(UIControlStateNormal)];
//    绑定点击事件
    [publishButton addTarget:self action:@selector(publishButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [containerView addSubview:publishButton];
    [publishButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerView.mas_centerY);
        make.left.equalTo(containerView.mas_left).offset(20);
        make.right.equalTo(containerView.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [ProjectCreateTableViewController class],
                                           [TeamListTableViewController class],
                                           [ProductTableViewController class],
                                           [ProcessTableViewController class],
                                           [FinanceTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"详情",
                            @"团队",
                            @"产品",
                            @"进展",
                            @"融资"
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

- (IBAction)save:(UIBarButtonItem *)sender {
    
}

- (void)publishButtonPress:(UIButton *)sender {
    
//    ProjectCreateTableViewController *pvc = self.displayVC[@0];
    
}
@end
