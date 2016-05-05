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

@interface ProjectPrefectViewController ()
@end

@implementation ProjectPrefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
