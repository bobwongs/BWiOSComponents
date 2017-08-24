//
//  BMActivityCircleScrollView.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMActivityCircleScrollView.h"
#import "BMIndicatorWhitePointView.h"

#define BM_ACTIVITY_CIRCLE_VIEW_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define BM_ACTIVITY_CIRCLE_VIEW_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

CGFloat const BMActivityCircleScrollViewDefaultAnimationDuration = .25;

@interface BMActivityCircleScrollView ()

/* UI */
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) BMIndicatorWhitePointView *indicatorView;
@property (strong, nonatomic) UIButton *dismissBtn;

@end

@implementation BMActivityCircleScrollView

#pragma mark - View Life

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

#pragma mark - Public Method

- (void)show {
    [self showWithFrame:[UIScreen mainScreen].bounds];
    ;
}

- (void)showWithFrame:(CGRect)frame {
    self.frame = frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:BMActivityCircleScrollViewDefaultAnimationDuration animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:BMActivityCircleScrollViewDefaultAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private Method

- (void)setUp {
    self.alpha = 0;
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
    [self addSubview:_maskView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, BM_ACTIVITY_CIRCLE_VIEW_SCREEN_WIDTH, 360)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dismissBtn.frame = CGRectMake(0, CGRectGetMaxY(_scrollView.frame), 26.0, 26.0);
    _dismissBtn.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
    [_dismissBtn setImage:[UIImage imageNamed:@"icon_delete_white"] forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(dismissBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissBtn];
}

#pragma mark - Getter and Setter

- (BMIndicatorWhitePointView *)indicatorView {
    
}

@end
