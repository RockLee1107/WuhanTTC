//
//  AJPhotoPickerView.m
//  Foundation
//
//  Created by Dotton on 16/4/15.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AJPhotoPickerGallery.h"
#import "Global.h"
#import "Masonry.h"
#import "CommonUtil.h"
#import "SVProgressHUD.h"

@implementation AJPhotoPickerGallery
///初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

///读取始化
- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)array {
    if (self == [super initWithFrame:frame]) {
        [self setup];
        [self loadPhotos:array];
    }
    return self;
}

- (void)setup {
    //上传按钮
    self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.button setImage:[[UIImage imageNamed:@"app_photo.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    self.button.frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH);
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(multipleSelectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.photosArrival = [NSMutableArray array];
    self.photosStrArray = [[NSMutableArray alloc] init];
}

- (void)loadPhotos:(NSArray *)array {
//    if ([array count] > 0) {
//        self.photosStrArray = [array mutableCopy];
//    }
    
    for (int i = 0; i < array.count; i++) {
        if (![[array objectAtIndex:i] isEqualToString:@""]) {
            [self.photosStrArray addObject:array[i]];
        }
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,array[i]];
//        [self.photosStrArray addObject:array[i]];
        UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:imageUrl]];
        if (cachedImage) {
            //已经下载
            [self.photos addObject:cachedImage];
        }else {
            //未下载 需要去下载 内部会处理 此图是否下载中
            currentImageUrl = imageUrl;
            [manager downloadWithURL:[NSURL URLWithString:imageUrl] delegate:self];
        }
    }
    [self reloadImagesList];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    //下载图片成功
    if ([imageManager webImageDownoaderWithUrl:[NSURL URLWithString:currentImageUrl]]) {
        [self.photos addObject:image];
        [self reloadImagesList];
        //        NSLog(@"当前 -- 下载图片成功");
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    //下载图片失败
    if ([imageManager webImageDownoaderWithUrl:[NSURL URLWithString:currentImageUrl]]) {
        NSLog(@"当前url 下载失败");
    }
}

//点击上传按钮
- (void)multipleSelectionAction:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = self.maxCount - self.photos.count;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self.vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark - PhotoPickerProtocol照片拾取器代理方法
//取消
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//选取了一张或多张照片回调
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    [self.photos addObjectsFromArray:[self assetsToImages:assets]];
    //新图
    [self.photosArrival addObjectsFromArray:[self assetsToImages:assets]];
    [self reloadImagesList];
    
    NSLog(@"已完成图片的选取");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点选了某张照片回调
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
//    NSLog(@"%s",__func__);
    
}

//反选了某张照片回调
- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset {
//    NSLog(@"%s",__func__);
}

//超过最大选择项时回调
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {
//    NSLog(@"%s",__func__);
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选%zi张",self.maxCount]];
    
}

//低于最低选择项时回调
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker {
//    NSLog(@"%s",__func__);
}

//点击拍照按钮
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

#pragma mark - AJPhotoBrowserDelegate图片浏览器代理方法
//图片浏览器中删除某张图片回调
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index {
//    [self reloadImagesList];
    NSInteger delIndex = 0;
    NSLog(@"--------\n%ld", [self.photosStrArray count]);
    //self.photosStrArray存放老图
    //删除新图
    if(index >= [self.photosStrArray count]){
        delIndex = index - self.photosStrArray.count;
        [self.photosArrival removeObjectAtIndex:delIndex];
    }
    //只从老图片中删除
    else if(index < self.photosStrArray.count){
        [self.photosStrArray removeObjectAtIndex:index];
    }
}

//点击图片浏览器完成按钮回调
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos {
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:photos];
    //新图
    [self.photosArrival removeAllObjects];
//    [self.photosArrival addObjectsFromArray:photos];
    [self reloadImagesList];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

//图片浏览器中保存图片到本地
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        NSLog(@"保存到相册成功");
    }else{
        NSLog(@"保存到相册出错%@", error);
    }
}

#pragma mark - UIImagePickerDelegate拍照代理方法
//拍照取消回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//拍照成功回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self.photos addObject:[self shrinked:originalImage]];
//    新图
    [self.photosArrival addObject:[self shrinked:originalImage]];
    [self reloadImagesList];
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 自身内部调用的方法
//刷新图集
- (void)reloadImagesList {
    for (UIView *uv in [self subviews]) {
        if ([uv isKindOfClass:[UIImageView class]]) {
            [uv removeFromSuperview];
        }
    }
    CGRect frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH);
    for (int i = 0 ; i < self.photos.count; i++) {
        UIImage *tempImg = self.photos[i];
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
    CGRect button_rect = self.button.frame;
    button_rect.origin.x = self.photos.count % 4 * IMAGE_WIDTH_WITH_PADDING;
    button_rect.origin.y = self.photos.count / 4 * IMAGE_WIDTH_WITH_PADDING;
    self.button.frame = button_rect;
    [self.vc viewDidAppear:YES];
}

///assets转为image
- (NSArray *)assetsToImages:(NSArray *)assets {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0 ; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [images addObject:[self shrinked:tempImg]];
    }
    return images;
}

///image压缩
- (UIImage *)shrinked:(UIImage *)image {
    //    压缩图片以上传服务器
    CGFloat imageWidth = 400;
    CGFloat imageHeight = image.size.height / image.size.width * imageWidth;
    return [CommonUtil shrinkImage:image toSize:CGSizeMake(imageWidth, imageHeight)];
}

//查看大图
- (void)showBig:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag;
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:self.photos index:index];
    photoBrowserViewController.delegate = self;
    [self.vc presentViewController:photoBrowserViewController animated:YES completion:nil];
}

//照片机能力判断
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
            }else {
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

//photos初始化
- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}


//获得图片地址
- (NSString *)fetchPhoto:(NSString *)filename imageUtil:(ImageUtil *)imageUtil {

    //存放所有的图片路径
    NSMutableString *allFilePath = [[NSMutableString alloc] init];
    self.savePath = [imageUtil savePicture:filename images:self.photosArrival];
    
    //老图
    if ([self.photosStrArray count] > 0) {
        [allFilePath appendFormat:@"%@", [self.photosStrArray componentsJoinedByString:@","]];
    }
    //添加了新图 且没有老图
    if (![self.savePath isEqualToString:@""] && [self.photosStrArray count] == 0) {
        [allFilePath appendFormat:@"%@", self.savePath];
    }
    //在有老图时添加了新图
    else if (![self.savePath isEqualToString:@""] && [self.photosStrArray count] > 0) {
        [allFilePath appendFormat:@",%@", self.savePath];
    }
    return allFilePath;
}

@end
