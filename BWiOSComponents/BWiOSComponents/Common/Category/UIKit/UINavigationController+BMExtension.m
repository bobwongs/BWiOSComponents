//
//  UINavigationController+BMExtension.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/29.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "UINavigationController+BMExtension.h"

@implementation UINavigationController (BMExtension)

+ (instancetype)bmB2B_defaultStyleWithRootViewController:(UIViewController *)rootViewController {
    UIImage *barBgImage = [self bm_imageWithNameArray:@[@"bm_navigation_bar_bg_image_320", @"bm_navigation_bar_bg_image_375", @"bm_navigation_bar_bg_image_414"]];  // Different screen size to different bg image
    return [self bm_rootViewController:rootViewController tintColor:nil barTintColor:nil titleColor:[UIColor whiteColor] titleFont:nil barBgImage:barBgImage bottomLineColor:nil bottomLineHeight:0];
}

+ (instancetype)bm_rootViewController:(UIViewController *)rootViewController
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                           barBgImage:(UIImage *)barBgImage
                      bottomLineColor:(UIColor *)bottomLineColor
                     bottomLineHeight:(CGFloat)bottomLineHeight {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    UINavigationBar *navigationBar = navigationController.navigationBar;
    
    if (tintColor) navigationBar.tintColor = tintColor;
    if (barTintColor) navigationBar.barTintColor = barTintColor;
    
    NSMutableDictionary *attribute = [NSMutableDictionary new];
    if (titleColor) attribute[NSForegroundColorAttributeName] = titleColor;
    if (titleFont) attribute[NSFontAttributeName] = titleFont;
    navigationBar.titleTextAttributes = attribute;
    
    if (barBgImage) {
        [navigationBar setBackgroundImage:barBgImage forBarMetrics:UIBarMetricsDefault];  // 会隐藏线条，需要加线则在Image上绘制
        navigationBar.shadowImage = [UIImage new];  // 设置shadowImage，避免在切换视图的时候导航条的渐变色会很突兀，因为没有背景图
        
        // 有背景图的情况下才设置线条
        if (bottomLineColor) {
            UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navigationBar.frame) - bottomLineHeight, [UIScreen mainScreen].bounds.size.width, bottomLineHeight)];
            bottomLineView.backgroundColor = bottomLineColor;
            [navigationBar addSubview:bottomLineView];
        }
    }
    
    return navigationController;
}

+ (instancetype)bm_rootViewController:(UIViewController *)rootViewController
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                      barBgImageColor:(UIColor *)barBgImageColor
                      bottomLineColor:(UIColor *)bottomLineColor
                     bottomLineHeight:(CGFloat)bottomLineHeight {
    UIImage *barBgImage = [self bm_imageWithColor:barBgImageColor size:CGSizeMake(1.0, 1.0)];
    return [self bm_rootViewController:rootViewController tintColor:tintColor barTintColor:barTintColor titleColor:titleColor titleFont:titleFont barBgImage:barBgImage bottomLineColor:bottomLineColor bottomLineHeight:bottomLineHeight];
}

#pragma mark - Tool

+ (UIImage *)bm_imageWithNameArray:(NSArray<NSString *> *)nameArray {
    NSString *barBgImageName;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (ABS(screenWidth - 320 < 1.0)) {
        barBgImageName = nameArray[0];
    }
    else if (ABS(screenWidth - 375 < 1.0)) {
        barBgImageName = nameArray[1];
    }
    else if (ABS(screenWidth - 414 < 1.0)) {
        barBgImageName = nameArray[2];
    }
    return [UIImage imageNamed:barBgImageName];
}

+ (UIImage *)bm_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
