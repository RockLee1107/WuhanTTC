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
@property (weak, nonatomic) IBOutlet UILabel *procDetailsLabel;

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
        self.procDetailsLabel.text = responseObject[@"procDetails"];
    }];
}
@end
