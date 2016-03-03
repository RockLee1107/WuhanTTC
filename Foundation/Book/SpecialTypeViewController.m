//
//  SpecialTypeViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SpecialTypeViewController.h"
#import "SearchSpBookListViewController.h"

@interface SpecialTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpecialTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)fetchData {
    HttpService *service = [HttpService getInstance];
    NSDictionary *param = @{@"QueryParams":@"{\"SEQ_userId\":\"1\"}"};
    [service POST:@"book/special/querySpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res:%@",responseObject);
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
