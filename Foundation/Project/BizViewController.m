//
//  BizViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BizViewController.h"
#import "StatusDict.h"

@interface BizViewController ()

@end

@implementation BizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagListView.canSelectTags = YES;
//    初始
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in [StatusDict industry]) {
        [array addObject:dict[@"bizName"]];
    }
    self.tagListView.tags = array;
    //已选
    _selectedCodeArray = [NSMutableArray array];
    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
//        NSLog(@"______%ld______", (long)index);
        //判断已选状态，是则加入，否则移除
        if ([self.tagListView.selectedTags containsObject:array[index]]) {
            [self.selectedCodeArray addObject:[StatusDict industry][index][@"bizCode"]];
        } else {
            [self.selectedCodeArray removeObject:[StatusDict industry][index][@"bizCode"]];
        }
        if (self.tagListView.selectedTags.count > 4) {
            [SVProgressHUD showErrorWithStatus:@"最多只能选择4个"];
        }
    }];
}

- (IBAction)finish:(id)sender {
    [self.delegate didSelectedTags:_selectedCodeArray selectedNames:self.tagListView.selectedTags];
    [self goBack];
}

@end
