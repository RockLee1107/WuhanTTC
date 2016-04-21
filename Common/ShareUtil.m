//
//  ShareUtil.m
//  Commune
//
//  Created by Dotton on 16/3/23.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ShareUtil.h"
//#import "Global.h"
//umeng
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
//umeng - wechat
#import "WXApi.h"
//友盟
#define UmengAppkey @"570bbe96e0f55a6170001eb9"
//微信
#define kWXAPP_ID @"wxbdf56f09903d451e"
#define kWXAPP_SECRET @"b8c1a5ea6266cf931466b2e23ce4270b"
//qq
#define qqApp_ID @"1105122260"
#define qqApp_KEY @"9lVbJWCqnLnkOQy2"
//sina
#define sinaAppKey @"901419200"
#define sinaRedirectURI @"http://www.it577.net/"

@implementation ShareUtil
+ (instancetype)getInstance {
    static ShareUtil *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

- (void)shareWithUrl {
    //    [SVProgressHUD showErrorWithStatus:@"缺少app_secret"];
    NSString *shareText = self.shareText;
    UIImage *shareImage = [UIImage imageNamed:@"logo.png"];          //分享内嵌图片
    NSString *url = self.shareUrl;
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWXAPP_ID appSecret:kWXAPP_SECRET url:url];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:qqApp_ID appKey:qqApp_KEY url:url];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaHandler openSSOWithRedirectURL:sinaRedirectURI];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:sinaAppKey RedirectURL:sinaRedirectURI];
    NSMutableArray *snsArr = [NSMutableArray array];
    //    QQ分享
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [snsArr addObject:UMShareToQzone];
        [snsArr addObject:UMShareToQQ];
    }
    //    微信分享
    if ([WXApi isWXAppInstalled]) {
        [snsArr addObject:UMShareToWechatSession];
        [snsArr addObject:UMShareToWechatTimeline];
    }
    //    腾讯微博
//    [snsArr addObject:UMShareToTencent];
//    [UMSocialData defaultData].extConfig.tencentData.shareText = [NSString stringWithFormat:@"%@ %@",shareText,url];
    //    新浪微博
    [snsArr addObject:UMShareToSina];
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",shareText,url];
    [UMSocialSnsService presentSnsIconSheetView:self.vc
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsArr
                                       delegate:nil];
}
@end
