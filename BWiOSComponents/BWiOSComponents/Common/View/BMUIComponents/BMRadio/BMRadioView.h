//
//  BMRadioView.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const BMRadioViewTriggleActionNotification;

@interface BMRadioView : UIView

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray;
- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray disableArray:(NSArray<NSString *> *)disableArray selectedTitle:(NSString *)selectedTitle;

- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray;
- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray selectedTitle:(NSString *)selectedTitle;
- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray disableArray:(NSArray<NSString *> *)disableArray selectedTitle:(NSString *)selectedTitle;

@property (assign, nonatomic) NSInteger selectedIndex;  ///< 选中的序列，-1表示没有选

@end
