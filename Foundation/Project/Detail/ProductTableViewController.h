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

@interface ProductTableViewController : BaseStaticTableViewController
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
//产品功能
@property (weak, nonatomic) IBOutlet EMTextView *procDetailsTextView;
@end
