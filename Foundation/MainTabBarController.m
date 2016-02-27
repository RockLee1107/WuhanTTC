//
//  MainTabBarController.m
//  
//
//  Created by HuangXiuJie on 16/2/26.
//
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *bookNVC     = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateInitialViewController];
    UINavigationController *activityNVC = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateInitialViewController];
    UINavigationController *projectNVC  = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateInitialViewController];
    UINavigationController *memberNVC   = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateInitialViewController];
    self.viewControllers = @[bookNVC,activityNVC,projectNVC,memberNVC];
    bookNVC.tabBarItem.selectedImage        = [UIImage imageNamed:@"icon_book_selected"];
    activityNVC.tabBarItem.selectedImage    = [UIImage imageNamed:@"icon_activity_selected"];
    projectNVC.tabBarItem.selectedImage     = [UIImage imageNamed:@"icon_project_selected"];
    memberNVC.tabBarItem.selectedImage      = [UIImage imageNamed:@"icon_member_selected"];
    // Do any additional setup after loading the view.
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
