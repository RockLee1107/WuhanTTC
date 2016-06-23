//
//  ProjectSummaryViewController.h
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "BaseStaticTableViewController.h"

@interface ProjectSummaryTableViewController : BaseStaticTableViewController
@property (strong,nonatomic) NSString *pid;
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, copy) NSString *projectId;
@end
