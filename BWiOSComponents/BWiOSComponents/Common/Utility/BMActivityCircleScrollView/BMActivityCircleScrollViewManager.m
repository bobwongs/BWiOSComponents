//
//  BMActivityCircleScrollViewManager.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMActivityCircleScrollViewManager.h"
#import "BMActivityCircleScrollView.h"
#import <SDWebImageDownloader.h>
#import <SDImageCache.h>

@interface BMActivityCircleScrollViewManager ()

@property (strong, nonatomic) BMActivityCircleScrollView *circleScrollView;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation BMActivityCircleScrollViewManager

- (void)showViewWithArray:(NSArray *)dataSource {
    self.dataSource = dataSource;
    
    // To do
    // Download image
    
    // Finish downloading, set images to circleScrollView, implement block to target page.
    
    // Show
    UIImage *image0 = [UIImage imageNamed:@"img_circle0"];
    UIImage *image1 = [UIImage imageNamed:@"img_circle1"];
    UIImage *image2 = [UIImage imageNamed:@"img_circle2"];
    
    NSURL *url0 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738748&di=439f993530bc4988b069e30e26f7548b&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F86%2F31%2F01300000339824126797317174085.jpg"];
    NSURL *url1 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738748&di=2b71b66affe1ac60843846ca15bf3fcc&imgtype=0&src=http%3A%2F%2Fimg17.3lian.com%2F201612%2F23%2Ffd203bb955cc47517bc4fc5eb979e815.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738747&di=dd7102e45e4348951c355ff7a95081ab&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fw22%2F38%2Fd%2F95.jpg"];
    
    NSArray<NSURL *> *urlArray = @[url0, url1, url2];
    NSMutableArray *imagesArrayM = [urlArray mutableCopy];
    
    [imagesArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSURL class]]) return;
        NSURL *url = (NSURL *)obj;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.absoluteString];
        if (image) {
            imagesArrayM[idx] = image;
        }
    }];
    
    
    
//    __block 
    [imagesArrayM enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSURL class]]) return;
        
        NSURL *url = (NSURL *)obj;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            imagesArrayM[idx] = image;
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString completion:nil];  // Cache
            
            BOOL hasDownloaded = YES;
            for (id object in imagesArrayM) {
                if (![object isKindOfClass:[UIImage class]]) {
                    hasDownloaded = NO;
                    break;
                }
            }
            
            if (!hasDownloaded) return;
            
            [self.circleScrollView setViewWithImages:imagesArrayM selection:^(NSInteger index) {
                NSLog(@"index: %ld", (long)index);
            }];
            [self.circleScrollView show];
        }];
    }];
    
//    [self.circleScrollView setViewWithImages:@[image0, image1, image2] selection:^(NSInteger index) {
//        NSLog(@"index: %ld", (long)index);
//    }];
}

- (BMActivityCircleScrollView *)circleScrollView {
    if (!_circleScrollView) {
        _circleScrollView = [BMActivityCircleScrollView new];
    }
    return _circleScrollView;
}

@end
