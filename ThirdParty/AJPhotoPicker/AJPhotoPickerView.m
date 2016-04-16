//
//  AJPhotoPickerView.m
//  Foundation
//
//  Created by Dotton on 16/4/15.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AJPhotoPickerView.h"
#import "Global.h"
#import "Masonry.h"
#define IMAGE_WIDTH ((SCREEN_WIDTH) - 32) / 4.0 - 4
#define IMAGE_WIDTH_WITH_PADDING IMAGE_WIDTH + 5
@implementation AJPhotoPickerView
- (instancetype)init {
    if (self == [super init]) {
        self.frame = CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING);
        //上传按钮
        self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.button setImage:[[UIImage imageNamed:@"app_photo.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        self.button.frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH);
        [self addSubview:self.button];
        [self.button addTarget:self action:@selector(multipleSelectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
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

- (void)reloadImagesList {
    for (UIView *uv in [self subviews]) {
        if ([uv isKindOfClass:[UIImageView class]]) {
            [uv removeFromSuperview];
        }
    }
    CGRect frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH);
    for (int i = 0 ; i < self.photos.count; i++) {
        ALAsset *asset = self.photos[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        frame.origin.x = i % 4 * IMAGE_WIDTH + 5;
        frame.origin.y = i / 4 * IMAGE_WIDTH + 5;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.image = tempImg;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBig:)]];
        [self addSubview:imageView];
    }
    CGRect rect = self.frame;
    rect.size.height = (self.photos.count / 4 + 1) * IMAGE_WIDTH_WITH_PADDING;
    self.frame = rect;
    //    [self mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo((self.photos.count / 4 + 1) * IMAGE_WIDTH_WITH_PADDING);
    //    }];
//    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.photos.count % 4 * IMAGE_WIDTH_WITH_PADDING);
//        make.top.mas_equalTo(self.photos.count / 4 * IMAGE_WIDTH_WITH_PADDING);
//    }];
    CGRect button_rect = self.button.frame;
    button_rect.origin.x = self.photos.count % 4 * IMAGE_WIDTH_WITH_PADDING;
    button_rect.origin.y = self.photos.count / 4 * IMAGE_WIDTH_WITH_PADDING;
    self.button.frame = button_rect;
    
    [self.vc viewDidAppear:YES];
    
    //显示预览
    //    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:assets];
    //    photoBrowserViewController.delegate = self;
    //    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    [self.photos addObjectsFromArray:assets];
    [self reloadImagesList];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - AJPhotoBrowserDelegate

- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index {
    NSLog(@"%s",__func__);
}

- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos {
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:photos];
    [self reloadImagesList];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBig:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag;
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:self.photos index:index];
    photoBrowserViewController.delegate = self;
    [self.vc presentViewController:photoBrowserViewController animated:YES completion:nil];}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        NSLog(@"保存到相册成功");
    }else{
        NSLog(@"保存到相册出错%@", error);
    }
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
