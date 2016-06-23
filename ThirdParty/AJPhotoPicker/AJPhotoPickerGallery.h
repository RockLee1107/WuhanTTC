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
#import "ImageUtil.h"

@interface AJPhotoPickerGallery : UIView<AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDWebImageManagerDelegate>
{
    NSString *currentImageUrl;
}
@property (nonatomic,strong) UIViewController *vc;
//全部，用来显示-Image
@property (strong, nonatomic) NSMutableArray *photos;
//新图，用来传值-Image
@property (strong, nonatomic) NSMutableArray *photosArrival;
//保持所有地址，用来传值-String
@property (strong, nonatomic) NSMutableArray *photosStrArray;
//保存新图的地址，用来传值
@property (strong, nonatomic) NSString *savePath;

@property (strong, nonatomic) UIButton *button;

@property (nonatomic, assign) NSInteger maxCount;
///读取始化
- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)array;
//获得图片地址

- (NSString *)fetchPhoto:(NSString *)filename imageUtil:(ImageUtil *)imageUtil;
@end
