//
//  LXWebView.m
//  Foundation
//
//  Created by Dotton on 16/4/25.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LXWebView.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "StringUtil.h"

@implementation LXWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"添加笔记" action:@selector(note:)];
        UIMenuController *menu =[UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
    }
    return self;
}

- (void)note:(id)sender{
    [self copy:nil];
    UIPasteboard *pasteBoard =[UIPasteboard generalPasteboard];
    if (pasteBoard.string != nil) {
//        访问网络
        NSDictionary *param = @{
                                @"NoteBook":[StringUtil dictToJson:@{
                                                                     @"bookExcerpt":pasteBoard.string,
                                                                     @"bookId":@"",
                                                                     @"excerptType":@"1"
                                                                     //remark
                                                                     }]
                                };
        [[HttpService getInstance] POST:@"personal/notebook/saveNote" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        } noResult:nil];
        //DLog(@"%@", pasteBoard.string);
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(note:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
