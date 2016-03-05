//
//  BookSearcher.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookSearcher.h"
#import "User.h"

@implementation BookSearcher
- (instancetype)init{
    self = [super init];
    self.userId = [User getInstance].uid;
    self.specialCode = @"";
    self.isRead = @"1";
    self.orderBy = @"pbDate";
    
    self.authorId = @"1";
    self.referUserId = @"1";
    self.labelId = @"1";
    self.bookType = @"1";
    self.period = @"1";
   
    return self;
}

- (NSDictionary *)dictionary {
    NSDictionary *dict = @{@"SEQ_userId":self.userId,
                           @"SEQ_specialCode":self.specialCode,
                           @"IEQ_isRead":self.isRead,
                           @"SEQ_orderBy":self.orderBy,
                           @"IEQ_authorId":self.isRead,
                           @"IEQ_referUserId":self.isRead,
                           @"IEQ_labelId":self.isRead,
                           @"IEQ_bookType":self.isRead,
                           @"IEQ_period":self.isRead
                           };
    return dict;
}
@end
