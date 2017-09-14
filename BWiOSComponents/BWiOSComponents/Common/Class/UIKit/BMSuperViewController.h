//
//  BMSuperViewController.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/17.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BMExtension.h"
#import "BMGifLoadingHUD.h"

//typedef NS_ENUM(NSInteger, BMPreloadingViewType) {
//    BMPreloadingViewTypeDefault,  // 默认为没有
//    BMPreloadingViewTypeColorView  // 单色图
//};

/**
 * B2B Mall基视图控制器，基类方法命名注意避免跟子类的命名冲突
 */
@interface BMSuperViewController : UIViewController

//@property (assign, nonatomic) BMPreloadingViewType preloadingViewType;  ///< 预加载图片样式
//@property (strong, nonatomic) UIView *preloadingView;  ///< 预加载View

- (void)bmB2B_backAction;

- (void)bmB2B_setDefaultNavigationBackItem;
- (void)bmB2B_setNavigationBackItemWithImage:(UIImage *)image;

- (void)bmB2B_hideBackButton;  ///< 隐藏返回按钮
- (void)bmB2B_enablePopGestureRecognizer;  ///< 开启手势右滑返回
- (void)bmB2B_disenablePopGestureRecognizer;  ///< 关闭手势右滑返回

@end
