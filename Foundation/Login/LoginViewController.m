//
//  LoginViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/4.
//
//

#import "LoginViewController.h"
#import "LocationUtil.h"
#import "LXPasswordView.h"
#import "MainTabBarController.h"
#import "LXButton.h"
#import "ProjectCreateTableViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;
@property (weak, nonatomic) IBOutlet LXButton *visitorButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationUtil getInstance] fetchLocation];
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.usernameTextField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.visitorButton.backgroundColor = [UIColor grayColor];
    //    自动登录，调试阶段打开
#if DEBUG
    [self performSelector:@selector(loginButtonPress:) withObject:nil afterDelay:.1f];
#endif
    self.usernameTextField.text = @"13587567910";
    self.passwordView.textField.text = @"325200";
}

///游客登录
- (IBAction)vistorButtonPress:(id)sender {
    [self.service POST:@"visitorLogin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self jumpMain];
    } noResult:nil];
}

///会员登录
- (IBAction)loginButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordView.textField.text;
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    [self.service POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"login:%@",responseObject);
        User *user = [User getInstance];
        user.username = responseObject[@"username"];
        user.realname = responseObject[@"realName"];
        user.uid = responseObject[@"userId"];
        if (
            responseObject[@"userInfo"][@"realName"] != [NSNull null]
            && responseObject[@"userInfo"][@"company"] != [NSNull null]
            && responseObject[@"userInfo"][@"duty"] != [NSNull null]
            &&responseObject[@"userInfo"][@"realName"] != nil
            && responseObject[@"userInfo"][@"company"] != nil
            && responseObject[@"userInfo"][@"duty"] != nil
            && ![responseObject[@"userInfo"][@"realName"] isEqualToString:@""]
            && ![responseObject[@"userInfo"][@"company"] isEqualToString:@""]
            && ![responseObject[@"userInfo"][@"duty"] isEqualToString:@""]
            ) {
            user.hasInfo = [NSNumber numberWithBool:YES];
        } else {
            user.hasInfo = [NSNumber numberWithBool:NO];
        }
        //将各状态值存到本地
        [self.service GET:@"activity/getDictionary" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        项目阶段
            [self saveStatusCode:responseObject type:@"procStatus" key:nil];
            //        融资阶段
            [self saveStatusCode:responseObject type:@"financeProc" key:nil];
            //        项目领域
            [self saveStatusCode:responseObject type:@"industry" key:@"biz"];
            //        活动类型
            [self saveStatusCode:responseObject type:@"activityType" key:@"type"];
            //        专题
            [self saveStatusCode:responseObject type:@"specialType" key:@"special"];
        } noResult:nil];
        [self jumpMain];
//        [self jumpTest];
    } noResult:^{
        
    }];
}

- (void)jumpTest {
    ProjectCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"create"];
    [self.navigationController pushViewController:vc animated:YES];
}

//保存状态值到本地
- (void)saveStatusCode:(NSDictionary *)responseObject type:(NSString *)type key:(NSString *)key {
    NSMutableArray *array = [NSMutableArray array];
    //    第三字段可选
    if (key == nil) {
        key = type;
    }
    NSString *code = [NSString stringWithFormat:@"%@Code",key];
    NSString *name = [NSString stringWithFormat:@"%@Name",key];
    for (NSDictionary *procStatusDict in responseObject[type]) {
        [array addObject:@{
                           code:procStatusDict[code],
                           name:procStatusDict[name]
                           }];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:type];
}
@end
