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
//    NSString *html = @"";
//    [self.webView loadHTMLString:html baseURL:nil];
//    [[HttpService getInstance] POST:@"http://localhost/string.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseObject[@"str"]]]];
//    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.199.123/string.html"]]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
