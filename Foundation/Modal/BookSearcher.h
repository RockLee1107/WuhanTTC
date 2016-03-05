//
//  BookSearcher.h
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"

@interface BookSearcher : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *specialCode;
@property (nonatomic,strong) NSString *isRead;
@property (nonatomic,strong) NSString *orderBy;//pbDate,readNum,commNum,collNum

@property (nonatomic,strong) NSString *authorId;
@property (nonatomic,strong) NSString *referUserId;
@property (nonatomic,strong) NSString *labelId;
@property (nonatomic,strong) NSString *bookType;
@property (nonatomic,strong) NSString *period;//1,2,3,week,mon,3mon

- (NSDictionary *)dictionary;
@end
