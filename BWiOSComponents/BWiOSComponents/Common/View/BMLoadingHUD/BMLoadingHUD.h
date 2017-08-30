//
//  BMLoadingHUD.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/30.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLAnimatedImage;

@interface BMLoadingHUD : UIView

+ (void)bmB2B_show;  ///< 默认响应用户点击
+ (void)bmB2B_noInteractionShow;  ///< 不响应用户点击

+ (void)bm_show;
+ (void)bm_setGifImage:(FLAnimatedImage *)gifImage;
+ (void)bm_showGifImage;
+ (void)bm_dismiss;

@end
