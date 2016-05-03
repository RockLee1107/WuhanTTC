//
//  MainTabBarController.m
//  
//
//  Created by HuangXiuJie on 16/2/26.
//
//

#import "MainTabBarController.h"
#import "User.h"
#import "HttpService.h"

@interface MainTabBarController ()
@property (strong,nonatomic) UINavigationController *bookNVC;
@property (strong,nonatomic) UINavigationController *activityNVC;
@property (strong,nonatomic) UINavigationController *projectNVC;
@property (strong,nonatomic) UINavigationController *memberNVC;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *blankVC = [[UIViewController alloc] init];
    blankVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *blankNVC = [[UINavigationController alloc] initWithRootViewController:blankVC];
    self.bookNVC     = blankNVC;
    self.activityNVC = blankNVC;
    self.projectNVC  = blankNVC;
    self.memberNVC   = blankNVC;
    
    

    self.viewControllers = @[self.bookNVC,self.projectNVC,self.activityNVC,self.memberNVC];

    if ([[User getInstance] isLogin]) {
        NSString *username = [User getInstance].username;
        NSString *password = [User getInstance].password;
        NSDictionary *param = @{@"username":username,
                                @"password":password};
        [[HttpService getInstance] POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self setup];
            User *user = [User getInstance];
            if (responseObject[@"userInfo"][@"realName"] != [NSNull null] && responseObject[@"userInfo"][@"realName"] != nil && ![responseObject[@"userInfo"][@"realName"] isEqualToString:@""]) {
                user.realname = responseObject[@"userInfo"][@"realName"];
            }
            if (responseObject[@"userInfo"][@"company"] != [NSNull null] && responseObject[@"userInfo"][@"company"] != nil && ![responseObject[@"userInfo"][@"company"] isEqualToString:@""]) {
                user.company = responseObject[@"userInfo"][@"company"];
            }
            if (responseObject[@"userInfo"][@"duty"] != [NSNull null] && responseObject[@"userInfo"][@"duty"] != nil && ![responseObject[@"userInfo"][@"duty"] isEqualToString:@""]) {
                user.duty = responseObject[@"userInfo"][@"duty"];
            }
            if (responseObject[@"userInfo"][@"email"] != [NSNull null] && responseObject[@"userInfo"][@"email"] != nil && ![responseObject[@"userInfo"][@"email"] isEqualToString:@""]) {
                user.email = responseObject[@"userInfo"][@"email"];
            }
            if (responseObject[@"userInfo"][@"weChat"] != [NSNull null] && responseObject[@"userInfo"][@"weChat"] != nil && ![responseObject[@"userInfo"][@"weChat"] isEqualToString:@""]) {
                user.wechat = responseObject[@"userInfo"][@"weChat"];
            }
            //是否APP管理员，文献列表选择用此传值
            [User getInstance].isAdmin = responseObject[@"userInfo"][@"isAdmin"];
            //是否社区管理员，文献列表选择用此传值
            [User getInstance].isBm = responseObject[@"userInfo"][@"isBm"];
        } noResult:nil];
    } else {
        //    同样发一下游客登录接口
        [[HttpService getInstance] POST:@"visitorLogin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self setup];
        } noResult:nil];
    }

}

- (void)setup {
    self.bookNVC     = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateInitialViewController];
    self.activityNVC = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateInitialViewController];
    self.projectNVC  = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateInitialViewController];
    self.memberNVC   = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateInitialViewController];
    self.bookNVC.tabBarItem.selectedImage        = [UIImage imageNamed:@"icon_book_selected"];
    self.activityNVC.tabBarItem.selectedImage    = [UIImage imageNamed:@"icon_activity_selected"];
    self.projectNVC.tabBarItem.selectedImage     = [UIImage imageNamed:@"icon_project_selected"];
    self.memberNVC.tabBarItem.selectedImage      = [UIImage imageNamed:@"icon_member_selected"];
    self.viewControllers = @[self.bookNVC,self.projectNVC,self.activityNVC,self.memberNVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
