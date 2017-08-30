//
//  BMSidesMenuView.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Sides menu view
 */
@interface BMSidesMenuView : UIView

/**
 *  Show new right side menu view
 *
 *  @param array Data source array of NSString instance type
 *  @param hasSelectionStatus Whether has selection status, If has, set -1 means no selected item
 *  @param selectedIndex Original selected index
 *  @param selectedBlock Did select block
 */
+ (void)showNewRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger selectedIndex))selectedBlock;


/**
 *  Init a new right side menu view
 *
 *  @param array Data source array of NSString instance type
 *  @param hasSelectionStatus Whether has selection status, If has, set -1 means no selected item
 *  @param selectedIndex Original selected index
 *  @param selectedBlock Did select block
 */
- (instancetype)initRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger selectedIndex))selectedBlock;

/**
 *  The same as initRightSideMenuViewWithDataSource
 */
+ (instancetype)rightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger selectedIndex))selectedBlock;

/**
 *  Show the right side menu view
 */
- (void)showRightSideMenuView;

@property (assign, nonatomic) NSInteger selectedIndex;  ///< Set this value to change selected index

@end
