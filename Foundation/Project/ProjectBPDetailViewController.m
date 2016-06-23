//
//  ProjectBPDetailViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***BP详情***/

#import "ProjectBPDetailViewController.h"
#import "ProjectBPDetailDescCell.h"
#import "StringUtil.h"
#import "LXGallery.h"
#import "ProjectInfoTableViewController.h"
#import "ProjectDetailViewController.h"
#import "User.h"
#import "DTKDropdownMenuView.h"
#import "SingletonObject.h"
#import "ImageBrowserViewController.h"
#import "EYInputPopupView.h"
#import "ShareUtil.h"
#import "CreateBPViewController.h"
#import "ProjectBPDetailImageCell.h"

@interface ProjectBPDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
    NSArray *_myDataArray;
    NSDictionary *_dataDict;
}

@property (nonatomic, strong) NSArray *myDataArray;

@property (nonatomic, copy) NSString *projectStatus;//最新项目状态
@property (nonatomic, copy) NSString *srcStatus;//原项目状态
@property (nonatomic, assign) BOOL whetherUpdate;//能够更新项目

@property (nonatomic, copy) NSString *projectId;

@property (nonatomic, strong) UIButton *moreProjectBtn;//

@end

@implementation ProjectBPDetailViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建完项目信息后返回需要置空createProjectId单例
    [User getInstance].createProjectId = @"";
    
    //更新项目信息后一样置空
    [User getInstance].projectId = @"";
    
    //
    [User getInstance].srcId = @"";
    
    //加载数据后判断底部按钮状态
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//加载BP详情后进行判断
- (void)loadData {
   
    NSDictionary *dict = @{@"bpId": self.bpId};
    
    [self.service POST:@"bp/getBpDetailDto" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataDict = responseObject;

        //单例存储projectId bpId传到容器的子页面
        [User getInstance].projectId = _dataDict[@"projectId"];
         
        [User getInstance].bpId = _dataDict[@"bpId"];
        self.projectId = _dataDict[@"projectId"];
        
        NSLog(@"uuuuuuuuuuu存取老projectId\n pid:%@",_dataDict[@"projectId"]);
//        NSLog(@"ddddddddddd存取副本Id\n srcId:%@",_dataDict[@"srcId"]);
        
        //public:针对所有人可见  进入后只会显示原项目状态 srcStatus
        if (self.isAppear) {
            //没有projectId--->BP没有创建过项目
            if ([_dataDict[@"projectId"] isKindOfClass:[NSNull class]]) {
                self.statusTitle = @"暂无项目信息";
            }
            //有projectId--->创建过项目
            else {
                //srcStatus-原项目状态  0:未提交  1:待审核  2:已发布
                
                //项目已发布
                if ([[_dataDict[@"srcStatus"] stringValue] isEqualToString:@"2"]) {
                    self.statusTitle = @"查看关联项目";
                }else {
                    //项目未提交或未审核通过
                    self.statusTitle = @"暂无项目信息";
                }
            }
        }
        //private:只针对自己可见，是最新的记录，提审通过后进行修改是创建副本的必要条件，创建副本为了对自己展现最新记录，对外展示的还是老projectId
        else {
            //没有projectId--->BP没有创建过项目
            if ([_dataDict[@"projectId"] isKindOfClass:[NSNull class]]) {
                //BP状态
                if ([[_dataDict[@"bizStatus"] stringValue] isEqualToString:@"1"]) {
                    self.statusTitle = @"BP审核中";
                }
                else if ([[_dataDict[@"bizStatus"] stringValue] isEqualToString:@"2"]) {
                    self.statusTitle = @"创建项目";
                }
            }
            //有projectId--->BP创建过项目  srcStatus原项目状态--->0:未提交  1:待审核  2:已发布  projectStatus最新的项目状态(-1表示没有副本项目)
            else {
                //最新项目状态
                self.projectStatus = [_dataDict[@"projectStatus"] stringValue];
                //原项目状态
                self.srcStatus = [_dataDict[@"srcStatus"] stringValue];
                self.statusTitle = @"查看关联项目";
                
                //没有副本时，根据原项目状态判断能否更新项目
                if ([self.projectStatus isEqualToString:@"-1"]) {
                    //可以更新项目
                    if (![self.srcStatus isEqualToString:@"1"]) {
                        self.whetherUpdate = YES;
                    }
                    //待审核
                    else {
                        self.whetherUpdate = NO;
                    }
                }
                //有副本时,根据最新副本状态判断能否更新项目
                else {
                    //可以更新项目
                    if (![self.projectStatus isEqualToString:@"1"]) {
                        self.whetherUpdate = YES;
                    }
                    //待审核
                    else {
                        self.whetherUpdate = NO;
                    }
                }
            }
        }
        
        //装BP展示图片
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-52) style:UITableViewStylePlain];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailDescCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ProjectBPDetailImageCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
    
    //更多项目信息
    self.moreProjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreProjectBtn.frame = CGRectMake(12, SCREEN_HEIGHT-52, SCREEN_WIDTH-24, 40);
    [self.moreProjectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //创建项目
    if ([self.statusTitle isEqualToString:@"创建项目"]) {
        [self.moreProjectBtn addTarget:self action:@selector(createProjectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.moreProjectBtn setTitle:@"创建项目" forState:UIControlStateNormal];
        self.moreProjectBtn.backgroundColor = MAIN_COLOR;
        
        [self addRightItem];
    }
    //查看关联项目
    else if ([self.statusTitle isEqualToString:@"查看关联项目"]) {
        [self.moreProjectBtn addTarget:self action:@selector(checkRelatedProjectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.moreProjectBtn setTitle:@"查看关联项目" forState:UIControlStateNormal];
        self.moreProjectBtn.backgroundColor = MAIN_COLOR;
        
        
        if ([[_dataDict[@"bizStatus"] stringValue] isEqualToString:@"1"] && ![_dataDict[@"projectId"] isKindOfClass:[NSNull class]]) {
            self.navigationItem.rightBarButtonItem = nil;
        }else {
            [self addRightItem];
        }
        
    }
    //暂无项目信息
    else if ([self.statusTitle isEqualToString:@"暂无项目信息"]){
        [self.moreProjectBtn setTitle:@"暂无项目信息" forState:UIControlStateNormal];
        self.moreProjectBtn.backgroundColor = SeparatorColor;
        [self addRightItem];
    }
    
    //BP审核中
    else {
       [self.moreProjectBtn setTitle:@"BP审核中" forState:UIControlStateNormal];
        self.moreProjectBtn.backgroundColor = SeparatorColor;
    }
    
    [self.view addSubview:self.moreProjectBtn];
}

//创建项目
- (void)createProjectBtnClick {
    ProjectInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"ProjectInfoTableViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"projectInfo"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFlag = NO;//设为NO 通知项目信息 页面不做网络请求  勾选通过5个子页面完成请求后回调刷新勾选
    
    [self.navigationController pushViewController:vc animated:YES];
}

//查看关联项目
- (void)checkRelatedProjectBtnClick {
    //以private状态进入后点击下拉栏出现更新BP
    if (self.isUpdateBP) {
        ProjectDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.whetherUpdate = self.whetherUpdate;//是否能更新项目传到容器
        
        //sEQ_visible:public  用单例从容器传到子控制器中
        [User getInstance].sEQ_visible = @"private";
        vc.dataDict = _dataDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //public下隐藏更新BP
    else {
        ProjectDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
        vc.hidesBottomBarWhenPushed = YES;
        
        //sEQ_visible:public  用单例从容器传到子控制器中
        [User getInstance].sEQ_visible = @"public";
        vc.whetherUpdate = self.whetherUpdate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    
    //更新BP
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"更新BP" iconName:@"menu_edit@2x" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
          
            CreateBPViewController *vc = [[UIStoryboard storyboardWithName:@"CreateBPViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"createBP"];
            vc.title = @"更新BP";
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        
    }];
    
//    //投递BP
//    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"投递BP" iconName:@"menu_post" callBack:^(NSUInteger index, id info) {
//        if ([[User getInstance] isLogin]) {
//            
//            
//            
//            
//        }else{
//            
//            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
//        }
//        
//    }];
    
    
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"分享" iconName:@"menu_share" callBack:^(NSUInteger index, id info) {
        //        请求网络获取副标题摘要
        NSDictionary *param = @{
                                @"type":@"4"
                                };
        [self.service POST:@"standard/getStandard" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ShareUtil *share = [ShareUtil getInstance];
            share.shareTitle = [NSString stringWithFormat:@"%@",_dataDict[@"bpName"]];
            share.shareText = responseObject[@"content"];
            share.shareUrl = [NSString stringWithFormat:@"%@/%@",SHARE_BP_URL,_dataDict[@"bpId"]];
            share.vc = self;
            [share shareWithUrl];
        } noResult:nil];
    }];

    NSMutableArray *array = [NSMutableArray array];
    
    //公共区域进入不能更新BP 我的进入可以
    if (self.isUpdateBP) {
        [array addObject:item0];
    }
    
//    [array addObject:item1];
    [array addObject:item2];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:array icon:@"ic_menu"];
    menuView.cellColor = MENU_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
//    self.navigationItem.rightBarButtonItem = nil;  用来隐藏导航栏右侧下拉栏
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
        
        //切圆角
        cell.iconImageView.layer.cornerRadius = 35;
        cell.iconImageView.layer.masksToBounds = YES;
        
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

- (void)tap:(UITapGestureRecognizer *)tt {
    //点击点赞
    if (tt.view.tag == 999) {
        NSDictionary *dict = @{@"bpId":[User getInstance].bpId};
        
        [self.service POST:@"bp/likeBp" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"1111111");
            
        } noResult:^{
            
        }];
    }
    //点击收藏
    else {
        NSDictionary *dict = @{@"bpId":[User getInstance].bpId};
        
        [self.service POST:@"bp/collectBp" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"2222222");
            
        } noResult:^{
            
        }];
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
