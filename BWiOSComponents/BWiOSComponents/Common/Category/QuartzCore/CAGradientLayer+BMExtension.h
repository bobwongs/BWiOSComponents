//
//  CAGradientLayer+BMExtension.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/18.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class UIColor;

@interface CAGradientLayer (BMExtension)

+ (CAGradientLayer *)bm_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size;

+ (CAGradientLayer *)bm_gradientLayerWithSize:(CGSize)size
                                   colorArray:(NSArray<UIColor *> *)colorArray
                                   startPoint:(CGPoint)startPoint
                                     endPoint:(CGPoint)endPoint;

+ (CAGradientLayer *)bm_gradientLayerWithSize:(CGSize)size
                                   startColor:(CGColorRef)startColorRef
                                     endColor:(CGColorRef)endColorRef
                                   startPoint:(CGPoint)startPoint
                                     endPoint:(CGPoint)endPoint;

@end
