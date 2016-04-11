//
//  LXPhotoPicker.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/11.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LXPhotoPicker.h"

@implementation LXPhotoPicker
- (instancetype)initWithParentView:(UIViewController *)vc{
    if (self = [super init]) {
        self.vc = vc;
    }
    return self;
}

/**upload img*/
//点选相片或拍照
- (void)selectPicture {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄图片",@"图片选择",nil];
    [sheet showInView:self.vc.view];
}
//点击选取or从本机相册选择的ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        [self takeOrSelectPhoto:UIImagePickerControllerSourceTypeCamera];
    } else if (1 == buttonIndex){
        [self takeOrSelectPhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}
//保存图片到沙盒
- (void)savePicture {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"something.jpg"]];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(self.imageOriginal)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
    if (result) {
        self.filePath = filePath;
    }
}

- (void)takeOrSelectPhoto:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.mediaTypes = mediaTypes;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self.vc presentViewController:picker animated:YES completion:nil];
}

//用户上传照片-取消操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    最原始的图
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //    先减半传到服务器
    UIImage *imageOriginal = [CommonUtil shrinkImage:image toSize:CGSizeMake(0.3*image.size.width, 0.3*image.size.height)];
    self.imageOriginal = imageOriginal;
    [picker dismissViewControllerAnimated:YES completion:^{
//        [self.headPictUrlButton setImage:self.imageOriginal forState:(UIControlStateNormal)];
        [self.delegate didSelectPhoto:self.imageOriginal];
        [self savePicture];
    }];
}
@end
