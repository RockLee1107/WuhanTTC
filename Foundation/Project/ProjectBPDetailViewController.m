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
#import "LXGallery.h"

@interface ProjectBPDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
}

@property (nonatomic, strong) NSArray *myDataArray;

@end

@implementation ProjectBPDetailViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

//视图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    
    self.title = @"项目信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-64) style:UITableViewStylePlain];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailDescCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailImageCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
    
    self.myDataArray = [[StringUtil toString:self.dataDic[@"bppictUrl"]] componentsSeparatedByString:@","];
//    NSLog(@"%@~~~~~\n", self.dataDic);
    
    //更多项目信息
    UIButton *moreProjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreProjectBtn.frame = CGRectMake(12, SCREEN_HEIGHT-52, SCREEN_WIDTH-24, 40);
    moreProjectBtn.backgroundColor = MAIN_COLOR;
    [moreProjectBtn setTitle:@"更多项目信息" forState:UIControlStateNormal];
    [moreProjectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreProjectBtn addTarget:self action:@selector(moreProjectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreProjectBtn];
    
}

- (void)moreProjectBtnClick {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ProjectBPDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,self.dataDic[@"headPictUrl"]]]];
        cell.titleLabel.text = self.dataDic[@"projectName"];
        cell.descLabel.text  = self.dataDic[@"projectResume"];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@ %@", self.dataDic[@"procStatusName"], self.dataDic[@"bizName"]];
        return cell;
    }else {
        ProjectBPDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.myDataArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.myDataArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [cell.iconImageView addSubview:gallery];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else {
        return ceil(self.myDataArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING;
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
