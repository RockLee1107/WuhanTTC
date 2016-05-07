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
@property (weak, nonatomic) IBOutlet UITableViewCell *investCompCell;
//融资阶段
@property (weak, nonatomic) IBOutlet UIButton *financeButton;
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
@property (strong, nonatomic) NSArray *array;
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
    //    数据预处理
    self.array = [StatusDict financeProc];
    
    if (self.dataDict != nil) {
        //编辑页面将有传值
        self.navigationItem.title = @"编辑融资进展";
        [self.financeTimeButton setTitle:[DateUtil toString:self.dataDict[@"financeTime"]] forState:(UIControlStateNormal)];
        self.financeTime = [DateUtil toDate:self.dataDict[@"financeTime"] format:@"YYYYMMdd"];
        self.financeAmountTextField.text = [self.dataDict[@"financeAmount"] stringValue];
        self.financeProcSegmentedControl.selectedSegmentIndex = [self.dataDict[@"financeProc"] intValue];
        self.selectedFinanceValue = self.dataDict[@"financeProcCode"];
        self.investCompTextView.text = ![VerifyUtil hasValue:self.dataDict[@"investComp"]] ? @"" : self.dataDict[@"investComp"];
        self.moneyTypeSegmentedControl.selectedSegmentIndex = [self.dataDict[@"moneyType"] intValue];
        self.sellSharesTextField.text = [self.dataDict[@"sellShares"] stringValue];
        self.pid = self.dataDict[@"projectId"];
        [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
        for (NSDictionary *dict in self.array) {
            if(self.dataDict[@"financeProcCode"] == dict[@"financeProcCode"]){
                [self.financeButton setTitle:dict[@"financeProcName"] forState:(UIControlStateNormal)];
            }
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app_delete"] style:(UIBarButtonItemStyleBordered) target:self action:@selector(deleteButtonPress:)];
    }
}

//更改融资状态
- (void)changeProcStatus:(id)sender {
    if(self.financeProcSegmentedControl.selectedSegmentIndex == 0){
        
    }
}


//选择融资阶段
- (IBAction)selectFinace:(id)sender {
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in self.array) {
        [names addObject:dict[@"financeProcName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择融资阶段" rows:names initialSelection:self.selectedFinanceIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedFinanceIndex = selectedIndex;
        //            当前选值以提交
        self.selectedFinanceValue = self.array[selectedIndex][@"financeProcCode"];
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
        [SVProgressHUD showErrorWithStatus:@"出让股份应小于100%"];
        return;
    }
    if (self.financeProcSegmentedControl.selectedSegmentIndex == 1) {
        if (![VerifyUtil hasValue:self.investCompTextView.text]) {
            [SVProgressHUD showErrorWithStatus:@"请填写投资人/投资机构"];
            return;
        }
    }
    
    if (self.dataDict != nil) {
        //编辑页面将有传值
        //    定义一个dict，初始与写入
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
        
        
        [dict setObject:[NSNumber numberWithInteger:[self.financeAmountTextField.text integerValue]] forKey:@"financeAmount"];
        [dict setObject:[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex] forKey:@"financeProc"];
        [dict setObject:self.selectedFinanceValue forKey:@"financeProcCode"];
        [dict setObject:[DateUtil dateToDatePart:self.financeTime] forKey:@"financeTime"];
        [dict setObject:![VerifyUtil hasValue:self.investCompTextView.text] ? @"" : self.investCompTextView.text forKey:@"investComp"];
        [dict setObject:[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex] forKey:@"moneyType"];
        [dict setObject:self.pid forKey:@"projectId"];
        [dict setObject:[NSNumber numberWithInteger:[self.sellSharesTextField.text integerValue]] forKey:@"sellShares"];
        //    找回原来的index
        NSInteger index = [self.parentVC.dataArray indexOfObject:self.dataDict];
        [self.parentVC.dataArray setObject:dict atIndexedSubscript:index];
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    NSDictionary *financeDict = @{
                                  @"financeAmount":[NSNumber numberWithInteger:[self.financeAmountTextField.text integerValue]],
                                  @"financeProc":[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex],
                                  @"financeProcCode":self.selectedFinanceValue,
                                  @"financeTime":[DateUtil dateToDatePart:self.financeTime],
                                  @"investComp": ![VerifyUtil hasValue:self.investCompTextView.text] ? @"" : self.investCompTextView.text,
                                  @"moneyType":[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex],
                                  @"projectId":self.pid,
                                  @"sellShares":[NSNumber numberWithInteger:[self.sellSharesTextField.text integerValue]]
                                  };
    [self.parentVC.dataArray addObject:financeDict];
    [self.navigationController popViewControllerAnimated:YES];
}


//delete
- (void)deleteButtonPress:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            //有id则是数据库里即有的，否则是刚刚添加进的
            if (self.dataDict[@"id"] == nil) {
                [self deleteAndPop];
            } else {
                [self.service POST:@"finance/delete" parameters:@{@"id":self.dataDict[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self deleteAndPop];
                } noResult:nil];
            }
        }
    }] useDefaultIOS7Style];
}

//删除内存数据以及返回前一页
- (void)deleteAndPop {
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    [self.parentVC.dataArray removeObject:self.dataDict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
