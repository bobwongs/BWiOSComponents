//
//  BMSidesMenuView.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSTimeInterval BMSidesMenuAnimationDefaultTime;

@interface BMSidesMenuView : UIView

+ (void)showRightSideMenuViewWithDataSource:(NSArray *)array didSelectBlock:(void (^)(NSInteger))selectedBlock;

- (void)showWithDataSource:(NSArray *)array didSelectBlock:(void (^)(NSInteger))selectedBlock;

@end
