//
//  BMSidesMenuView.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMSidesMenuView : UIView

+ (void)showNewRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger selectedIndex))selectedBlock;

- (void)showRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger selectedIndex))selectedBlock;
- (void)showRightSideMenuView;

@end
