//
//  Global.h
//  Beauty
//
//  Created by HuangXiuJie on 15/3/4.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//
#import "ApiUri.h"

#ifndef Beauty_Global_h
#define Beauty_Global_h

#define MAIN_COLOR [UIColor colorWithRed:41/255.0 green:143/255.0 blue:230/255.0 alpha:1.0]

#define HGfont(s)  [UIFont systemFontOfSize:(s)]
#define HGColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HGolorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define RECT_LOG(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define NETWORK_ERROR @"网络错误"
#endif
