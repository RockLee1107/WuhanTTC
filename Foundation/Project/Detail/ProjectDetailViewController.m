//
//  ProjectDetailViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectDetailViewController.h"
#import "ProjectSummaryViewController.h"

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
                                           [ProjectSummaryViewController class],
                                           [ProjectSummaryViewController class],
                                           [ProjectSummaryViewController class],
                                           [ProjectSummaryViewController class],
                                           [ProjectSummaryViewController class]
                                           ];
        NSArray *titles = @[
                            @"详情",
                            @"团队",
                            @"进展",
                            @"融资",
                            @"评析"];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
//        self.keys = @[@"orderStatus",@"orderStatus",@"orderStatus",@"orderStatus"];
//        //        状态2 OrderStatusShouldAccept待接单暂时不需要
//        self.values = @[
//                        [NSNumber numberWithInt:OrderStatusShouldPay],
//                        [NSNumber numberWithInt:OrderStatusShouldSend],
//                        [NSNumber numberWithInt:OrderStatusShouldFinish],
//                        [NSNumber numberWithInt:OrderStatusFinished]
//                        ];
    }
    return self;
}


@end
