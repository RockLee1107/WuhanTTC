//
//  FinanceCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/6.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceCreateTableViewController.h"
#import "EMTextView.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "StatusDict.h"

@interface FinanceCreateTableViewController ()
//融资阶段
@property (weak, nonatomic) IBOutlet UIButton *financeButton;
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
//融资金额
@property (weak, nonatomic) IBOutlet UITextField *financeAmountTextField;
//融资进展
@property (weak, nonatomic) IBOutlet UISegmentedControl *financeProcSegmentedControl;
//融资币种
@property (weak, nonatomic) IBOutlet UISegmentedControl *moneyTypeSegmentedControl;
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *financeTimeButton;
@property (nonatomic, strong) NSDate *financeTime;
//融资金额
@property (weak, nonatomic) IBOutlet UITextField *sellSharesTextField;
//投资人/投资机构
@property (weak, nonatomic) IBOutlet EMTextView *investCompTextView;

@end

@implementation FinanceCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    初始化日期
    self.financeTime = [NSDate date];
    [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
}

//选择融资阶段
- (IBAction)selectFinace:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict financeProc];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"financeProcName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择融资阶段" rows:names initialSelection:self.selectedFinanceIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedFinanceIndex = selectedIndex;
        //            当前选值以提交
        self.selectedFinanceValue = array[selectedIndex][@"financeProcCode"];
        [self.financeButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

///选择开始日期
- (IBAction)selectFinanceTime:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择融资时间" datePickerMode:UIDatePickerModeDate selectedDate:self.financeTime minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.financeTime = selectedDate;
    [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
}

- (IBAction)submit:(id)sender {
    if (![VerifyUtil hasValue:self.selectedFinanceValue]) {
        [SVProgressHUD showErrorWithStatus:@"请选择融资阶段"];
        return;
    }
    if (![VerifyUtil hasValue:self.financeAmountTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写融资金额"];
        return;
    }
    if (![VerifyUtil hasValue:self.sellSharesTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写出让股份"];
        return;
    }
    if ([self.sellSharesTextField.text integerValue] > 100) {
        [SVProgressHUD showErrorWithStatus:@"出让股份应该是小于100"];
        return;
    }
    if (self.financeProcSegmentedControl.selectedSegmentIndex == 1) {
        if (![VerifyUtil hasValue:self.investCompTextView.text]) {
            [SVProgressHUD showErrorWithStatus:@"请填写投资人/投资机构"];
            return;
        }
    }
    
    NSDictionary *financeDict = @{
                                  @"financeAmount":self.financeAmountTextField.text,
                                  @"financeProc":[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex],
                                  @"financeProcCode":self.selectedFinanceValue,
                                  @"financeTime":[DateUtil dateToDatePart:self.financeTime],
                                  @"investComp": ![VerifyUtil hasValue:self.investCompTextView.text] ? @"" : self.investCompTextView.text,
                                  @"moneyType":[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex],
                                  @"projectId":self.pid,
                                  @"sellShares":self.sellSharesTextField.text
                                  };
    [self.parentVC.dataArray addObject:financeDict];
//    数据源传回
//    self.parentVC.dataArray = self.mArray;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
