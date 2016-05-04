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
#import "Global.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface AJPhotoPickerGallery : UIView<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDWebImageManagerDelegate>
{
    NSString *currentImageUrl;
}
@property (nonatomic,strong) UIViewController *vc;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UIButton *button;

@property (nonatomic, assign) NSInteger maxCount;
///读取始化
- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)array;
@end
