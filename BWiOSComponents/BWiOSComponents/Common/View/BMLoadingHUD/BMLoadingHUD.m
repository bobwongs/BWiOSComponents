//
//  BMLoadingHUD.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/30.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMLoadingHUD.h"
#import <FLAnimatedImage.h>

#define BM_LOADING_HUD_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define BM_LOADING_HUD_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BMLoadingHUD ()

@property (strong, nonatomic) FLAnimatedImageView *gifImageView;
@property (strong, nonatomic) FLAnimatedImage *gifImage;

@end

@implementation BMLoadingHUD

#pragma mark - Life Cycle

+ (BMLoadingHUD *)sharedInstance {
    static BMLoadingHUD *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setUI];
    });
    return sharedInstance;
}

#pragma mark - Public Method

+ (void)bmB2B_show {
    [self sharedInstance].userInteractionEnabled = NO;
    [self bm_showGifImage];
}

+ (void)bmB2B_noInteractionShow {
    [self sharedInstance].userInteractionEnabled = YES;
    [self bm_showGifImage];
}

+ (void)bm_setGifImage:(FLAnimatedImage *)gifImage {
    if (gifImage) [self sharedInstance].gifImageView.animatedImage = gifImage;
}

+ (void)bm_showGifImage {
    [self bm_show];
}

+ (void)bm_show {
    BMLoadingHUD *hud = [self sharedInstance];
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (hud.superview == keyWindow) return;  // 存在Loading
    
    [keyWindow addSubview:hud];
    [UIView animateWithDuration:.25 animations:^{
        hud.alpha = 1;
    }];
}

+ (void)bm_dismiss {
    [UIView animateWithDuration:.25 animations:^{
        [self sharedInstance].alpha = 0;
    } completion:^(BOOL finished) {
        [[self sharedInstance] removeFromSuperview];
    }];
}

#pragma mark - Private Method

- (void)setUI {
    self.frame = [UIScreen mainScreen].bounds;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:filePath]];
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    self.gifImageView = imageView;
    if (image) imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, 88.0, 88.0);
    imageView.center = CGPointMake(CGRectGetMidX(self.bounds) / 2, CGRectGetMidY(self.bounds) / 2);
    [self addSubview:imageView];
}

@end
