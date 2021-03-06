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
#import "ShareUtil.h"

@interface SettingsTableViewController ()<UIAlertViewDelegate>

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-16.0, 0, 0, 0);
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
//        [alertView show];
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        AboutViewController *vc = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateViewControllerWithIdentifier:@"about"];
        vc.type = @"3";
        vc.naviTitle = @"关于团团创";
        [self.navigationController pushViewController:vc animated:YES];

    }else if(indexPath.section == 1 && indexPath.row == 1){
        ShareUtil *share = [ShareUtil getInstance];
        share.shareTitle = [NSString stringWithFormat:@"%@邀请您加入团团创",[User getInstance].realname];
        share.shareText = @"创业成就梦想，创新改变世界 || 更多精品，更好体验，尽在团团创APP";
        share.shareUrl = @"http://www.teamchuang.com/ttc_uploads/upload/Share/recommend.html";
        share.vc = self;
        [share shareWithUrl];
    }
    //点击退出登陆
    else if (indexPath.section == 3) {
        //如果是登陆状态
        if ([[User getInstance] isLogin]) {
        
            [[User getInstance] logout];
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];

        }else {
            [SVProgressHUD showSuccessWithStatus:@"亲,您还没有登陆哦!"];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

@end
