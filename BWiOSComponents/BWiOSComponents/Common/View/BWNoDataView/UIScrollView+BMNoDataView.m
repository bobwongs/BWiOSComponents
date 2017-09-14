//
//  UIScrollView+BMEmptyData.m
//  BWiOSComponents
//
//  Created by BobWong on 2016/12/6.
//  Copyright © 2016年 BobWongStudio. All rights reserved.
//

#import "UIScrollView+BMNoDataView.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import <AFNetworkReachabilityManager.h>
#import "BMNetworkStatusManager.h"

#pragma mark - BMEmptyData

@interface UIScrollView ()

@property (nonatomic, assign, setter=bm_setShowEmptyDataView:) BOOL bm_showEmptyDataView;

@end

@implementation UIScrollView (BMNoDataView)

#pragma mark -

#pragma mark - getters setters

- (BOOL)bm_showEmptyDataView {
    
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    if (!num) return NO;
    return [num boolValue];
}

- (void)bm_setShowEmptyDataView:(BOOL)bm_showEmptyDataView {
    
    objc_setAssociatedObject(self, @selector(bm_showEmptyDataView), @(bm_showEmptyDataView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 公有方法

- (void)bmB2B_addEmptyDataViewWithTapActionBlock:(dispatch_block_t)tapActionBlock {
    
    [self bmB2B_addEmptyDataViewWithIconImagedName:nil title:nil buttonTitle:nil tapActionBlock:tapActionBlock];
}

- (void)bmB2B_addNoNetworkViewWithTapActionBlock:(dispatch_block_t)tapActionBlock {
    [self bmB2B_addEmptyDataViewWithIconImagedName:@"network_disconnection" title:@"网络断开！" buttonTitle:@"点击重试" tapActionBlock:tapActionBlock];
}

- (void)bmB2B_addEmptyDataViewWithTitle:(NSString *)title tapActionBlock:(dispatch_block_t)tapActionBlock {
    
    [self bmB2B_addEmptyDataViewWithIconImagedName:nil title:title buttonTitle:nil tapActionBlock:tapActionBlock];
}

- (void)bmB2B_addEmptyDataViewWithIconImagedName:(NSString *)iconImagedName
                                           title:(NSString *)title
                                     buttonTitle:(NSString *)buttonTitle
                                  tapActionBlock:(dispatch_block_t)tapActionBlock {
    [self bmB2B_addEmptyDataViewWithStyleBlock:^(BMNoDataView *noDataView) {
        if (iconImagedName) noDataView.iconImageView.image = [UIImage imageNamed:iconImagedName];
        if (title) noDataView.titleLabel.text = title;
        if (buttonTitle) [noDataView.eventButton setTitle:buttonTitle forState:UIControlStateNormal];
    } tapActionBlock:tapActionBlock];
}

- (void)bmB2B_addEmptyDataViewNoButtonWithIconImagedName:(NSString *)iconImagedName
                                                   title:(NSString *)title
                                          tapActionBlock:(dispatch_block_t)tapActionBlock {
    [self bmB2B_addEmptyDataViewWithStyleBlock:^(BMNoDataView *noDataView) {
        if (iconImagedName) noDataView.iconImageView.image = [UIImage imageNamed:iconImagedName];
        if (title) noDataView.titleLabel.text = title;
        noDataView.eventButton.hidden = YES;
    } tapActionBlock:tapActionBlock];
}

- (void)bmB2B_addEmptyDataViewWithStyleBlock:(BMNoDataViewCustomStyleBlock)styleBlock
                              tapActionBlock:(dispatch_block_t)tapActionBlock {
    // 已添加 就删除 可以优化
    if (self.bm_showEmptyDataView) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[BMNoDataView class]]) {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    BMNoDataView *emptyDataView = [BMNoDataView emptyDataViewWithTapActionBlock:tapActionBlock];
    if (styleBlock) styleBlock(emptyDataView);
    [self addSubview:emptyDataView];
    
    [emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(self);
    }];
    self.bm_showEmptyDataView = YES;
}

- (void)bmB2B_removeEmptyDataView {
    
    // 已删除 return
    if (!self.bm_showEmptyDataView) {
        return;
    }

    self.bm_showEmptyDataView = NO;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[BMNoDataView class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

#pragma mark - 空数据页面和网络断开

- (void)bmB2B_showNoDataAndNoNetworkViewWithDataValid:(BOOL)dataValid reloadActionBlock:(dispatch_block_t)reloadActionBlock {
    [self bmB2B_showNoDataAndNoNetworkViewWithDataValid:dataValid styleBlock:nil reloadActionBlock:reloadActionBlock];
    
}

- (void)bmB2B_showNoDataAndNoNetworkViewWithDataValid:(BOOL)dataValid
                                           styleBlock:(BMNoDataViewCustomStyleBlock)styleBlock
                                    reloadActionBlock:(dispatch_block_t)reloadActionBlock {
    AFNetworkReachabilityStatus status = [BMNetworkStatusManager sharedInstance].status;
    if (status == AFNetworkReachabilityStatusNotReachable) {
        [self bmB2B_addNoNetworkViewWithTapActionBlock:reloadActionBlock];
    } else {
        if (dataValid) {
            [self bmB2B_removeEmptyDataView];
        } else {
            [self bmB2B_addEmptyDataViewWithStyleBlock:styleBlock tapActionBlock:reloadActionBlock];
        }
    }
}

@end
