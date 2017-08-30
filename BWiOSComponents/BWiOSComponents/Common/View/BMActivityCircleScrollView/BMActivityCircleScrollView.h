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

- (void)setViewWithImages:(NSArray<UIImage *> *)imageArray selection:(BMActivityCircleScrollViewSelectionBlock)selectionBlock;

- (void)show;
- (void)showWithFrame:(CGRect)frame;
- (void)dismiss;

@end
