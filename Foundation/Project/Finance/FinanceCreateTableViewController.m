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
#import "DateUtil.h"

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
//出让股份
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
    
    if (self.isFromAdd) {
        //添加
        if ([self.title isEqualToString:@"添加融资信息"]) {
            self.navigationItem.rightBarButtonItem = nil;
            
        }else { //修改 加载从上个页面传过来的值
            
            [self.financeTimeButton setTitle:[DateUtil toString:self.dataDic[@"financeTime"]] forState:(UIControlStateNormal)];
            self.financeTime = [DateUtil toDate:self.dataDic[@"financeTime"] format:@"YYYYMMdd"];
            self.financeAmountTextField.text = [NSString stringWithFormat:@"%@", self.dataDic[@"financeAmount"]];
            self.financeProcSegmentedControl.selectedSegmentIndex = [self.dataDic[@"financeProc"] intValue];
            self.selectedFinanceValue = self.dataDic[@"financeProcCode"];
            
            if ([self.dataDic[@"investComp"] isKindOfClass:[NSNull class]]) {
                self.investCompTextView.text = @"";
            }else {
                self.investCompTextView.text = self.dataDic[@"investComp"];
            }
            self.moneyTypeSegmentedControl.selectedSegmentIndex = [self.dataDic[@"moneyType"] intValue];
            self.sellSharesTextField.text = [NSString stringWithFormat:@"%@", self.dataDic[@"sellShares"]];
            self.pid = self.dataDic[@"projectId"];
            [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
            for (NSDictionary *dict in self.array) {
                if(self.dataDic[@"financeProcCode"] == dict[@"financeProcCode"]){
                    [self.financeButton setTitle:dict[@"financeProcName"] forState:(UIControlStateNormal)];
                }
            }
        }
        
        
    }
    
//    else {
//        if (self.dataDict != nil) {
//            //编辑页面将有传值
//            self.navigationItem.title = @"编辑融资进展";
//            [self.financeTimeButton setTitle:[DateUtil toString:self.dataDict[@"financeTime"]] forState:(UIControlStateNormal)];
//            self.financeTime = [DateUtil toDate:self.dataDict[@"financeTime"] format:@"YYYYMMdd"];
//            self.financeAmountTextField.text = [self.dataDict[@"financeAmount"] stringValue];
//            self.financeProcSegmentedControl.selectedSegmentIndex = [self.dataDict[@"financeProc"] intValue];
//            self.selectedFinanceValue = self.dataDict[@"financeProcCode"];
//            self.investCompTextView.text = ![VerifyUtil hasValue:self.dataDict[@"investComp"]] ? @"" : self.dataDict[@"investComp"];
//            self.moneyTypeSegmentedControl.selectedSegmentIndex = [self.dataDict[@"moneyType"] intValue];
//            self.sellSharesTextField.text = [self.dataDict[@"sellShares"] stringValue];
//            self.pid = self.dataDict[@"projectId"];
//            [self.financeTimeButton setTitle:[DateUtil dateToString:self.financeTime] forState:(UIControlStateNormal)];
//            for (NSDictionary *dict in self.array) {
//                if(self.dataDict[@"financeProcCode"] == dict[@"financeProcCode"]){
//                    [self.financeButton setTitle:dict[@"financeProcName"] forState:(UIControlStateNormal)];
//                }
//            }
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app_delete"] style:(UIBarButtonItemStyleBordered) target:self action:@selector(deleteButtonPress:)];
//        }
//   }
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

//确认
- (IBAction)submit:(id)sender {
    
    if (self.isFromAdd == YES) {
        
        NSString *projectId;
        if ([User getInstance].srcId != nil && ![[User getInstance].srcId isEqualToString:@""] && ![[User getInstance].srcId isKindOfClass:[NSNull class]]) {
            projectId = [User getInstance].srcId;
        }
        else if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            projectId = [User getInstance].createProjectId;
        }
        
        //修改
        if (self.idStr) {
           
            if (![VerifyUtil isDecimal:self.financeAmountTextField.text]) {
                [SVProgressHUD showErrorWithStatus:@"请输入融资金额"];
                return ;
            }
            if (![VerifyUtil isPercentage:self.sellSharesTextField.text]) {
                [SVProgressHUD showErrorWithStatus:@"请输入股份"];
                return ;
            }
            //选择了已融资
            if (self.financeProcSegmentedControl.selectedSegmentIndex == 1) {
                if (![VerifyUtil hasValue:self.investCompTextView.text]) {
                    [SVProgressHUD showErrorWithStatus:@"请填写投资人/投资机构"];
                    return;
                }
            }else {
                self.investCompTextView.text = @"暂无";
            }
           
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"projectId":projectId,
                                           @"financeAmount":self.financeAmountTextField.text,
                                           @"financeProc":[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex] ? [NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex] : self.dataDic[@"financeProc"],
                                           @"financeProcCode":self.selectedFinanceValue ? self.selectedFinanceValue : self.dataDic[@"financeProcCode"],
                                           @"financeTime":[DateUtil dateToDatePart:self.financeTime],
                                           @"moneyType":[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex],
                                           @"sellShares":[NSNumber numberWithInteger:[self.sellSharesTextField.text integerValue]] ? [NSNumber numberWithInteger:[self.sellSharesTextField.text integerValue]] : self.sellSharesTextField.text,
                                           @"id":self.idStr,
                                           @"investComp":self.investCompTextView.text ? self.investCompTextView.text : @"暂无"
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Finance":jsonStr};
            
            [self.service POST:@"finance/saveFinancing" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (![responseObject isKindOfClass:[NSNull class]]) {
                    [User getInstance].projectId = responseObject;
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
            
        }else {//添加
            
            //文本输入判断
            if ([self.financeButton.titleLabel.text isEqualToString:@"请选择"]) {
                [SVProgressHUD showErrorWithStatus:@"请选择融资阶段"];
                return ;
            }
            
            if (![VerifyUtil isDecimal:self.financeAmountTextField.text]) {
                [SVProgressHUD showErrorWithStatus:@"请输入融资金额"];
                return ;
            }
            
            if (![VerifyUtil isPercentage:self.sellSharesTextField.text]) {
                [SVProgressHUD showErrorWithStatus:@"请输入股份"];
                return ;
            }
            
            //选择了已融资
            if (self.financeProcSegmentedControl.selectedSegmentIndex == 1) {
                if (![VerifyUtil hasValue:self.investCompTextView.text]) {
                    [SVProgressHUD showErrorWithStatus:@"请填写投资人/投资机构"];
                    return;
                }
            }else {
                self.investCompTextView.text = @"暂无";
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"projectId":projectId,
                                           @"financeAmount":self.financeAmountTextField.text,
                                           @"financeProc":[NSNumber numberWithInteger:self.financeProcSegmentedControl.selectedSegmentIndex],
                                           @"financeProcCode":self.selectedFinanceValue,
                                           @"financeTime":[DateUtil dateToDatePart:self.financeTime],
                                           @"moneyType":[NSNumber numberWithInteger:self.moneyTypeSegmentedControl.selectedSegmentIndex],
                                           @"sellShares":[NSNumber numberWithInteger:[self.sellSharesTextField.text integerValue]],
                                           @"investComp":self.investCompTextView.text ? self.investCompTextView.text : @"暂无"
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Finance":jsonStr};
            
            [self.service POST:@"finance/saveFinancing" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
        }
        
        
    }else {
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
        /*    对于未融已融状态  */
        //    1.如果是新增一条未融资的记录,那直接判断内存中是否有未融资,如果有,表示重复录入
        //    2.如果是修改,且是由已融资改成未融资的,如果内存中有未融资的,也表示重复录入了未融资的记录
        //    3.其他情况都可以操作成功
        /*    对于融资阶段的判断 */
        //    1 新增，只要内存中包含当前新增记录的融资阶段，则重复
        //    2 修改，只要内存中包含修改后记录的融资阶段，则重复
        //    3 其他情况都可以操作成功
        
        //        内存里是不是含有未融资
        BOOL isExsitUndo = NO;
        //        内存里是不是含有当前融资阶段
        BOOL isExistProcCode = NO;
        for (NSDictionary *item in self.parentVC.dataArray) {
            if ([item[@"financeProc"] integerValue] == 0) {
                isExsitUndo = YES;
            }
            if ([item[@"financeProcCode"] isEqualToString:self.selectedFinanceValue]) {
                isExistProcCode = YES;
            }
        }
        
        //编辑页面将有传值
        if (self.dataDict != nil) {
            //    定义一个dict，初始与写入
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
            //之前融资状态 - self.dataDict[@"financeProc"]
            //        如果是修改,且是由已融资改成未融资的,如果内存中有未融资的,也表示重复录入了未融资的记录
            //表明由融资改为未融资，并且之前存在未融资
            if (([self.dataDict[@"financeProc"] integerValue] == 1 && self.financeProcSegmentedControl.selectedSegmentIndex == 0) && isExsitUndo) {
                [SVProgressHUD showErrorWithStatus:@"当前已有未融资信息哦"];
                return;
            }
            //        当前修改成的融资阶段在之前的内存已经存在
            if (![self.dataDict[@"financeProcCode"] isEqualToString:self.selectedFinanceValue] && isExistProcCode) {
                [SVProgressHUD showErrorWithStatus:@"请勿重复录入融资阶段哦"];
                return;
            }
            
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
        } else {
            //        添加
            //        如果是新增一条未融资的记录,那直接判断内存中是否有未融资,如果有,表示重复录入
            if (isExsitUndo && self.financeProcSegmentedControl.selectedSegmentIndex == 0) {
                [SVProgressHUD showErrorWithStatus:@"当前已有未融资信息哦"];
                return;
            }
            //        添加时仅判断是否内存中存在
            if (isExistProcCode) {
                [SVProgressHUD showErrorWithStatus:@"请勿重复录入融资阶段哦"];
                return;
            }
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
    
}

- (IBAction)deleteBtnClick:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            //有id则是数据库里即有的，否则是刚刚添加进的
            if (self.idStr == nil) {
                [self deleteAndPop];
            } else {
                [self.service POST:@"finance/deleteFinancing" parameters:@{@"id":self.idStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
