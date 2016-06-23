//
//  ProjectBPDetailViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***BP详情***/

#import "ProjectBP_DetailViewController.h"
#import "ProjectBPDetailDescCell.h"
#import "ProjectBPDetailImageCell.h"
#import "StringUtil.h"
#import "LXGallery.h"
#import "ProjectInfoTableViewController.h"
#import "ProjectDetailViewController.h"
#import "User.h"

@interface ProjectBP_DetailViewController()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
    NSArray *_myDataArray;
    NSDictionary *_dataDict;
}

@property (nonatomic, strong) NSArray *myDataArray;

@end

@implementation ProjectBP_DetailViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)loadData {
    
    NSDictionary *dict = @{@"bpId":[User getInstance].bpId};
    
    [self.service POST:@"bp/getBpDetailDto" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataDict = responseObject;
        
        _myDataArray = [_dataDict[@"bpPictUrl"] componentsSeparatedByString:@","];
        
        if (self.page.pageNo == 1) {
            
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [_myTableView.footer resetNoMoreData];
        }
        
        [_myTableView reloadData];
        [self createUI];
        
    } noResult:^{
        NSLog(@"222222222");
        [_myTableView.footer noticeNoMoreData];
    }];
}

- (void)createUI {
    
    self.title = @"BP详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailDescCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailImageCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
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
        
        
        cell.titleLabel.text = _dataDict[@"bpName"];
        cell.descLabel.text  = _dataDict[@"bpDesc"];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@ · %@", _dataDict[@"financeProcName"], _dataDict[@"bizName"]];
        cell.areaLabel.text  = _dataDict[@"area"];
        
        cell.viewCountLabel.text = [_dataDict[@"readNum"] stringValue];
        cell.supportLabel.text   = [_dataDict[@"likeNum"] stringValue];
        cell.supportLabel.tag    = 1001;
        cell.collectLabel.text   = [_dataDict[@"collectNum"] stringValue];
        cell.collectLabel.tag    = 1002;
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, _dataDict[@"bpLogo"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];
        
        //添加点赞手势
        cell.supportImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
        tap1.numberOfTapsRequired = 1;
        tap1.numberOfTouchesRequired = 1;
        [cell.supportImageView addGestureRecognizer:tap1];
        
        
        //添加收藏手势
        cell.collectImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        [cell.collectImageView addGestureRecognizer:tap2];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        ProjectBPDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(_myDataArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = _myDataArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [cell.iconImageView addSubview:gallery];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160;
    }else {
        return ceil(_myDataArray.count / 4.0 + 1) * IMAGE_WIDTH_WITH_PADDING;
    }
}

//点赞
- (void)tap1 {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //需要传给服务器的参数
    NSDictionary *dict = @{@"bpId":[User getInstance].bpId};
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@/bp/likeBp", HOST_URL];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dict[@"success"] stringValue] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"已点赞"];
            UILabel *supportLabel = (UILabel *)[self.view viewWithTag:1001];
            //点赞后及时更新数据
            NSString *supportNum = supportLabel.text;
            int num = [supportNum intValue] + 1;
            supportLabel.text = [NSString stringWithFormat:@"%d", num];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"取消点赞"];
            UILabel *supportLabel = (UILabel *)[self.view viewWithTag:1001];
            //点赞后及时更新数据
            NSString *supportNum = supportLabel.text;
            int num = [supportNum intValue] - 1;
            supportLabel.text = [NSString stringWithFormat:@"%d", num];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"========\n%@", error);
    }];
}

//收藏
- (void)tap2 {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //需要传给服务器的参数
    NSDictionary *dict = @{@"bpId":[User getInstance].bpId};
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@/bp/collectBp", HOST_URL];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dict[@"success"] stringValue] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"已收藏"];
            UILabel *collectLabel = (UILabel *)[self.view viewWithTag:1002];
            //点赞后及时更新数据
            NSString *collectNum = collectLabel.text;
            int num = [collectNum intValue] + 1;
            collectLabel.text = [NSString stringWithFormat:@"%d", num];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            UILabel *collectLabel = (UILabel *)[self.view viewWithTag:1002];
            //点赞后及时更新数据
            NSString *collectNum = collectLabel.text;
            int num = [collectNum intValue] - 1;
            collectLabel.text = [NSString stringWithFormat:@"%d", num];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"========\n%@", error);
    }];
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
