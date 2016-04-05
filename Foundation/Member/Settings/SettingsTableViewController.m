//
//  SettingsTableViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/30.
//
//

#import "SettingsTableViewController.h"
#import "LoginViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-16.0, 0, 0, 0);
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 3) {
        [[User getInstance] logout];
        [[PXAlertView showAlertWithTitle:@"退出成功" message:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
        }] useDefaultIOS7Style];
    }
}

@end
