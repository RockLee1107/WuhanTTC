//
//  ActivityCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityCreateTableViewController.h"
#import "EMTextView.h"
#import "CityViewController.h"
#import "LXButton.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "VerifyUtil.h"
#import "LXPhotoPicker.h"
#import "LocationUtil.h"
#import "StandardViewController.h"

@interface ActivityCreateTableViewController ()<CityViewControllerDelegete,LXPhotoPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitleTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
//活动类型
@property (weak, nonatomic) IBOutlet UIButton *typeButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedTypeIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedTypeValue;           //状态value，用于数据提交
@property (strong, nonatomic) LXPhotoPicker *picker;
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *planDateButton;
@property (nonatomic, strong) NSDate *planDate;
@end

@implementation ActivityCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityTitleTextField.delegate = self;
    [self.currentCityButton setTitle:[LocationUtil getInstance].locatedCityName forState:(UIControlStateNormal)];
    self.planDate = [NSDate date];
}

///切换城市
- (IBAction)switchCity:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegete = self;
}

///选择了城市之后的回调
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self.currentCityButton setTitle:city forState:(UIControlStateNormal)];
}

//选择活动类型
- (IBAction)selectType:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict activityType];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"typeName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择活动类型" rows:names initialSelection:self.selectedTypeIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedTypeIndex = selectedIndex;
        //            当前选值以提交
        self.selectedTypeValue = array[selectedIndex][@"typeCode"];
        [self.typeButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

///选择开始日期
- (IBAction)selectPlanTime:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.planDate minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.planDate = selectedDate;
    [self.planDateButton setTitle:[DateUtil dateToFullString:self.planDate] forState:(UIControlStateNormal)];
}

///活动规范
- (IBAction)standardButtonPress:(id)sender {
    StandardViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"standard"];
    vc.type = @"0";
    vc.naviTitle = @"活动发布规范";
    [self.navigationController pushViewController:vc animated:YES];
}

//点选相片或拍照
- (IBAction)selectPicture:(id)sender {
    [self.currentTextField resignFirstResponder];
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    [self.picker selectPicture];
}

///LXPhoto Delegate
- (void)didSelectPhoto:(UIImage *)image {
    [self.headPictUrlButton setImage:image forState:(UIControlStateNormal)];
}

- (IBAction)saveButtonPress:(id)sender {
    NSDictionary *param = @{
                            @"Activity":[StringUtil dictToJson:@{
                                                                 @"activityTitle":self.activityTitleTextField.text
                                                                 }],
                            @"SrcStatus":@""
                            };
    [self.service POST:@"activity/saveActivity" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } noResult:nil];
}

@end
