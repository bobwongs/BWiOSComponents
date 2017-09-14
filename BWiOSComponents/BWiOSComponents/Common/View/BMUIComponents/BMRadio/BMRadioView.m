//
//  BMRadioView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMRadioView.h"
#import <Masonry.h>

NSInteger const BMRadioViewFirstButtonTag = 100;
NSString *const BMRadioViewTriggleActionNotification = @"BMRadioViewTriggleActionNotification";  // 触发选择事件的通知，使用场景：选择时，取消键盘输入

@implementation BMRadioView

#pragma mark - Life Cycle

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray {
    return [self initWithTitleArray:titleArray disableArray:nil selectedTitle:nil];
}

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray disableArray:(NSArray<NSString *> *)disableArray selectedTitle:(NSString *)selectedTitle {
    if (self = [super init]) {
        [self setButtonsWithTitleArray:titleArray disableArray:disableArray selectedTitle:selectedTitle];
    }
    return self;
}

#pragma mark - Public Method

- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray {
    [self resetButtonsWithTitleArray:titleArray disableArray:nil selectedTitle:nil];
}

- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray selectedTitle:(NSString *)selectedTitle {
    [self resetButtonsWithTitleArray:titleArray disableArray:nil selectedTitle:selectedTitle];
}

- (void)resetButtonsWithTitleArray:(NSArray<NSString *> *)titleArray disableArray:(NSArray<NSString *> *)disableArray selectedTitle:(NSString *)selectedTitle {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setButtonsWithTitleArray:titleArray disableArray:disableArray selectedTitle:selectedTitle];
}

#pragma mark - Action

- (void)selectAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMRadioViewTriggleActionNotification object:self userInfo:nil];
    if (sender.selected) return;  // 已选中
    
    for (UIButton *button in self.subviews) {
        button.selected = NO;
    }
    
    sender.selected = YES;
    self.selectedIndex = sender.tag - BMRadioViewFirstButtonTag;
}

#pragma mark - Private Method

- (void)setButtonsWithTitleArray:(NSArray<NSString *> *)titleArray disableArray:(NSArray<NSString *> *)disableArray selectedTitle:(NSString *)selectedTitle {
    if (!titleArray || titleArray.count == 0) return;
    
    self.selectedIndex = -1;
    __block UIView *lastView = nil;
    [titleArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull radioTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = BMRadioViewFirstButtonTag + idx;
        [button setTitle:radioTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setImage:[UIImage imageNamed:@"bm_ui_components_radio_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bm_ui_components_radio_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"bm_ui_components_radio_disable"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        BOOL disable = NO;
        for (NSString *disableString in disableArray) {
            if ([disableString isEqualToString:radioTitle]) {
                disable = YES;
            }
        }
        
        if (disable) {
            button.enabled = NO;  // Disable
        } else {
            if (selectedTitle && [selectedTitle isEqualToString:radioTitle]) {
                button.selected = YES;  // !Disable && selectedTitle
                self.selectedIndex = idx;
            }
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        if (!lastView) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) { make.right.mas_equalTo(0); }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) { make.right.mas_equalTo(lastView.mas_left).offset(-8); }];
        }
        
        lastView = button;
    }];
}

@end
