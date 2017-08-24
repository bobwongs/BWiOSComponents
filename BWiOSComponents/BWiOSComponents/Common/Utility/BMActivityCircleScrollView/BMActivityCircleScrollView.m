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

@interface BMActivityCircleScrollView () <UIScrollViewDelegate>

/* UI */
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) BMIndicatorWhitePointView *indicatorView;
@property (strong, nonatomic) UIButton *dismissBtn;

/* Data */
@property (copy, nonatomic) BMActivityCircleScrollViewSelectionBlock selectionBlock;

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
    if (self.scrollView.subviews.count == 0) return;  // 没有，则不显示
    
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

- (void)setViewWithImages:(NSArray<UIImage *> *)imageArray selection:(void (^)(NSInteger))selectionBlock {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.selectionBlock = selectionBlock;
    
    CGFloat width = 240, height = CGRectGetHeight(self.scrollView.frame);
    CGFloat space = (BM_ACTIVITY_CIRCLE_VIEW_SCREEN_WIDTH - width) / 2;
    __block CGFloat max_x = space;
    // 如果大于两张，需要把第一张添加到最后一张，暂不做这功能
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(max_x, 0, width, height)];
        imageView.tag = idx;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
        [self.scrollView addSubview:imageView];
        
        max_x = CGRectGetMaxX(imageView.frame) + space * 2;
    }];
    
    self.scrollView.contentSize = CGSizeMake(max_x - space, height);
    
    
    [self.indicatorView setViewWithPointCount:imageArray.count];
}

#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self dismiss];  // 点击跳转后需要隐藏
    if (self.selectionBlock) self.selectionBlock(gestureRecognizer.view.tag);
}

#pragma mark - Private Method

- (void)setUp {
    self.alpha = 0;
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.3;
    [self addSubview:_maskView];
    
    CGRect scrollViewFrame = CGRectMake(0, 94, BM_ACTIVITY_CIRCLE_VIEW_SCREEN_WIDTH, 360);
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    CGFloat pointWidth = 7;
    _indicatorView = [[BMIndicatorWhitePointView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollViewFrame) - 6 - pointWidth, 0, 0) pointWidth:pointWidth maxWidth:CGRectGetWidth(scrollViewFrame) centerX:(CGRectGetWidth(scrollViewFrame) / 2)];
    [self addSubview:_indicatorView];
    
    _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dismissBtn.frame = CGRectMake(0, CGRectGetMaxY(_scrollView.frame) + 10, 26.0, 26.0);
    _dismissBtn.center = CGPointMake(CGRectGetMidX(_scrollView.frame), CGRectGetMidY(_dismissBtn.frame));
    [_dismissBtn setImage:[UIImage imageNamed:@"icon_delete_white"] forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissBtn];
}

- (void)setIndicatorIndexWithScrollView:(UIScrollView *)scrollView {
    CGFloat x_end = scrollView.contentOffset.x;
    NSInteger selectedIndex = (x_end + 20) / CGRectGetWidth(scrollView.frame);  // 20的偏移
    self.indicatorView.selectedIndex = selectedIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setIndicatorIndexWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setIndicatorIndexWithScrollView:scrollView];
}

#pragma mark - Getter and Setter

@end
