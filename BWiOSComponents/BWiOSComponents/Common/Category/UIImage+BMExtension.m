//
//  UIImage+BMExtension.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/21.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "UIImage+BMExtension.h"
#import "CAGradientLayer+BMExtension.h"

@implementation UIImage (BMExtension)

+ (UIImage *)bm_gradientImageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)bm_gradientImageWithSize:(CGSize)size
                           startColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint {
    CAGradientLayer *layer = [CAGradientLayer bm_gradientLayerWithSize:size startColor:startColor.CGColor endColor:endColor.CGColor startPoint:startPoint endPoint:endPoint];
    return [self bm_gradientImageFromLayer:layer];
}

+ (UIImage *)bm_gradientImageWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size {
    CAGradientLayer *layer = [CAGradientLayer bm_gradientLayerWithColorArray:colorArray size:size];
    return [self bm_gradientImageFromLayer:layer];
}

+ (UIImage *)bm_imageWithColor:(UIColor *)color {
    return [self bm_imageWithColor:color size:CGSizeMake(1, 1)];
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
