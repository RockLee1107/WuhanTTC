//
//  BizViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "JCTagListView.h"

@protocol BizViewControllerDelegate
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray;
@end

@interface BizViewController : BaseViewController
@property (nonatomic, strong) id<BizViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet JCTagListView *tagListView;
@property (nonatomic, strong) NSMutableArray *selectedCodeArray;
@end