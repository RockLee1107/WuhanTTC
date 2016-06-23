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
#import "User.h"

@interface ProjectSummaryTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;//项目名称旁的图片
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

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



@end

@implementation ProjectSummaryTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"summary"];
    return self;
}

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//加载详情数据
- (void)fetchData {
    
    NSDictionary *dict = @{
                            @"sEQ_projectId":[User getInstance].projectId,
                            @"sEQ_visible":[User getInstance].sEQ_visible
                            };
    
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    
    [self.service POST:@"project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //没有副本Id，srcId为空，用单例存srcId复制一份projectId 用来传后四项
        if ([responseObject[@"srcId"] isKindOfClass:[NSNull class]]) {
            [User getInstance].srcId = responseObject[@"projectId"];
        }
        //有副本Id,srcId仍为老Id
        else {
            [User getInstance].srcId = responseObject[@"srcId"];
        }
        /*************************项目详情根据传入的参数会返回老projectId或者副本id*****************************/
        [User getInstance].projectId = responseObject[@"projectId"];
        [User getInstance].bpId = responseObject[@"bpId"];
        
        self.dataDict = responseObject;
        self.thumbImageView.clipsToBounds = YES;
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,responseObject[@"headPictUrl"]];
        [self.thumbImageView setImageWithURL:[NSURL URLWithString:url]];
        self.thumbImageView.layer.cornerRadius = 35;
        self.thumbImageView.layer.masksToBounds = YES;
        self.procDetailsLabel.text = [StringUtil toString: responseObject[@"projectDesc"]];
        self.descLabel.text = [StringUtil toString: responseObject[@"projectResume"]];
        self.projectNameLabel.text = [StringUtil toString: responseObject[@"projectName"]];
        self.procStatusNameLabel.text = [StringUtil toString: responseObject[@"procStatusName"]];
        self.bizNameLabel.text = [StringUtil toString: responseObject[@"bizName"]];
        self.companyLabel.text = [StringUtil toString: responseObject[@"company"]];
        self.procUrlLabel.text = [StringUtil toString: responseObject[@"procUrl"]];
        self.procFuncLabel.text = [StringUtil toString: responseObject[@"procDetails"]];
        //        图集
        self.urlArray = [[StringUtil toString:self.dataDict[@"procShows"]] componentsSeparatedByString:@","];
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.urlArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.urlArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [self.pictureView addSubview:gallery];
        [self.tableView reloadData];
    } noResult:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        //        详情图片
        CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil(self.urlArray.count / 4.0);
        return 40 + height;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
