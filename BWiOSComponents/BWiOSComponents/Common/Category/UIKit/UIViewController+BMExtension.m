//
//  UIViewController+BMExtension.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/8/22.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "UIViewController+BMExtension.h"
#import <YYCategories/NSString+YYAdd.h>

#define BM_EXTENSION_NAVIGATION_BAR_HEIGHT 44.0
#define BM_EXTENSION_NAVIGATION_ITEM_SPACE 12.0

@implementation UIViewController (BMExtension)

- (void)bmB2B_setNavigationLeftItemWithTitle:(NSString *)title {
    [self bmB2B_setNavigationLeftItemWithTitle:title action:nil];
}

- (void)bmB2B_setNavigationLeftItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [[self class] bm_buttonWithTitle:title titleColor:[UIColor whiteColor] titleFont:[UIFont boldSystemFontOfSize:16.0] target:self action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = [[self class] bm_arrayAddedFixedSpaceItemWithItemArray:@[item]];
}

- (void)bmB2B_hideNavigationLeftItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.leftBarButtonItems = @[item];
}

- (void)bmB2B_setNavigationRightItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [[self class] bm_buttonWithTitle:title titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:14.0] target:self action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = [[self class] bm_arrayAddedFixedSpaceItemWithItemArray:@[item]];
}

- (void)bmB2B_setNavigationRightItemWithTitle:(NSString *)title font:(UIFont *)font action:(SEL)action {
    UIButton *button = [[self class] bm_buttonWithTitle:title titleColor:[UIColor whiteColor] titleFont:font target:self action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = [[self class] bm_arrayAddedFixedSpaceItemWithItemArray:@[item]];
}

- (void)bmB2B_setNavigationRightItemWithIcon:(UIImage *)iconImage action:(SEL)action {
    if (!iconImage) return;
    
    NSArray<NSString *> *actionStringArray = action ? @[NSStringFromSelector(action)] : nil;
    [self bmB2B_setNavigationRightItemWithIconArray:@[iconImage] actionArray:actionStringArray];
}

- (void)bmB2B_setNavigationRightItemWithIconArray:(NSArray<UIImage *> *)iconArray actionArray:(NSArray<NSString *> *)actionStringArray {
    if (!iconArray || iconArray.count == 0) return;
    
    CGFloat max_x = 0.0, width = 24.0, barHeight = BM_EXTENSION_NAVIGATION_BAR_HEIGHT;
    UIView *customView = [[UIView alloc] init];
    
    for (NSInteger index = 0; index < iconArray.count; index++) {
        UIImage *iconImage = iconArray[index];
        if (!iconImage || ![iconImage isKindOfClass:[UIImage class]]) continue;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(max_x, (barHeight - width) / 2, width, width);
        [button setImage:iconArray[index] forState:UIControlStateNormal];
        [customView addSubview:button];
        
        if (actionStringArray && index <= actionStringArray.count - 1) {  // 有对应Action的
            SEL selector = NSSelectorFromString(actionStringArray[index]);
            if ([self respondsToSelector:selector]) [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];  // 添加事件
        }
        
        max_x = CGRectGetMaxX(button.frame) + BM_EXTENSION_NAVIGATION_ITEM_SPACE;
    }
    
    customView.frame = CGRectMake(0, 0, max_x - BM_EXTENSION_NAVIGATION_ITEM_SPACE, barHeight);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItems = [[self class] bm_arrayAddedFixedSpaceItemWithItemArray:@[item]];
}

- (void)bmB2B_hideNavigationRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.rightBarButtonItems = @[item];
}

#pragma mark - Tool

+ (UIButton *)bm_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action {
    CGFloat width = [[self class] sizeForText:title font:titleFont];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, BM_EXTENSION_NAVIGATION_BAR_HEIGHT);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    if (target && action) [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (NSArray<UIBarButtonItem *> *)bm_arrayAddedFixedSpaceItemWithItemArray:(NSArray<UIBarButtonItem *> *)itemArray {
    CGFloat spaceWidth = [UIScreen mainScreen].bounds.size.width > 413 ? (-20 + 12) : (-16 + 12);  // 直接在这里进行设置，不用在上面调整水平位置，5.5inch：-20，4.7inch：-16
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];  // 创建UIBarButtonSystemItemFixedSpace
    spaceItem.width = spaceWidth;  // 创建UIBarButtonSystemItemFixedSpace的Item，让BarButtonItem紧靠屏幕边缘
    NSArray *resultArray = [@[spaceItem] arrayByAddingObjectsFromArray:itemArray];
    return resultArray;
}

+ (CGSize)sizeForText:(NSString *)text font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    result = rect.size;
    result.width = ceil(result.width);
    result.height = ceil(result.height);
    return result;
}

+ (CGFloat)sizeForText:(NSString *)text font:(UIFont *)font {
    CGSize size = [text sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

@end
