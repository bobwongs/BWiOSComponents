//
//  UITextView+BWAdd.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/14.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (BWAdd)

/* ---------- Place holder ---------- */
@property (nonatomic, readonly) UILabel *placeholderLabel;  //!< 提示文本Label
@property (nonatomic, strong) NSString *placeholder;  //!< 提示文本
@property (nonatomic, strong) UIColor *placeholderColor;  //!< 提示文本颜色
+ (UIColor *)bm_defaultPlaceholderColor;  //!< 获得默认提示文本的颜色

@end
