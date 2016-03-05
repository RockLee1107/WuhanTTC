//
//  SearchSpBookListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SearchSpBookListViewController.h"
#import "StringUtil.h"
#import "BookSearcher.h"

@interface SearchSpBookListViewController ()

@end

@implementation SearchSpBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    // Do any additional setup after loading the view.
}

-(void)fetchData {
    HttpService *service = [HttpService getInstance];
    BookSearcher *searcher = [[BookSearcher alloc] init];
#warning 硬编码spcode
    searcher.specialCode = @"zl0001";
    NSDictionary *dict = [searcher dictionary];
    NSString *jsonStr = [StringUtil dictToJson:dict];
#warning hard coding
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[NSString stringWithFormat:@"{\"pageNo\":\"%@\",\"pageSize\":\"10\"}",@"1"]};
    NSLog(@"json:%@",param);
    [service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
    }];
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
