//
//  BizViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BizViewController.h"
#import "JCTagListView.h"
#import "StatusDict.h"

@interface BizViewController ()
@property (nonatomic, weak) IBOutlet JCTagListView *tagListView;

@end

@implementation BizViewController

//视图将要出现
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagListView.canSelectTags = YES;
    self.tagListView.maxCount = 4;
//    初始
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in [StatusDict industry]) {
        [array addObject:dict[@"bizName"]];
    }
    self.tagListView.tags = array;
    //已选
//    考虑从原编辑页面传回，否则一直是nil就不能够addObject了。
    if (_selectedNameArray != nil) {
        self.tagListView.selectedTags = _selectedNameArray;
    }
//    考虑从原编辑页面传回，否则传来的就清空了。
    if (_selectedCodeArray == nil) {
        _selectedCodeArray = [NSMutableArray array];
    }
    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
//        NSLog(@"______%ld______", (long)index);
        //判断已选状态，是则加入，否则移除
        if ([self.tagListView.selectedTags containsObject:array[index]]) {
            [self.selectedCodeArray addObject:[StatusDict industry][index][@"bizCode"]];
        } else {
            [self.selectedCodeArray removeObject:[StatusDict industry][index][@"bizCode"]];
        }
    }];
}

- (IBAction)finish:(id)sender {
    [self.delegate didSelectedTags:_selectedCodeArray selectedNames:self.tagListView.selectedTags];
    if (_selectedCodeArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"最少选择一个"];
        return;
    }
    [self goBack];
}

@end
