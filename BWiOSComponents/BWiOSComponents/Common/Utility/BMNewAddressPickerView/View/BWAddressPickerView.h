//
//  BWAddressPickerView.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWAddressPickerView : UIView

@property (copy, nonatomic) void(^getDataBlock)(NSUInteger selectedSection, NSUInteger selectedRow);  ///< Get data.
@property (copy, nonatomic) void(^didSelectBlock)(NSMutableArray *selectedIndexArray);  ///< finish select index array.
@property (copy, nonatomic) void(^removeAddressSourceArrayObjectBlock)(NSRange range);  ///< Remove address source array object with given range.

- (void)show;
- (void)dismiss;

/** Add next level showed address array to select. */
- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray;

/** 设置选中地址 */
- (void)setAddressWithAddressArray:(NSArray<NSArray<NSString *> *> *)addressArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray;

@end
