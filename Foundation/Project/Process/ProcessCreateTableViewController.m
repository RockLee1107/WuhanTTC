//
//  ProcessCreateViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProcessCreateTableViewController.h"
#import "EMTextView.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "StatusDict.h"

@interface ProcessCreateTableViewController ()
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *processDateButton;
@property (nonatomic, strong) NSDate *processDate;
//投资人/投资机构
@property (weak, nonatomic) IBOutlet EMTextView *descTextView;
@end

@implementation ProcessCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    初始化日期
    self.processDate = [NSDate date];
    [self.processDateButton setTitle:[DateUtil dateToString:self.processDate] forState:(UIControlStateNormal)];

    
}

///选择开始日期
- (IBAction)selectProcessDate:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择进度时间" datePickerMode:UIDatePickerModeDate selectedDate:self.processDate minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.processDate = selectedDate;
    [self.processDateButton setTitle:[DateUtil dateToString:self.processDate] forState:(UIControlStateNormal)];
}

//提交数据
- (IBAction)submit:(id)sender {
    if (![VerifyUtil isValidStringLengthRange:self.descTextView.text between:1 and:50]) {
        [SVProgressHUD showErrorWithStatus:@"请输入填写重要事件或重大进展(50字以内)"];
        return;
    }
    
    NSDictionary *financeDict = @{
                                  @"desc":self.descTextView.text,
                                  @"processDate":[DateUtil dateToDatePart:self.processDate],
                                  @"projectId":self.pid
                                  };
    [self.parentVC.dataArray addObject:financeDict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
