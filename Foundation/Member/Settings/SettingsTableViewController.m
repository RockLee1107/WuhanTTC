//
//  SettingsTableViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/30.
//
//

#import "SettingsTableViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-16.0, 0, 0, 0);
    // Do any additional setup after loading the view.
}

///活动规范
- (IBAction)aboutButtonPress:(id)sender {
    AboutViewController *vc = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateViewControllerWithIdentifier:@"about"];
    vc.type = @"3";
    vc.naviTitle = @"关于团团创";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        AboutViewController *vc = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateViewControllerWithIdentifier:@"about"];
        vc.type = @"3";
        vc.naviTitle = @"关于团团创";
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (indexPath.section == 3) {
        [[User getInstance] logout];
        [[PXAlertView showAlertWithTitle:@"退出成功" message:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
//            [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
        }] useDefaultIOS7Style];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
