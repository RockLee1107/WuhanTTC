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

@interface ActivityDetailViewController ()
@property (weak, nonatomic) IBOutlet LXButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerMarginBottom;

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
    
//    duty
//    company
//    email
//    weChat
    NSDictionary *dict = @{
                           @"姓名":@"realname",//name
                           @"手机":@"username",//mobile
                           @"公司":@"company",
                           @"邮箱":@"email",
                           @"微信":@"wechat",
                           @"职务":@"duty"
                           };
//    NSArray *infoTypeArray = [[StringUtil toString:self.dataDict[@"infoType"]] componentsSeparatedByString:@","];
    NSString *infoType = [StringUtil toString:self.dataDict[@"infoType"]];
    NSLog(@"infoType%@",infoType);
    User *user = [User getInstance];
    if ([infoType rangeOfString:@"公司"].location != NSNotFound) {
        if (user.company == nil) {
            [SVProgressHUD showErrorWithStatus:@"请完善公司"];
        }
    }
    if ([infoType rangeOfString:@"邮箱"].location != NSNotFound) {
        if (user.email == nil) {
            [SVProgressHUD showErrorWithStatus:@"请完善邮箱"];
        }
    }
    if ([infoType rangeOfString:@"微信"].location != NSNotFound) {
        if (user.wechat == nil) {
            [SVProgressHUD showErrorWithStatus:@"请完善微信"];
        }
    }
    if ([infoType rangeOfString:@"职务"].location != NSNotFound) {
        if (user.duty == nil) {
            [SVProgressHUD showErrorWithStatus:@"请完善职务"];
        }
    }
    
        //报名操作
        NSDictionary *param = @{
                                @"Applys":[StringUtil dictToJson:@{
                                                                        @"activityId":self.activityId,
                                                                        @"userId":[User getInstance].uid
                                                                        }]
                                };
        [self.service POST:@"/apply/addApplys" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"报名成功"];
        } noResult:nil];
    
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
