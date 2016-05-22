//
//  KL_ImagesZoomController.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KL_ImagesZoomController : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)NSArray *imgs;

- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size;
- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index;

@end
