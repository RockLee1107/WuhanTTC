//
//  Global.h
//  Beauty
//
//  Created by HuangXiuJie on 15/3/4.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#ifndef Beauty_Global_h
#define Beauty_Global_h

#define MAIN_COLOR [UIColor colorWithRed:41/255.0 green:143/255.0 blue:230/255.0 alpha:1.0]
#define HOST_URL @"http://120.25.231.152:8080/ttc_web"
#define UPLOAD_URL @"http://www.teamchuang.com/ttc_uploads"
#define HGfont(s)  [UIFont systemFontOfSize:(s)]
#define HGColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HGolorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define RECT_LOG(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define NETWORK_ERROR @"网络错误"

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

#define ACTIVITY_STATUS_ARRAY @[@"报名中",@"已满",@"已结束"]
#endif
