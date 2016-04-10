//
//  ProjectCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectCreateTableViewController.h"
#import "EMTextView.h"
#import "CityViewController.h"
#import "LXButton.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "BizViewController.h"

@interface ProjectCreateTableViewController ()<CityViewControllerDelegete,BizViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
//项目状态
@property (weak, nonatomic) IBOutlet UIButton *statusButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedStatusIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedStatusValue;           //状态value，用于数据提交
//融资阶段
@property (weak, nonatomic) IBOutlet UIButton *financeButton;
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
//项目领域
@property (weak, nonatomic) IBOutlet UIButton *bizButton;
//@property (strong, nonatomic) NSString *selectedBizValue;
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;

@property (weak, nonatomic) IBOutlet EMTextView *descTextView;          //描述


@end

@implementation ProjectCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

///切换城市
- (IBAction)switchCity:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegete = self;
//    vc.vc = self;
}

///选择了城市之后的回调
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self.currentCityButton setTitle:city forState:(UIControlStateNormal)];
}

///选择了投资领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
//    self.selectedBizValue = [selectedCodeArray componentsJoinedByString:@","];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}

//选择项目阶段
- (IBAction)selectStatus:(id)sender {
//    数据预处理
    NSArray *array = [StatusDict procStatus];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"procStatusName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择项目阶段" rows:names initialSelection:self.selectedStatusIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedStatusIndex = selectedIndex;
        //            当前选值以提交
        self.selectedStatusValue = array[selectedIndex][@"procStatusCode"];
        [self.statusButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
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

//投资领域
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"biz"]) {
        BizViewController *vc = segue.destinationViewController;
        vc.selectedCodeArray = self.selectedCodeArray;
        vc.tagListView.selectedTags = self.selectedNameArray;
        vc.delegate = self;
    }
}

- (IBAction)createButtonPress:(id)sender {
    NSDictionary *param = @{
                            @"projectName":self.projectNameTextField.text,
//                            @"headPictUrl"
                            @"projectResume":self.projectResumeTextView.text,
                            @"desc":self.descTextView.text,
                            @"procStatusCode":self.selectedStatusValue,
                            @"financeProcCode":self.selectedFinanceValue,
                            @"area":[self.currentCityButton titleForState:(UIControlStateNormal)],
                            @"bizCode":[self.selectedCodeArray componentsJoinedByString:@","]
                            };
    NSLog(@"%@",param);
    
    
//    [self.service POST:@"/personal/prefectProject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } noResult:nil];
}

@end
