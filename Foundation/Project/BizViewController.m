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
@property (nonatomic, strong) NSMutableArray *selectedCodeArray;
@property (nonatomic, strong) NSMutableArray *selectedNameArray;
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
    _selectedNameArray = [NSMutableArray array];
    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
//        NSLog(@"______%ld______", (long)index);
        [_selectedNameArray addObject:[StatusDict industry][index][@"bizName"]];
        [_selectedCodeArray addObject:[StatusDict industry][index][@"bizCode"]];
    }];
}

- (IBAction)finish:(id)sender {
    [self.delegate didSelectedTags:_selectedCodeArray selectedNames:_selectedNameArray];
    [self goBack];
}

@end
