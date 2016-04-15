//
//  AJPhotoPickerView.m
//  Foundation
//
//  Created by Dotton on 16/4/15.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AJPhotoPickerView.h"
#import "Global.h"

@implementation AJPhotoPickerView
- (instancetype)init {
    if (self == [super init]) {
        self.frame = CGRectMake(20, 40, SCREEN_WIDTH, 58.0);
        //上传按钮
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [button setImage:[[UIImage imageNamed:@"app_photo.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        button.frame = CGRectMake(0, 0, 58.0, 58.0);
        [self addSubview:button];
        [button addTarget:self action:@selector(multipleSelectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)multipleSelectionAction:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 15;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self.vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
//    [self.photos addObjectsFromArray:assets];
//    if (assets.count == 1) {
//        ALAsset *asset = assets[0];
//        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        self.imageView.image = tempImg;
//    } else {
//        CGFloat x = 0;
//        CGRect frame = CGRectMake(0, 0, 50, 50);
//        for (int i = 0 ; i < self.photos.count; i++) {
//            ALAsset *asset = self.photos[i];
//            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            frame.origin.x = x;
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//            [imageView setContentMode:UIViewContentModeScaleAspectFill];
//            imageView.clipsToBounds = YES;
//            imageView.image = tempImg;
//            imageView.tag = i;
//            imageView.userInteractionEnabled = YES;
//            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBig:)]];
//            [self.scrollView addSubview:imageView];
//            x += frame.size.width+5;
//        }
//        self.scrollView.contentSize = CGSizeMake(55 * self.photos.count, 0);
//    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //显示预览
    //    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:assets];
    //    photoBrowserViewController.delegate = self;
    //    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self.vc presentViewController: cameraUI animated: YES completion:nil];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
//    self.imageView.image = originalImage;
    
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
@end
