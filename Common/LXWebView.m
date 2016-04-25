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
#import "EYInputPopupView.h"
#import "VerifyUtil.h"
#import "User.h"

@implementation LXWebView

- (void)customMenu {
    UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"添加笔记" action:@selector(note:)];
    UIMenuController *menu =[UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
}

- (void)note:(id)sender{
    [self copy:nil];
    UIPasteboard *pasteBoard =[UIPasteboard generalPasteboard];
    if (pasteBoard.string != nil) {
//        弹窗
        [EYInputPopupView popViewWithTitle:@"添加笔记" contentText:@"摘录文字限500字以内哦"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:1 and:500]) {
                                       [SVProgressHUD showErrorWithStatus:@"摘录文字限500字以内哦"];
                                       return ;
                                   }
                                   //        访问网络
                                   NSDictionary *param = @{
                                                           @"NoteBook":[StringUtil dictToJson:@{
                                                                                                @"bookExcerpt":pasteBoard.string,
                                                                                                @"bookId":self.bookId,
                                                                                                @"bookName":self.bookName,
                                                                                                @"excerptType":@"1",
                                                                                                @"userId":[User getInstance].uid,
                                                                                                @"remark":text
                                                                                                }]
                                                           };
                                   [[HttpService getInstance] POST:@"personal/notebook/saveNote" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }
         ];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(note:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
