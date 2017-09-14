//
//  UIScrollView+BMNoData.h
//  BWiOSComponents
//
//  Created by BobWong on 2016/12/6.
//  Copyright © 2016年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNoDataView.h"

typedef void(^BMNoDataViewCustomStyleBlock)(BMNoDataView *noDataView);

/**
 为 UIScrollView 添加空数据页的分类
 */
@interface UIScrollView (BMNoDataView)

/* 添加一个默认的空数据view */
- (void)bmB2B_showNoDataAndNoNetworkViewWithDataValid:(BOOL)dataValid reloadActionBlock:(dispatch_block_t)reloadActionBlock;
- (void)bmB2B_showNoDataAndNoNetworkViewWithDataValid:(BOOL)dataValid
                                           styleBlock:(BMNoDataViewCustomStyleBlock)styleBlock
                                    reloadActionBlock:(dispatch_block_t)reloadActionBlock;

- (void)bmB2B_addEmptyDataViewWithTapActionBlock:(dispatch_block_t)tapActionBlock;

/**
 添加一个自定义文字的空数据view
 @param title 文字
 @param tapActionBlock 点击回调
 */
- (void)bmB2B_addEmptyDataViewWithTitle:(NSString *)title tapActionBlock:(dispatch_block_t)tapActionBlock;

/**
 添加一个完全自定义文字的空数据view
 @param iconImagedName 图片名称
 @param title 文字
 @param buttonTitle 按钮文字
 @param tapActionBlock 点击回调
 */
- (void)bmB2B_addEmptyDataViewWithIconImagedName:(NSString *)iconImagedName
                                           title:(NSString *)title
                                     buttonTitle:(NSString *)buttonTitle
                                  tapActionBlock:(dispatch_block_t)tapActionBlock;

/** 显示无按钮的无数据图 */
- (void)bmB2B_addEmptyDataViewNoButtonWithIconImagedName:(NSString *)iconImagedName
                                                   title:(NSString *)title
                                          tapActionBlock:(dispatch_block_t)tapActionBlock;


/** 自定义无数据图样式 */
- (void)bmB2B_addEmptyDataViewWithStyleBlock:(BMNoDataViewCustomStyleBlock)styleBlock
                              tapActionBlock:(dispatch_block_t)tapActionBlock;

/** 网络断开通用页面 */
- (void)bmB2B_addNoNetworkViewWithTapActionBlock:(dispatch_block_t)tapActionBlock;

/**
 删除空数据页
 */
- (void)bmB2B_removeEmptyDataView;

@end
