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
//#import "ProjectCreateTableViewController.h"
#import "BookSearchViewController.h"
#import "SingletonObject.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;//大白框
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//装登录页面，快速注册，忘记密码页面
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;//用户名
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;//密码
@property (weak, nonatomic) IBOutlet LXButton *visitorButton;//随便逛逛

@property (nonatomic,assign) BOOL isMaticLogout;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加返回按钮
//    [self createBackButton];
    
    /**************定位***************/
    [[LocationUtil getInstance] fetchLocation];
    
    self.containerView.layer.cornerRadius = 4.0;
    self.containerView.clipsToBounds = YES;
    [self.scrollView addGestureRecognizer:self.tap];
    self.usernameTextField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.visitorButton.backgroundColor = [UIColor grayColor];
    //    自动登录，调试阶段打开
#if DEBUG
//    [self performSelector:@selector(loginButtonPress:) withObject:nil afterDelay:.1f];
#endif
//    self.usernameTextField.text = @"13587567910";
//    self.usernameTextField.text = @"18658350723";
//    self.usernameTextField.text = @"15867718912";
//    self.passwordView.textField.text = @"325200";
//    胡念测试号
//    self.usernameTextField.text = @"18602764235";
//    self.passwordView.textField.text = @"zxcvbn";
    
}

- (void)createBackButton {
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(30, 29, 49, 30);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left@2x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

///点击随便逛逛
- (IBAction)vistorButtonPress:(id)sender {
    [self.service POST:@"visitorLogin" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MainTabBarController *vc = [[MainTabBarController alloc] init];
        [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
        [vc goToHome];
        
    } noResult:nil];
}

///会员登录
- (IBAction)loginButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordView.textField.text;
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    
    if (![VerifyUtil isMobile:username]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
//    if (![VerifyUtil isSimplePassword:password]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
//        return;
//    }
//    if (![VerifyUtil isAdvancePassword:password]) {
//        [SVProgressHUD showErrorWithStatus:@"不能输入含有中文的字符"];
//        return;
//    }
    
    [self.service POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        User *user = [User getInstance];
        user.username = responseObject[@"username"];
        user.password = password;
        user.realname = responseObject[@"realName"];
        user.uid = responseObject[@"userId"];
        //是否APP管理员，文献列表选择用此传值
        user.isAdmin = responseObject[@"userInfo"][@"isAdmin"];
        //是否社区管理员，文献列表选择用此传值
        user.isBm = responseObject[@"userInfo"][@"isBm"];
        
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
        //是否投资人
        if (responseObject[@"investorInfo"] != [NSNull null] && [responseObject[@"investorInfo"][@"bizStatus"] integerValue] == 1) {
            user.isInvestor = @1;
        } else {
            user.isInvestor = @0;
            //将认证投资人的审核状态存在本地
            if (responseObject[@"investorInfo"] != [NSNull null]) {
                [user setBizStatus:[responseObject[@"investorInfo"][@"bizStatus"] stringValue]];
            }
        }
        
        //将各状态值存到本地
        [self.service GET:@"activity/getDictionary" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //        项目阶段
            [self saveStatusCode:responseObject type:@"procStatus" key:@"procStatus" thirdParty:nil fourThParty:nil];
            //        项目领域
            [self saveStatusCode:responseObject type:@"industry" key:@"biz" thirdParty:nil fourThParty:nil];
            //        融资阶段
            [self saveStatusCode:responseObject type:@"financeProc" key:@"financeProc" thirdParty:nil fourThParty:nil];
            //        活动类型
            [self saveStatusCode:responseObject type:@"activityType" key:@"type" thirdParty:nil fourThParty:nil];
            //        专题
            [self saveStatusCode:responseObject type:@"specialType" key:@"special" thirdParty:nil fourThParty:nil];
            //        文献二级分类
            [self saveStatusCode:responseObject type:@"bookCategory" key:@"category" thirdParty:@"specialCode" fourThParty:@"bookNum"];
        
        } noResult:nil];

        [self jumpMain];
        
    } noResult:^{
        
    }];
}

- (void)jumpTest {
    BookSearchViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"find"];
    [self.navigationController pushViewController:vc animated:YES];
}

//保存状态值到本地
- (void)saveStatusCode:(NSDictionary *)responseObject type:(NSString *)type key:(NSString *)key thirdParty:(NSString *)third fourThParty:(NSString *)fourth{
    NSMutableArray *array = [NSMutableArray array];
    //    第三字段可选
    if (key == nil) {
        key = type;
    }
    NSString *code = [NSString stringWithFormat:@"%@Code",key];
    NSString *name = [NSString stringWithFormat:@"%@Name",key];
    for (NSDictionary *procStatusDict in responseObject[type]) {
//        specialCode
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    code:procStatusDict[code],
                                                                                    name:procStatusDict[name]
                                                                                    }];
        if (third != nil) {
            [dict setObject:procStatusDict[@"specialCode"] forKey:third];
        }
        if (fourth != nil) {
            [dict setObject:procStatusDict[@"bookNum"] forKey:fourth];
        }
        
        [array addObject:dict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:type];
}
@end
