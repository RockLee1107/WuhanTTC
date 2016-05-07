//
//  FriendsTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@protocol FriendsListViewControllerDelegate <NSObject>
- (UIViewController *)friendDidSelect:(NSString *)userId realname:(NSString *)realname company:(NSString *)company duty:(NSString *)duty pictUrl:(NSString *)pictUrl;
@end
@interface FriendsListViewController : BaseTableViewController
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) id<FriendsListViewControllerDelegate> selectDelegate;

@end
