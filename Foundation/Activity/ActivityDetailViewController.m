//
//  ActivityDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailTableViewController.h"
#import "DTKDropdownMenuView.h"
#import "LXButton.h"
#import "LoginViewController.h"
#import "KGModal.h"
#import "Masonry.h"
#import "LXButton.h"

@interface ActivityDetailViewController ()
@property (weak, nonatomic) IBOutlet LXButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerMarginBottom;
@property (strong, nonatomic) NSMutableArray *requiredInfoType;
@property (strong, nonatomic) NSMutableArray *requiredTextField;
@property (strong, nonatomic) NSMutableArray *requiredKey;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}


- (void)fetchData {
    NSDictionary *param = @{
                            @"activityId":self.activityId
                            };
    [self.service POST:@"/activity/getActivity" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        if (![self.dataDict[@"createById"] isEqualToString:[User getInstance].uid]) {
//            如果是非本人发布，才显示报名按钮
            self.joinButton.hidden = NO;
        } else {
            self.containerMarginBottom.constant = 0;
        }
//        添加右上角菜单 
        [self addRightItem];
    } noResult:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ActivityDetailTableViewController *vc = segue.destinationViewController;
    vc.activityId = self.activityId;
}

- (IBAction)joinButtonPress:(id)sender {
    if (![[User getInstance] isLogin]) {
        [self jumpLogin];
        return;
    }
    self.requiredInfoType = [NSMutableArray array];
    self.requiredTextField = [NSMutableArray array];
    self.requiredKey = [NSMutableArray array];
//    duty
//    company
//    email
//    weChat
    NSDictionary *dict = @{
                           @"姓名":@"name",//realname
                           @"手机":@"mobile",//username
                           @"公司":@"company",
                           @"邮箱":@"email",
                           @"微信":@"wechat",
                           @"职务":@"duty"
                           };
//    NSArray *infoTypeArray = [[StringUtil toString:self.dataDict[@"infoType"]] componentsSeparatedByString:@","];
    NSString *infoType = [StringUtil toString:self.dataDict[@"infoType"]];
//    NSLog(@"infoType：%@",infoType);
    BOOL flag = YES;
    User *user = [User getInstance];
    if ([infoType rangeOfString:@"公司"].location != NSNotFound) {
        if (user.company == nil || [user.company isEqualToString:@""]) {
            [self.requiredInfoType addObject:@"公司"];
            flag = NO;
        }
    }
    if ([infoType rangeOfString:@"邮箱"].location != NSNotFound) {
        if (user.email == nil || [user.email isEqualToString:@""]) {
            [self.requiredInfoType addObject:@"邮箱"];
            flag = NO;
        }
    }
    if ([infoType rangeOfString:@"微信"].location != NSNotFound) {
        if (user.wechat == nil || [user.wechat isEqualToString:@""]) {
            [self.requiredInfoType addObject:@"微信"];
            flag = NO;
        }
    }
    if ([infoType rangeOfString:@"职务"].location != NSNotFound) {
        if (user.duty == nil || [user.duty isEqualToString:@""]) {
            [self.requiredInfoType addObject:@"职务"];
            flag = NO;
        }
    }
    
    if (!flag) {
//        弹窗完善资料
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.8, self.requiredInfoType.count * 50 + 100)];
        view.layer.cornerRadius = 4.0;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < self.requiredInfoType.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = self.requiredInfoType[i];
            [view addSubview:label];
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).offset(40);
                make.top.equalTo(view.mas_top).offset(30 + i * 50);
                make.width.mas_equalTo(40);
            }];
            UITextField *textField = [[UITextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            [view addSubview:textField];
            [textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.right.equalTo(view.mas_right).offset(-20);
                make.centerY.equalTo(label.mas_centerY);
            }];
            [self.requiredTextField addObject:textField];
            [self.requiredKey addObject:dict[self.requiredInfoType[i]]];
        }
        LXButton *confirmButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
        [confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [view addSubview:confirmButton];
        [confirmButton addTarget:self action:@selector(confirmButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).offset(-30);
            make.left.equalTo(view.mas_left).offset(30);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.3);
            make.height.mas_equalTo(40);
        }];
        LXButton *cancelButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
        [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
        [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [view addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).offset(-30);
            make.right.equalTo(view.mas_right).offset(-30);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.3);
            make.height.mas_equalTo(40);
        }];
        [[KGModal sharedInstance] showWithContentView:view];
    } else {
        //报名操作
        NSDictionary *param = @{
                                @"activityId":self.activityId,
                                @"name":[User getInstance].realname,
                                @"mobile":[User getInstance].username,
                                @"company":[StringUtil toString:[User getInstance].company],
                                @"duty":[StringUtil toString:[User getInstance].duty],
                                @"wechat":[StringUtil toString:[User getInstance].wechat],
                                @"email":[StringUtil toString:[User getInstance].email]
                                };
        [self.service POST:@"/apply/addApplys" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"报名成功"];
        } noResult:nil];
    }
}

//弹窗提交按钮
- (void)confirmButtonPress:(UIButton *)sender {
    for (int i = 0; i < self.requiredKey.count; i++) {
        //        NSLog(@"%@",self.requiredKey[i]);
        //        NSLog(@"%@",[self.requiredTextField[i] text]);
        if (![VerifyUtil hasValue:[self.requiredTextField[i] text]]) {
            [SVProgressHUD showErrorWithStatus:@"请填写内容"];
            return;
        }
    }
    //报名操作
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"activityId":self.activityId,
                                                                                @"name":[User getInstance].realname,
                                                                                @"mobile":[User getInstance].username,
                                                                                @"company":[StringUtil toString:[User getInstance].company],
                                                                                @"duty":[StringUtil toString:[User getInstance].duty],
                                                                                @"wechat":[StringUtil toString:[User getInstance].wechat],
                                                                                @"email":[StringUtil toString:[User getInstance].email]
                                                                                }];
    for (int i = 0; i < self.requiredKey.count; i++) {
//        NSLog(@"%@",self.requiredKey[i]);
//        NSLog(@"%@",[self.requiredTextField[i] text]);
        [param setObject:[self.requiredTextField[i] text] forKey:self.requiredKey[i]];
    }
    

    [self.service POST:@"/apply/addApplys" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"报名成功"];
        [[KGModal sharedInstance] hide];
    } noResult:nil];
}

//弹窗取消按钮
- (void)cancelButtonPress:(UIButton *)sender {
    [[KGModal sharedInstance] hide];
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"关注" iconName:@"menu_collect.png" callBack:^(NSUInteger index, id info) {
//        访问网络
        NSDictionary *param = @{
                                @"Participate":[StringUtil dictToJson:@{
                                                                        @"activityId":self.activityId,
                                                                        @"userId":[User getInstance].uid,
                                                                        @"isAttention":@1
                                                                        }]
                                };
        [self.service GET:@"/activity/activityAttention" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"关注活动成功"];
        } noResult:nil];
    }];
    NSMutableArray *array = [NSMutableArray array];
//    本人无关注
    if (![self.dataDict[@"createById"] isEqualToString:[User getInstance].uid]) {
        [array addObject:item0];
    }
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:array icon:@"ic_menu"];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

@end
