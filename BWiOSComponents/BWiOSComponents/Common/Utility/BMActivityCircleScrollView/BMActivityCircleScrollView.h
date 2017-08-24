//
//  BMActivityCircleScrollView.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BMActivityCircleScrollViewSelectionBlock)(NSInteger);

@interface BMActivityCircleScrollView : UIView

@property (assign, nonatomic) NSInteger selectedIndex;

+ (instancetype)viewWithImages:(NSArray<UIImage *> *)imageArray selection:(BMActivityCircleScrollViewSelectionBlock)selectionBlock;
//+ (instancetype)viewWithImageURLs:(NSArray<NSURL *> *)urlArray selection:(BMActivityCircleScrollViewSelectionBlock)selectionBlock;

- (void)setViewWithImages:(NSArray<UIImage *> *)imageArray selection:(BMActivityCircleScrollViewSelectionBlock)selectionBlock;
//- (void)setViewWithImageURLs:(NSArray<NSURL *> *)urlArray selection:(BMActivityCircleScrollViewSelectionBlock)selectionBlock;

- (void)show;
- (void)showWithFrame:(CGRect)frame;
- (void)dismiss;

@end
