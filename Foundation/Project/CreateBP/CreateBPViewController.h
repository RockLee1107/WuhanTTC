//
//  CreateBPViewController.h
//  Foundation
//
//  Created by hyfy002 on 16/5/23.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "LXPhotoPicker.h"
#import "AJPhotoPickerGallery.h"
#import "EMTextView.h"

typedef void (^MyBlock) (NSString *);

@interface CreateBPViewController : BaseStaticTableViewController

@property (strong, nonatomic) IBOutlet UIButton *allVisibleBtn;//全部可见
@property (strong, nonatomic) IBOutlet UIButton *onlyInvestorsBtn;//仅限投资人
@property (strong, nonatomic) IBOutlet UIView *rightView;//可见权限

@property (strong, nonatomic) LXPhotoPicker *picker;

//融资阶段
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
@property (strong, nonatomic) IBOutlet UIButton *financeButton;

@property (nonatomic, strong) NSDate *planDate;

//项目领域
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;
@property (assign, nonatomic) NSInteger selectedStatusIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedStatusValue;           //状态value，用于数据提交
@property (strong, nonatomic) IBOutlet UIButton *bizButton;

@property (strong, nonatomic) IBOutlet EMTextView *descTextView;//描述
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;

@property (strong, nonatomic) IBOutlet UIView *cellContentView;

@property (nonatomic, copy) MyBlock block;


@end
