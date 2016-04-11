//
//  LXPhotoPicker.h
//  Foundation
//
//  Created by HuangXiuJie on 16/4/11.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@protocol LXPhotoPickerDelegate
- (void)didSelectPhoto:(UIImage *)image;
@end
@interface LXPhotoPicker : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) NSString *filePath;
@property (strong, nonatomic) UIImage *imageOriginal;
@property (nonatomic,strong) id<LXPhotoPickerDelegate> delegate;
- (instancetype)initWithParentView:(UIViewController *)vc;
- (void)selectPicture;
@end