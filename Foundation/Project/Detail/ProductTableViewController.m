//
//  ProductTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProductTableViewController.h"
#import "AJPhotoPickerGallery.h"
#import "SingletonObject.h"
#import "EMTextView.h"

@interface ProductTableViewController ()
@property (strong,nonatomic) NSString *pid;
//照片选择器
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
//产品功能
@property (weak, nonatomic) IBOutlet EMTextView *procDetailsTextView;
@end

@implementation ProductTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"product"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
//  Pager控件限制不得已，单例传值
    self.dataDict = [SingletonObject getInstance].dataDict;
    //    照片选择器
    NSArray *photoArray = [[StringUtil toString:self.dataDict[@"procShows"]] componentsSeparatedByString:@","];
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: photoArray];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 9;
    self.procDetailsTextView.text = [StringUtil toString:self.dataDict[@"procDetails"]];
    [self.pictureView addSubview:self.photoGallery];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the number of sections.
    if (indexPath.row == 0) {
        NSInteger imageCount = self.photoGallery.photos.count;
        CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
        CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
        return height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end
