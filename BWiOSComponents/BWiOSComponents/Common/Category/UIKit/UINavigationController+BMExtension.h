//
//  UINavigationController+BMExtension.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/29.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (BMExtension)

/** 默认导航条样式，蓝色图片为导航条背景 */
+ (instancetype)bmB2B_defaultStyleWithRootViewController:(UIViewController *)rootViewController;

/** 创建自定义的导航条 */
+ (instancetype)bm_rootViewController:(UIViewController *)rootViewController
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                           barBgImage:(UIImage *)barBgImage
                      bottomLineColor:(UIColor *)bottomLineColor
                     bottomLineHeight:(CGFloat)bottomLineHeight;

/** 创建自定义的导航条，会隐藏底部线条 */
+ (instancetype)bm_rootViewController:(UIViewController *)rootViewController
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                      barBgImageColor:(UIColor *)barBgImageColor
                      bottomLineColor:(UIColor *)bottomLineColor
                     bottomLineHeight:(CGFloat)bottomLineHeight;

@end
