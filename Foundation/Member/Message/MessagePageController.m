//
//  MessagePageController.m
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/*******消息页面******/


#import "MessagePageController.h"
#import "MessageTableViewController.h"
#import "MailViewController.h"

@interface MessagePageController ()

@end

@implementation MessagePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:(UIBarButtonItemStyleBordered) target:self action:@selector(clear:)];
}

///全部已读
- (void)clear:(UIBarButtonItem *)item {
//    UITableViewController *vc = (UITableViewController *)self.currentViewController;
//    vc.editing = !vc.editing;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                   @"userId":[User getInstance].uid,
                                                   @"status":@"1",
                                                   }];
    //如果点击的是系统通知页面的 全部已读
    if ([self.currentViewController isKindOfClass:[MessageTableViewController class]]) {
        [param setObject:@"0" forKey:@"type"];
        [[HttpService getInstance] POST:@"personal/msg/changeAllMsgStatus" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [((MessageTableViewController *)self.currentViewController) fetchData];
        } noResult:nil];
    }
    //进入收信的全部已读
    else{
        [param setObject:@"1" forKey:@"type"];
        [[HttpService getInstance] POST:@"personal/msg/changeAllMsgStatus" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [((MailViewController *)self.currentViewController) fetchData];
        } noResult:nil];
    }
    
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MessageTableViewController class],
                                           [MailViewController class],
                                           [MailViewController class]
                                           ];
        NSArray *titles = @[
                            @"系统通知",
                            @"收信",
                            @"发信"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"SEQ_type",
                      @"userType",
                      @"userType"
                      ];
        self.values = @[
                        @"('99','0')",
//                        由于收信是toUserId，所以人为地将它的SEQ_type定为-1，在子页中硬编码判断
                        @"SEQ_toUserId",
                        @"SEQ_userId"
                        ];
    }
    return self;
}

@end
