//
//  AJPhotoPickerView.h
//  Foundation
//
//  Created by Dotton on 16/4/15.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
#define IMAGE_WIDTH ((SCREEN_WIDTH) - 32) / 4.0 - 4
#define IMAGE_WIDTH_WITH_PADDING IMAGE_WIDTH + 5
@interface AJPhotoPickerGallery : UIView<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIViewController *vc;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UIButton *button;

@property (nonatomic, assign) NSInteger maxCount;

@end
