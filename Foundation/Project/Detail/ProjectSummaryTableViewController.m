//
//  ProjectSummaryViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectSummaryTableViewController.h"
#import "SingletonObject.h"

@interface ProjectSummaryTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *procDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *procStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *procUrlLabel;
@property (weak, nonatomic) IBOutlet UILabel *procFuncLabel;

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
    self.procDetailsLabel.text = @"xxx";
    NSDictionary *param = @{
                            @"projectId":self.pid
                            };
    [self.service GET:@"/project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.thumbImageView.clipsToBounds = YES;
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,responseObject[@"bppictUrl"]];
        [self.thumbImageView setImageWithURL:[NSURL URLWithString:url]];
        self.procDetailsLabel.text = responseObject[@"procDetails"];
        self.projectNameLabel.text = [StringUtil toString: responseObject[@"projectName"]];
        self.procStatusNameLabel.text = [StringUtil toString: responseObject[@"procStatusName"]];
        self.bizNameLabel.text = [StringUtil toString: responseObject[@"bizName"]];
        self.companyLabel.text = [StringUtil toString: responseObject[@"company"]];
        self.procUrlLabel.text = [StringUtil toString: responseObject[@"procUrl"]];
        self.procFuncLabel.text = [StringUtil toString: responseObject[@"procDetails"]];
    }];
}
@end
