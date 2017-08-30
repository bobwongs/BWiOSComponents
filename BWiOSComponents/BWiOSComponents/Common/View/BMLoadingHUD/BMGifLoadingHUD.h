//
//  BMGifLoadingHUD.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/30.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLAnimatedImage;

@interface BMGifLoadingHUD : UIView

+ (void)show;  ///< 默认响应用户点击
+ (void)showWithoutInteraction;  ///< 不响应用户点击
+ (void)dismiss;

+ (void)setGifImage:(FLAnimatedImage *)gifImage;

@end
