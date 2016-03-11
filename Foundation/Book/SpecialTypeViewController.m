//
//  SpecialTypeViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SpecialTypeViewController.h"
#import "SubTabBarController.h"
#import "StringUtil.h"
#import "DateUtil.h"
#import "User.h"
#import "SpecialTypeTableViewCell.h"

@interface SpecialTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpecialTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchData];
}

-(void)fetchData {
    HttpService *service = [HttpService getInstance];
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{@"SEQ_userId":[User getInstance].uid}]};
    [service GET:@"book/special/querySpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
//        NSLog(@"%@",responseObject);
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTypeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialTypeTableViewCell" owner:nil options:nil] firstObject];
    cell.specialNameLabel.text = self.dataArray[indexPath.row][@"specialName"];
    cell.latestBookNameLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"latestBookName"]];
    
    cell.latestUpdateTimeLabel.text = [DateUtil toString:self.dataArray[indexPath.row][@"latestUpdateTime"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sub"];
    vc.specialCode = self.dataArray[indexPath.row][@"specialCode"];
    vc.specialName = self.dataArray[indexPath.row][@"specialName"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
