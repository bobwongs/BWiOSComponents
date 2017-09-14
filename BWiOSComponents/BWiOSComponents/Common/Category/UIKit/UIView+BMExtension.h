//
//  UIView+BMExtension.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/21.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BMExtension)

- (void)bm_setGradientBackgroundWithColorArray:(NSArray<UIColor *> *)colorArray;
- (void)bm_setGradientBackgroundWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size;

/** Animation */
+ (void)bm_animateUpdateConstraintsInLayoutView:(UIView *)viewLayout toUpdateBlock:(void (^)(void))blockToUpdate;  ///< 刷新约束伴随动画

/** 由Xib加载view */
+ (instancetype)bm_viewFormXib;

@end
