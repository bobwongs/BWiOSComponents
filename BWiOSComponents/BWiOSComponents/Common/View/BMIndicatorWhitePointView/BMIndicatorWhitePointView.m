//
//  BMIndicatorWhitePointView.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMIndicatorWhitePointView.h"

//#define BM_INDICATOR_WHITE_POINT_UIColorFromRGB(rgbValue) \
//[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
//blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
//alpha:1.0]
#define BM_INDICATOR_WHITE_POINT_COLOR [UIColor whiteColor]

@interface BMIndicatorWhitePointView ()

@property (assign, nonatomic) CGFloat pointWidth;
@property (assign, nonatomic) CGFloat maxWidth;
//@property (assign, nonatomic) CGFloat centerX;

@end

@implementation BMIndicatorWhitePointView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame pointWidth:(CGFloat)pointWidth maxWidth:(CGFloat)maxWidth {
    if (self = [self initWithFrame:frame]) {
        _pointWidth = pointWidth;
        _maxWidth = maxWidth;
//        _centerX = centerX;
        
        if (_pointWidth < 1.0) _pointWidth = 7.0;
    }
    return self;
}

#pragma mark - Public Method

- (void)setViewWithPointCount:(NSInteger)count {
    [self setViewWithPointCount:count selectedIndex:0];
}

- (void)setViewWithPointCount:(NSInteger)count selectedIndex:(NSInteger)index {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (count <= 1) return;  // Only one or zero, no need to show point.
    
    CGFloat max_x = 0, pointWidth = _pointWidth, space = 2;
    for (NSInteger i = 0; i < count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(max_x, 0, pointWidth, pointWidth)];
        view.tag = i;
        view.backgroundColor = BM_INDICATOR_WHITE_POINT_COLOR;
        view.layer.cornerRadius = pointWidth / 2;
        view.clipsToBounds = YES;
        [self addSubview:view];
        
        max_x = CGRectGetMaxX(view.frame) + space;
    }
    
    // Reframe
    CGFloat selfWidth = max_x - space;
    CGRect frame = self.frame;
    frame.size.width = (selfWidth < _maxWidth) ? selfWidth : _maxWidth;
    frame.size.height = pointWidth;  // height=width
    frame.origin.x = [UIScreen mainScreen].bounds.size.width - frame.size.width - 16;
    self.frame = frame;
//    self.center = CGPointMake(_centerX, CGRectGetMidY(self.frame));
    
    self.selectedIndex = index;
}

#pragma mark - Private Method

#pragma mark - Setter and Getter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        subview.alpha = 0.5;
        
        if (idx == selectedIndex) {
            subview.alpha = 1.0;
        }
    }];
}

@end
