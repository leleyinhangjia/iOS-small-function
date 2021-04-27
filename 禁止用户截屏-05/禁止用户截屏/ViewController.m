//
//  ViewController.m
//  禁止用户截屏
//
//  Created by 949699582 on 2019/1/15.
//  Copyright © 2019 zhq. All rights reserved.
//

#import "ViewController.h"
#import <ShotBlocker.h>
#import <Photos/Photos.h>
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.针对当前控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}

//截屏操作的响应事件
- (void)screenShot{
    
    
    NSLog(@"用户截屏了");
//    [[ShotBlocker sharedManager] detectScreenshotWithImageBlock:^(UIImage *screenshot) {
//        NSLog(@"Screenshot! %@", screenshot);
//        self.imageView.image = screenshot;
////        [self.imageView setNeedsDisplay];
//    }];
    
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx == [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
    
}

- (void)dealloc{
    //移除所有通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除指定通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
