//
//  BookDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/4.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HttpService *service = [HttpService getInstance];
    NSDictionary *param = @{@"bookId":self.bookId};
    [service POST:@"book/getBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *cssStr = @"<style>img{width:100%;}</style>";
        NSString *contentStr = [NSString stringWithFormat:@"%@%@",cssStr,responseObject[@"content"]];
        NSLog(@"%@",contentStr);
        [self.webView loadHTMLString:contentStr baseURL:nil];
    } noResult:^{
        
    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.199.123/string.html"]]];
}

@end
