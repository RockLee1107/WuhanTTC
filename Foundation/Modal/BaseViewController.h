//
//  BaseTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "StringUtil.h"
#import "DateUtil.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface BaseViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) NSArray *dataImmutableArray;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,strong) HttpService *service;
@end
