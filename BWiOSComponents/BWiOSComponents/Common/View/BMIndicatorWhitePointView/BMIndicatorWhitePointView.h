//
//  BMIndicatorWhitePointView.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIndicatorWhitePointView : UIView

@property (assign, nonatomic) NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame pointWidth:(CGFloat)pointWidth maxWidth:(CGFloat)maxWidth;

- (void)setViewWithPointCount:(NSInteger)count;
- (void)setViewWithPointCount:(NSInteger)count selectedIndex:(NSInteger)index;

@end
