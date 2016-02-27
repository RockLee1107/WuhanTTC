//
//  UserService.m
//  MobileSheild
//
//  Created by HuangXiuJie on 15/3/28.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "HttpService.h"
#import "SVProgressHUD.h"
@implementation HttpService
- (instancetype)init {
    self.manager = [AFHTTPRequestOperationManager manager];
    return self;
}
+ (instancetype)getInstance {
    static HttpService *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

- (void)POST:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success{
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
//    NSLog(@"url:%@",urlstr);
    //申明返回的结果是json类型,不声明亦可
//    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //不声明也运行正常，反之设为text/html则报错
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [self.manager POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject： %@",responseObject);
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",operation.responseString);
    }];

    
}
@end
