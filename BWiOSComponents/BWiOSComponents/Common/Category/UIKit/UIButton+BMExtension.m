//
//  UIButton+BMExtension.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/21.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "UIButton+BMExtension.h"
#import "UIImage+BMExtension.h"
#import <YYCategories/UIColor+YYAdd.h>

#define BM_BUTTON_COMMON_CORNER_RADIUS 4.0
#define BM_BUTTON3_COMMON_FONT [UIFont boldSystemFontOfSize:14.0]

@implementation UIButton (BMExtension)

+ (UIButton *)bmB2B_buttonWithType:(BMb2bButtonType)type {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button bmB2B_setButtonWithType:type];
    return button;
}

- (void)bmB2B_setButtonWithType:(BMb2bButtonType)type {
    switch (type) {
//        case BMb2bButtonType_btn1_1:
//            [self bm_setB2bButton1WithNormalBgGradientColorArray:BMb2b_brand_color1 highlightedBgColor:BMb2b_sub_color1 disabledBgColor:BMb2b_AFD0F8];
//            break;
//        case BMb2bButtonType_btn1_2:
//            [self bm_setB2bButton1WithNormalBgGradientColorArray:BMb2b_brand_color2 highlightedBgColor:[UIColor darkTextColor] disabledBgColor:BMb2b_F8C4AF];
//            break;
//        case BMb2bButtonType_btn2_1:
//            [self bm_setB2bButton2WithNormalBgGradientColorArray:BMb2b_brand_color1 highlightedBgColor:BMb2b_sub_color1 disabledBgColor:BMb2b_AFD0F8];
//            break;
//        case BMb2bButtonType_btn2_2:
//            [self bm_setB2bButton2WithNormalBgGradientColorArray:BMb2b_brand_color2 highlightedBgColor:[UIColor darkTextColor] disabledBgColor:BMb2b_F8C4AF];
//            break;
//        case BMb2bButtonType_btn3_1:
//            [self bm_setButtonWithTitleFont:BM_BUTTON3_COMMON_FONT titleColor:[UIColor whiteColor] normalBgGradientColorArray:BMb2b_brand_color2 highlightedBgColor:[UIColor darkTextColor] disabledBgColor:BMb2b_F8C4AF cornerRadius:BM_BUTTON_COMMON_CORNER_RADIUS borderColor:nil borderWidth:0];
//            break;
//        case BMb2bButtonType_btn3_2:
//            [self bm_setButtonWithTitleFont:BM_BUTTON3_COMMON_FONT titleColor:[UIColor darkTextColor] normalBgGradientColorArray:BMb2b_brand_white_colors highlightedBgColor:BMb2b_FFEDDF disabledBgColor:BMb2b_F8C4AF cornerRadius:BM_BUTTON_COMMON_CORNER_RADIUS borderColor:[UIColor darkTextColor] borderWidth:1.0];
//            break;
//        case BMb2bButtonType_btn3_3:
//            [self bm_setButtonWithTitleFont:BM_BUTTON3_COMMON_FONT titleColor:[UIColor whiteColor] normalBgGradientColorArray:BMb2b_brand_color1 highlightedBgColor:BMb2b_sub_color1 disabledBgColor:BMb2b_AFD0F8 cornerRadius:BM_BUTTON_COMMON_CORNER_RADIUS borderColor:nil borderWidth:0.0];
//            break;
//        case BMb2bButtonType_btn3_4:
//            [self bm_setButtonWithTitleFont:BM_BUTTON3_COMMON_FONT titleColor:BMb2b_sub_color1 normalBgGradientColorArray:BMb2b_brand_white_colors highlightedBgColor:BMb2b_DBECFF disabledBgColor:[UIColor whiteColor] cornerRadius:4.0 borderColor:BMb2b_sub_color1 borderWidth:1.0];
//            break;
    }
}

- (void)bm_setBackgroundGradientNormalImageWithColorArray:(NSArray<UIColor *> *)colorArray {
    [self bm_setBackgroundGradientNormalImageWithColorArray:colorArray size:CGSizeMake(1.0, 1.0)];
}

- (void)bm_setBackgroundGradientNormalImageWithColorArray:(NSArray<UIColor *> *)colorArray size:(CGSize)size {
    CGSize imgSize = size;
    if (ABS(imgSize.width - 0.0) < 1.0) imgSize.width = 1.0;
    if (ABS(imgSize.height - 0.0) < 1.0) imgSize.height = 1.0;
    
    [self setBackgroundImage:[UIImage bm_gradientImageWithColorArray:colorArray size:imgSize] forState:UIControlStateNormal];
}

- (void)bm_setB2bButton1WithNormalBgGradientColorArray:(NSArray<UIColor *> *)colorArray highlightedBgColor:(UIColor *)highlightedBgColor disabledBgColor:(UIColor *)disabledBgColor {
    [self bm_setButtonWithTitleFont:[UIFont boldSystemFontOfSize:16.0] titleColor:[UIColor whiteColor] normalBgGradientColorArray:colorArray highlightedBgColor:highlightedBgColor disabledBgColor:disabledBgColor cornerRadius:BM_BUTTON_COMMON_CORNER_RADIUS borderColor:nil borderWidth:0];
}

- (void)bm_setB2bButton2WithNormalBgGradientColorArray:(NSArray<UIColor *> *)colorArray highlightedBgColor:(UIColor *) highlightedBgColor disabledBgColor:(UIColor *)disabledBgColor {
    [self bm_setButtonWithTitleFont:[UIFont boldSystemFontOfSize:16.0] titleColor:[UIColor whiteColor] normalBgGradientColorArray:colorArray highlightedBgColor:highlightedBgColor disabledBgColor:disabledBgColor cornerRadius:0.0 borderColor:nil borderWidth:0];
}

- (void)bm_setButtonWithTitleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor normalBgGradientColorArray:(NSArray<UIColor *> *)colorArray highlightedBgColor:(UIColor *)highlightedBgColor disabledBgColor:(UIColor *)disabledBgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.titleLabel.font = titleFont;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIImage bm_imageWithColor:highlightedBgColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage bm_imageWithColor:disabledBgColor] forState:UIControlStateDisabled];
    
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
    }
    
    [self bm_setBackgroundGradientNormalImageWithColorArray:colorArray size:self.frame.size];
}

@end
