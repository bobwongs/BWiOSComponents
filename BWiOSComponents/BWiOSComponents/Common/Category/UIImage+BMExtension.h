//
//  UIImage+BMExtension.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/21.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BMExtension)

+ (UIImage *)bm_imageWithColor:(UIColor *)color;
+ (UIImage *)bm_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)bm_gradientImageWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size;

+ (UIImage *)bm_gradientImageFromLayer:(CALayer *)layer;

+ (UIImage *)bm_gradientImageWithSize:(CGSize)size
                           startColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint;

@end
