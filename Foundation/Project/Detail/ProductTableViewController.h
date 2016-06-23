//
//  ProductTableViewController.h
//  Foundation
//
//  Created by Dotton on 16/5/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"
#import "AJPhotoPickerGallery.h"
#import "EMTextView.h"

typedef void (^MyBlock) (NSString *);


@interface ProductTableViewController : BaseStaticTableViewController
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
//产品功能
@property (weak, nonatomic) IBOutlet EMTextView *procDetailsTextView;

@property (nonatomic, copy) NSString *projectId;

@property (nonatomic, copy) MyBlock block;

@property (nonatomic, assign) BOOL isFlag;//更新或者创建

@property (nonatomic, assign) BOOL hasProduct;

@end
