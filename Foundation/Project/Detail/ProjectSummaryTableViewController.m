//
//  ProjectSummaryViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectSummaryTableViewController.h"
#import "SingletonObject.h"
#import "LXGallery.h"
#import "CaptionButton.h"
#import "EvaluateTableViewCell.h"

@interface ProjectSummaryTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;//项目名称旁的图片
@property (weak, nonatomic) IBOutlet UILabel *procDetailsLabel;//项目描述
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名称
@property (weak, nonatomic) IBOutlet UILabel *procStatusNameLabel;//产品阶段
@property (weak, nonatomic) IBOutlet UILabel *bizNameLabel;//经营范围
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;//公司名称
@property (weak, nonatomic) IBOutlet UILabel *procUrlLabel;//项目网址
@property (weak, nonatomic) IBOutlet UILabel *procFuncLabel;//产品功能
//图集
@property (weak, nonatomic) IBOutlet UIView *pictureView;//产品展示
@property (nonatomic, strong) NSArray *urlArray;//装产品展示图片的数组
@property (nonatomic, strong) NSArray *commentArray;//装评析的数组

@property (strong, nonatomic) IBOutlet UIView *evaluateView;
@property (strong, nonatomic) IBOutlet UITableView *evaluateTableView;//产品评析
@property (weak, nonatomic) IBOutlet CaptionButton *evaluateBtn;

@end

@implementation ProjectSummaryTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"summary"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    
    /*******此处有一个问题，push进去后TabBar变黑*******/
    
    //self.tabBarController.tabBar.hidden = YES;
    
    
    self.navigationController.navigationBarHidden = NO;
    
    [self fetchData];
    
}

- (void)createUI {
    self.evaluateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self.commentArray count] * 60) style:UITableViewStylePlain];
    self.evaluateTableView.delegate   = self;
    self.evaluateTableView.dataSource = self;
    [self.evaluateView addSubview:self.evaluateTableView];
    
    //[self.evaluateTableView registerNib:[UINib nibWithNibName:@"EvaluateTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellName"];
}

//视图将要消失
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

//加载详情数据
- (void)fetchData {
    
    NSDictionary *param = @{
                            @"projectId":self.pid
                            };
    [self.service GET:@"/project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        self.thumbImageView.clipsToBounds = YES;
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,responseObject[@"headPictUrl"]];
        [self.thumbImageView setImageWithURL:[NSURL URLWithString:url]];
        self.thumbImageView.clipsToBounds = YES;
        self.procDetailsLabel.text = [StringUtil toString: responseObject[@"procDetails"]];
        self.projectNameLabel.text = [StringUtil toString: responseObject[@"projectName"]];
        self.procStatusNameLabel.text = [StringUtil toString: responseObject[@"procStatusName"]];
        self.bizNameLabel.text = [StringUtil toString: responseObject[@"bizName"]];
        self.companyLabel.text = [StringUtil toString: responseObject[@"company"]];
        self.procUrlLabel.text = [StringUtil toString: responseObject[@"procUrl"]];
        self.procFuncLabel.text = [StringUtil toString: responseObject[@"procDetails"]];
        //        图集
        self.urlArray = [[StringUtil toString:self.dataDict[@"procShows"]] componentsSeparatedByString:@","];
//        NSLog(@"%@~~~~~\n%@", self.urlArray, responseObject);
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.urlArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.urlArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [self.pictureView addSubview:gallery];
        [self.tableView reloadData];
        
//        [self loadData];
        
    } noResult:^{
        
    }];
}

- (void)loadData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{
                                                                    @"SEQ_projectId":self.pid
                                                                    }],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"evaluate/queryEvaluateDtoList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.commentArray = responseObject;
        NSLog(@"%@", self.commentArray);
        
        [self createUI];
        [self.evaluateTableView reloadData];
    } noResult:nil];
}

#pragma mark - tb delegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 7;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 6) {
//        EvaluateTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateTableViewCell" owner:nil options:nil] firstObject];
//        NSDictionary *dict = self.commentArray[indexPath.row];
//        cell.avatarImageView.clipsToBounds = YES;
//        cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
//        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
//        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
//        cell.realnameLabel.text = dict[@"realName"];
//        cell.userDescLabel.text = [StringUtil toString:dict[@"userDesc"]];
//        cell.pbtimeLabel.text = [DateUtil toShortDateCN:dict[@"pbDate"] time:dict[@"pbTime"]];
//        cell.contentLabel.text = [StringUtil toString:dict[@"content"]];
//        return cell;
//    }else {
//        return [[UITableViewCell alloc] init];
//    }
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        //        详情图片
        CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil(self.urlArray.count / 4.0);
        return 40 + height;
    }
//    if (indexPath.row == 6) {
//        return 200;
//    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
