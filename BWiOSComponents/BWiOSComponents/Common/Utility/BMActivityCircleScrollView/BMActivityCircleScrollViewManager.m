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

@property (strong, nonatomic) NSArray<NSURL *> *dataSource;
@property (copy, nonatomic) void(^selectionBlock)(NSInteger);

@end

@implementation BMActivityCircleScrollViewManager

#pragma mark - Public Method

- (void)showWithURLs:(NSArray<NSURL *> *)urlArray selectionBlock:(void (^)(NSInteger))selectionBlock {
    if (!urlArray || urlArray.count == 0) return;
    
    if ([self isTheSameDataSource:urlArray]) {
        [self.circleScrollView show];  // The same, show directedly.
        return;
    }
    
    self.dataSource = urlArray;
    self.selectionBlock = selectionBlock;
    
    NSMutableArray *imagesArrayM = [urlArray mutableCopy];  // Mutable array to edit
    [imagesArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSURL class]]) return;
        NSURL *url = (NSURL *)obj;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.absoluteString];  // Get cached
        if (image) imagesArrayM[idx] = image;
    }];
    if ([self showViewWithImages:imagesArrayM]) return;  // All object is images
    
    [imagesArrayM enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSURL class]]) return;
        
        NSURL *url = (NSURL *)obj;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            imagesArrayM[idx] = image;
            [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString completion:nil];  // To cache
            [self showViewWithImages:imagesArrayM];
        }];
    }];
}

#pragma mark - Private Method

- (BOOL)isTheSameDataSource:(NSArray<NSURL *> *)urlArray {
    if (!self.dataSource || self.dataSource.count == 0) return NO;
    for (NSInteger i = 0; i < urlArray.count; i++) {
        if (![urlArray[i].absoluteString isEqualToString:self.dataSource[i].absoluteString]) return NO;  // Use absolute string.
    }
    return YES;
}

/** Show view with image array with whether all object is UIImage instance */
- (BOOL)showViewWithImages:(NSArray *)imageArray {
    BOOL hasDownloaded = YES;
    for (id object in imageArray) {
        if (![object isKindOfClass:[UIImage class]]) {
            hasDownloaded = NO;
            break;
        }
    }
    if (!hasDownloaded) return NO;
    
    [self.circleScrollView setViewWithImages:imageArray selection:self.selectionBlock];
    [self.circleScrollView show];
    return YES;
}

#pragma mark - Setter and Getter

- (BMActivityCircleScrollView *)circleScrollView {
    if (!_circleScrollView) {
        _circleScrollView = [BMActivityCircleScrollView new];
    }
    return _circleScrollView;
}

@end
