//
//  BookDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/4.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookDetailViewController.h"
#import "DTKDropdownMenuView.h"
#import "ShareUtil.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *dataDict;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    HttpService *service = [HttpService getInstance];
    NSDictionary *param = @{@"bookId":self.bookId};
    [service POST:@"book/getBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        NSString *cssStr = @"<style>img{width:100%;}</style>";
        NSString *contentStr = [NSString stringWithFormat:@"%@%@",cssStr,responseObject[@"content"]];
//        NSLog(@"%@",contentStr);
        [self.webView loadHTMLString:contentStr baseURL:nil];
    } noResult:^{
        
    }];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.199.123/string.html"]]];
}

///导航栏下拉菜单
- (void)addRightItem
{
//    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"查看热评" iconName:@"menu_comment" callBack:^(NSUInteger index, id info) {
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"写评论" iconName:@"menu_add_comment" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"收藏" iconName:@"menu_collect" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item3 = [DTKDropdownItem itemWithTitle:@"分享" iconName:@"menu_share" callBack:^(NSUInteger index, id info) {
//        [SVProgressHUD showSuccessWithStatus:@"^_^"];
        ShareUtil *share = [ShareUtil getInstance];
        share.shareText = self.dataDict[@"title"];
        share.shareUrl = [NSString stringWithFormat:@"%@/%@/%@.html",SHARE_URL,self.dataDict[@"specialCode"],self.dataDict[@"bookId"]];
        share.vc = self;
        [share shareWithUrl];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1,item2,item3] icon:@"ic_menu"];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

@end
