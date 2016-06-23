//
//  Global.h
//  Beauty
//
//  Created by HuangXiuJie on 15/3/4.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef Beauty_Global_h
#define Beauty_Global_h
#define MAIN_COLOR [UIColor colorWithRed:41/255.0 green:143/255.0 blue:230/255.0 alpha:1.0]   //蓝色
#define BACKGROUND_COLOR [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]   //背景灰
#define SEPARATORLINE [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]   //分割线


#define MENU_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

/*dev db*/    //测试环境
//#define HOST_URL @"http://192.168.0.109:8080/ttc_web"//星星创
#define HOST_URL @"http://120.25.76.149:8088/ttc_web"//测试机
#define SHARE_BOOK_URL @"http://test.teamchuang.com:8088/ttc_web/book/share"
#define UPLOAD_URL @"http://120.25.76.149/ttc_uploads"
#define SHARE_BP_URL @"http://test.teamchuang.com:8088/ttc_web/bp/share"

/*pro db*/    //正式环境
//#define HOST_URL @"http://120.25.231.152:8080/ttc_web"
////#define SHARE_URL @"http://www.teamchuang.com/ttc_uploads/upload/Share"
//#define UPLOAD_URL @"http://www.teamchuang.com/ttc_uploads"
//#define SHARE_BOOK_URL @"http://www.teamchuang.com:8080/ttc_web/book/share"
//#define SHARE_BP_URL @"http://www.teamchuang.com:8080/ttc_web/bp/share"

#define HGfont(s)  [UIFont systemFontOfSize:(s)]
#define HGColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HGolorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define RECT_LOG(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define NETWORK_ERROR @"网络错误"

//友盟
#define UmengAppkey @"570bbe96e0f55a6170001eb9"

//typedef enum : NSUInteger {
//    ACTIVITY_STATUS_ONE,
//    ACTIVITY_STATUS_TWO,
//    ACTIVITY_STATUS_THREE,
//} ACTIVITY_STATUS;
#define DOC_COLOR [UIColor colorWithRed:41/255.0 green:155/255.0 blue:232/255.0 alpha:1.0]
#define PPT_COLOR [UIColor colorWithRed:255/255.0 green:130/255.0 blue:0/255.0 alpha:1.0]
#define VIDEO_COLOR [UIColor colorWithRed:104/255.0 green:191/255.0 blue:54/255.0 alpha:1.0]
#define BOOK_TYPE_COLOR @{@"DOC":DOC_COLOR,@"PPT":PPT_COLOR,@"VIDEO":VIDEO_COLOR}
#define BOOK_TYPE_TEXT @{@"DOC":@"图文",@"PPT":@"PPT",@"VIDEO":@"视频"}

#define ACTIVITY_STATUS_ON_COLOR [UIColor colorWithRed:104/255.0 green:191/255.0 blue:54/255.0 alpha:1.0]
#define ACTIVITY_STATUS_OVER_COLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define ACTIVITY_STATUS_FULL_COLOR [UIColor colorWithRed:238/255.0 green:48/255.0 blue:0/255.0 alpha:1.0]

//TableView分割线颜色(浅灰色)
#define SeparatorColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

#define ACTIVITY_STATUS_ARRAY @[@"报名中",@"已满",@"已结束"]
#define USER_IDENTITY_DICT @{@"INVESTOR":@"投资者",@"CREATOR":@"创业者"}
//图集尺寸
#define IMAGE_WIDTH ((SCREEN_WIDTH) - 32) / 4.0 - 4
#define IMAGE_WIDTH_WITH_PADDING (IMAGE_WIDTH + 5)
#define IMAGE_SingleWidth (SCREEN_WIDTH-32)
//保存或发布
typedef enum : NSUInteger {
    BizStatusSave,
    BizStatusPublish,
    BizStatusChecked,
    BizStatusReject
} BizStatus;

#endif
