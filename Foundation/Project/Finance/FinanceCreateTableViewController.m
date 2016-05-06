//
//  FinanceCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/6.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceCreateTableViewController.h"
#import "EMTextView.h"
#import "LXButton.h"
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
@property (weak, nonatomic) IBOutlet LXButton *cancelButton;

@end

@implementation FinanceCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    初始化日期
    self.financeTime = [NSDate date];
//    取消按钮样式
    self.cancelButton.backgroundColor = [UIColor lightGrayColor];
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
    AbstractActionSheetPicker *actionSheetPicker;actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择开始时间" datePickerMode:UIDatePickerModeDate selectedDate:self.financeTime minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.financeTime = selectedDate;
    [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
}

- (IBAction)submit:(id)sender {
    NSDictionary *financeDict = @{
                                  @"financeAmount":self.financeAmountTextField.text,
                                  @"financeProc":[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex],
                                  @"financeProcCode":self.selectedFinanceValue,
                                  @"financeTime":[DateUtil dateToDatePart:self.financeTime],
                                  @"investComp":self.investCompTextView.text,
                                  @"moneyType":[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex],
                                  @"projectId":self.pid,
                                  @"sellShares":self.sellSharesTextField.text
                                  };
    [self.dataMutableArray addObject:financeDict];
//    数据源传回
    self.parentVC.dataArray = self.dataMutableArray;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
