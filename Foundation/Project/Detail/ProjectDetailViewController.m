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
#import "SingletonObject.h"

@interface ProjectDetailViewController ()

@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [ProjectSummaryTableViewController class],
                                           [TeamListTableViewController class],
                                           [ProjectSummaryTableViewController class],
                                           [ProjectSummaryTableViewController class],
                                           [ProjectSummaryTableViewController class]
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

@end
