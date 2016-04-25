//
//  LXWebView.h
//  Foundation
//
//  Created by Dotton on 16/4/25.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXWebView : UIWebView
@property (nonatomic,strong) NSString *bookId;
@property (nonatomic,strong) NSString *bookName;
- (void)customMenu;
@end
