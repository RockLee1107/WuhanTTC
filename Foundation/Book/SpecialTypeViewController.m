//
//  SpecialTypeViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SpecialTypeViewController.h"
#import "SearchSpBookListViewController.h"
#import "StringUtil.h"
#import "User.h"

@interface SpecialTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpecialTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}

-(void)fetchData {
    HttpService *service = [HttpService getInstance];
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{@"SEQ_userId":[User getInstance].uid}]};
    [service GET:@"book/special/querySpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPress:(id)sender {
    SearchSpBookListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialTypeTableViewCell" owner:nil options:nil] firstObject];
    return cell;
}

@end
