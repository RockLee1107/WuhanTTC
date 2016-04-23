//
//  CopyrightViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/23.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CopyrightViewController.h"

@interface CopyrightViewController ()
@property (nonatomic,weak) IBOutlet UITextView *textView;
@end

@implementation CopyrightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *param = @{
                            @"bookId":self.bookId
                            };
    [self.service POST:@"book/copyRight/getBookCopyRight" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *copyRight = responseObject[@"copyRight"];
        NSString *linkMobile = responseObject[@"linkMobile"];
        NSString *wechat = responseObject[@"wechat"];
        NSString *ps = @"（添加时注明：版权）";
        NSString *contentStr = [NSString stringWithFormat:@"%@\n\n联系我们:\n\n        %@\n\n        微信号%@\n\n                %@",
                              copyRight,
                              linkMobile,
                              wechat,
                              ps];
        [self.textView setAttributedText:[[NSAttributedString alloc] initWithString:contentStr attributes:[StringUtil textViewAttribute]]];
    } noResult:nil];
}

@end
