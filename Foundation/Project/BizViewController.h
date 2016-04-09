//
//  BizViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@protocol BizViewControllerDelegate
- (void)didSelectedTags:(NSArray *)selectedCodeArray selectedNames:(NSArray *)selectedNameArray;
@end

@interface BizViewController : BaseViewController
@property (nonatomic, strong) id<BizViewControllerDelegate> delegate;
@end