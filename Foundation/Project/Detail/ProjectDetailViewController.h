//
//  ProjectDetailViewController.h
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "Global.h"
#import "BasePageController.h"

@interface ProjectDetailViewController : BasePageController
@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,assign) BOOL whetherUpdate;//是否更新项目
@end
