//
//  BMActivityCircleScrollView.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMActivityCircleScrollView : UIView

@property (assign, nonatomic) NSInteger selectedIndex;

- (instancetype)viewWithImages:(NSArray<UIImage *> *)imageArray selection:(void (^)(NSInteger index))selectionBlock;
- (instancetype)viewWithImageURLs:(NSArray<NSURL *> *)urlArray selection:(void (^)(NSInteger index))selectionBlock;

- (void)setViewWithImages:(NSArray<UIImage *> *)imageArray selection:(void (^)(NSInteger index))selectionBlock;
- (void)setViewWithImageURLs:(NSArray<NSURL *> *)urlArray selection:(void (^)(NSInteger index))selectionBlock;

- (void)show;
- (void)showWithFrame:(CGRect)frame;
- (void)dismiss;

@end
