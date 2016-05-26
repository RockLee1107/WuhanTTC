//
//  ProjectCreateTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "EMTextView.h"
#import "LXButton.h"
#import "LXPhotoPicker.h"
#import "AJPhotoPickerGallery.h"

@interface ProjectCreateTableViewController : BaseStaticTableViewController
@property (strong,nonatomic) NSString *pid;
//由于发布项目要从外部类调用，故此将成员变量放在.h
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
//项目阶段
@property (weak, nonatomic) IBOutlet UIButton *statusButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedStatusIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedStatusValue;           //状态value，用于数据提交
//融资阶段
@property (weak, nonatomic) IBOutlet UIButton *financeButton;
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
//项目领域
@property (weak, nonatomic) IBOutlet UIButton *bizButton;
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;

@property (weak, nonatomic) IBOutlet EMTextView *descTextView;          //描述
@property (strong, nonatomic) LXPhotoPicker *picker;
//照片拾取器
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
@end
