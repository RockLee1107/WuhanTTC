//
//  MessageWebViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/1.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MessageWebViewController.h"

@interface MessageWebViewController ()

@end

@implementation MessageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:webView];
    
    NSURL *url =[NSURL URLWithString:self.urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
