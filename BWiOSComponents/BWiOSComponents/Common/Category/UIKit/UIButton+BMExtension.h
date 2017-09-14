//
//  UIButton+BMExtension.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/21.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 按钮类型定义，细分到按钮分类的子类，减少使用部分对按钮样式设置的重复性代码
 */
typedef NS_ENUM(NSInteger, BMb2bButtonType) {
    BMb2bButtonType_btn1_1 = 1,
    BMb2bButtonType_btn1_2,
    BMb2bButtonType_btn2_1,
    BMb2bButtonType_btn2_2,
    BMb2bButtonType_btn3_1,
    BMb2bButtonType_btn3_2,
    BMb2bButtonType_btn3_3,
    BMb2bButtonType_btn3_4
};

/**
 * UIButton的扩展，外部需要使用自定义按钮样式时，注意把Button样式在创建时设置为UIButtonTypeCustom
 */
@interface UIButton (BMExtension)

+ (UIButton *)bmB2B_buttonWithType:(BMb2bButtonType)type;

- (void)bmB2B_setButtonWithType:(BMb2bButtonType)type;

- (void)bm_setBackgroundGradientNormalImageWithColorArray:(NSArray<UIColor *> *)colorArray;
- (void)bm_setBackgroundGradientNormalImageWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size;

- (void)bm_setButtonWithTitleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor normalBgGradientColorArray:(NSArray<UIColor *> *)colorArray highlightedBgColor:(UIColor *)highlightedBgColor disabledBgColor:(UIColor *)disabledBgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
