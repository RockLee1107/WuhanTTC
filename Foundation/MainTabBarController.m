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
#import "LoginViewController.h"
#import "MobClick.h"

@interface MainTabBarController ()
@property (strong,nonatomic) UINavigationController *bookNVC;
@property (strong,nonatomic) UINavigationController *activityNVC;
@property (strong,nonatomic) UINavigationController *projectNVC;
@property (strong,nonatomic) UINavigationController *memberNVC;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    UIViewController *blankVC = [[UIViewController alloc] init];
    blankVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *blankNVC = [[UINavigationController alloc] initWithRootViewController:blankVC];
    self.bookNVC     = blankNVC;
    self.activityNVC = blankNVC;
    self.projectNVC  = blankNVC;
    self.memberNVC   = blankNVC;
    
    self.viewControllers = @[self.bookNVC,self.projectNVC,self.activityNVC,self.memberNVC];

    //如果用户登录过存在本地有uid
    if ([[User getInstance] isLogin]) {
        //获得存在本地的帐户和密码
        NSString *username = [User getInstance].username;
        NSString *password = [User getInstance].password;
        //请求体
        NSDictionary *param = @{@"username":username,
                                @"password":password};
        [[HttpService getInstance] POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

            
            //成功的回调
            [self setup];
            User *user = [User getInstance];
            
            //姓名
            if (responseObject[@"userInfo"][@"realName"] != [NSNull null] && responseObject[@"userInfo"][@"realName"] != nil && ![responseObject[@"userInfo"][@"realName"] isEqualToString:@""]) {
                user.realname = responseObject[@"userInfo"][@"realName"];
            }
            //公司
            if (responseObject[@"userInfo"][@"company"] != [NSNull null] && responseObject[@"userInfo"][@"company"] != nil && ![responseObject[@"userInfo"][@"company"] isEqualToString:@""]) {
                user.company = responseObject[@"userInfo"][@"company"];
            }
            //职务
            if (responseObject[@"userInfo"][@"duty"] != [NSNull null] && responseObject[@"userInfo"][@"duty"] != nil && ![responseObject[@"userInfo"][@"duty"] isEqualToString:@""]) {
                user.duty = responseObject[@"userInfo"][@"duty"];
            }
            //邮箱
            if (responseObject[@"userInfo"][@"email"] != [NSNull null] && responseObject[@"userInfo"][@"email"] != nil && ![responseObject[@"userInfo"][@"email"] isEqualToString:@""]) {
                user.email = responseObject[@"userInfo"][@"email"];
            }
            //微信
            if (responseObject[@"userInfo"][@"weChat"] != [NSNull null] && responseObject[@"userInfo"][@"weChat"] != nil && ![responseObject[@"userInfo"][@"weChat"] isEqualToString:@""]) {
                user.wechat = responseObject[@"userInfo"][@"weChat"];
            }
            //是否APP管理员，文献列表选择用此传值
            [User getInstance].isAdmin = responseObject[@"userInfo"][@"isAdmin"];
            //是否社区管理员，文献列表选择用此传值
            [User getInstance].isBm = responseObject[@"userInfo"][@"isBm"];
            //是否投资人
            if (responseObject[@"investorInfo"] != [NSNull null] && [responseObject[@"investorInfo"][@"bizStatus"] integerValue] == 1) {
                user.isInvestor = @1;
            } else {
                user.isInvestor = @0;
            }
        } noResult:^{
            NSLog(@"11111");
        }];
    } else {
        //    同样发一下游客登录接口
        //[[HttpService getInstance] POST:@"visitorLogin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[self setup];
            
            [self login];
            
        //} noResult:nil];
    }
}

- (void)login {
    [self setup];
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)goToHome {

    [[HttpService getInstance] POST:@"visitorLogin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       [self setup];
    } noResult:nil];
}

//初始化
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
