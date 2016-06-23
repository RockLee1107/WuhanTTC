//
//  TeamMemberDelegate.h
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewDelegate.h"

@protocol TeamMemberDelegate <NSObject>

- (void)pushToAdd;

@end

@interface TeamMemberDelegate : BaseTableViewDelegate

@property (nonatomic, assign) id <TeamMemberDelegate> delegate;
@property (nonatomic, copy) NSString *friendId;
@property (nonatomic, copy) NSString *idStr;//标记是添加还是修改成员

@end
