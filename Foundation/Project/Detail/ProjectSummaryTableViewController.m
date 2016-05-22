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

@interface ProjectSummaryTableViewController ()
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
@property (nonatomic,strong) NSArray *urlArray;

@property (weak, nonatomic) IBOutlet UITableView *evaluateTableView;//产品评析
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

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
        LXGallery *gallery = [[LXGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, ceil(self.urlArray.count / 4.0) * IMAGE_WIDTH_WITH_PADDING)];
        gallery.urlArray = self.urlArray;
        gallery.vc = self;
        [gallery reloadImagesList];
        [self.pictureView addSubview:gallery];
        [self.tableView reloadData];
    } noResult:^{
        
    }];
}

#pragma mark - tb delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        //        详情图片
        CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil(self.urlArray.count / 4.0);
        return 40 + height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
