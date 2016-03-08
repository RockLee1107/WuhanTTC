//
//  LoginViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/4.
//
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginButtonPress:nil];
    // Do any additional setup after loading the view.
}

- (IBAction)loginButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    HttpService *service = [HttpService getInstance];
    [service POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"login:%@",responseObject);
        User *user = [User getInstance];
        user.username = responseObject[@"username"];
        user.uid = responseObject[@"userId"];
        MainTabBarController *vc = [[MainTabBarController alloc] init];
        [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
    }];
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
