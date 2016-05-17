//
//  FeedBackTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/27.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FeedBackTableViewController.h"
#import "EMTextView.h"
#import "LXButton.h"
#import "VerifyUtil.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"

@interface FeedBackTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telePhoneTextField;
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *faultTimeButton;
@property (nonatomic, strong) NSDate *faultTime;
//desc textview
@property (weak, nonatomic) IBOutlet EMTextView *faultDescTextView;

@end

@implementation FeedBackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.telePhoneTextField.text = [User getInstance].username;
    //    开始与结束时间
    self.faultTime = [NSDate date];
    [self.faultTimeButton setTitle:[DateUtil dateToCompactStringWithoutSecond:self.faultTime] forState:(UIControlStateNormal)];
}

///点击故障发生时间
- (IBAction)selectfaultTime:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择开始时间" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.faultTime minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.faultTime = selectedDate;
    [self.faultTimeButton setTitle:[DateUtil dateToFullString:self.faultTime] forState:(UIControlStateNormal)];
}

///submit button press  点击提交反馈
- (IBAction)submitButtonPress:(id)sender {
    if (![VerifyUtil hasValue:self.faultDescTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写您需要反馈的信息"];
        return;
    }
    NSDictionary *dict = @{
                            @"userId":[User getInstance].uid,
                            @"faultTime":[DateUtil dateToCompactString:self.faultTime],
                            @"faultDesc":self.faultDescTextView.text,
                            @"telePhone":self.telePhoneTextField.text
                            };
    NSDictionary *param = @{
                            @"FeedBack":[StringUtil dictToJson:dict]
                            };
    [self.service POST:@"personal/feedBack/addFeedBack" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"感谢您的宝贵意见，我们将及时处理，给您带来不便，敬请谅解"];
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}
@end
