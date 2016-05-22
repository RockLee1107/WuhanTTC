//
//  ProjectBPDetailViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectBPDetailViewController.h"
#import "ProjectBPDetailDescCell.h"
#import "ProjectBPDetailImageCell.h"
#import "StringUtil.h"

@interface ProjectBPDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
}

@property (nonatomic, strong) NSArray *myDataArray;

@end

@implementation ProjectBPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    
    
    self.title = @"项目信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailDescCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailImageCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
    
    self.myDataArray = [[StringUtil toString:self.dataDic[@"bppictUrl"]] componentsSeparatedByString:@","];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.myDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ProjectBPDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        
        return cell;
    }else {
        ProjectBPDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.myDataArray[indexPath.row]]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else {
        return [self.myDataArray count] * 70;
    }
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
