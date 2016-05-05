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

@interface ProjectSummaryTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *procDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *procStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *procUrlLabel;
@property (weak, nonatomic) IBOutlet UILabel *procFuncLabel;
//图集
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (nonatomic,strong) NSArray *urlArray;
@end

@implementation ProjectSummaryTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"summary"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
