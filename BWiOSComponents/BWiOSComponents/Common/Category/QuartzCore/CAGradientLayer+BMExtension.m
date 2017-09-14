//
//  CAGradientLayer+BMExtension.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/18.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "CAGradientLayer+BMExtension.h"
#import <UIKit/UIColor.h>

#define BMb2b_Gradient_Start_Point CGPointMake(0, 0)
#define BMb2b_Gradient_End_Point CGPointMake(1, 1)

@implementation CAGradientLayer (BMExtension)

+ (CAGradientLayer *)bm_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size {
    if (!colorArray || colorArray.count < 2) return [CAGradientLayer new];
    
    return [self  bm_gradientLayerWithSize:size startColor:colorArray.firstObject.CGColor endColor:colorArray.lastObject.CGColor startPoint:BMb2b_Gradient_Start_Point endPoint:BMb2b_Gradient_End_Point];
}

+ (CAGradientLayer *)bm_gradientLayerWithSize:(CGSize)size
                                   colorArray:(NSArray<UIColor *> *)colorArray
                                   startPoint:(CGPoint)startPoint
                                     endPoint:(CGPoint)endPoint {
    CAGradientLayer *gLayer = [[CAGradientLayer alloc] init];
    gLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gLayer.colors = colorArray;
    gLayer.startPoint = startPoint;
    gLayer.endPoint = endPoint;
    return gLayer;
}

+ (CAGradientLayer *)bm_gradientLayerWithSize:(CGSize)size
                                   startColor:(CGColorRef)startColorRef
                                     endColor:(CGColorRef)endColorRef
                                   startPoint:(CGPoint)startPoint
                                     endPoint:(CGPoint)endPoint {
    return [self bm_gradientLayerWithSize:size colorArray:@[(__bridge id)startColorRef, (__bridge id)endColorRef] startPoint:startPoint endPoint:endPoint];
}

@end
