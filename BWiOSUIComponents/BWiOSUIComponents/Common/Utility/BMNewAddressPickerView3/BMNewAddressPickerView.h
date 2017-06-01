//
//  BMNewAddressPickerView.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BMNewAddressPickerGetDataBlock)(NSUInteger selectedSection, NSUInteger selectedRow);

@interface BMNewAddressPickerView : UIView

@property (strong, nonatomic) NSMutableArray<NSArray *> *addressArrayM;  ///< Address array
@property (strong, nonatomic) NSMutableArray<NSNumber *> *selectedIndexArray;  ///< 各级选中序列号的Array
@property (copy, nonatomic) BMNewAddressPickerGetDataBlock getDataBlock;  ///< Get data
@property (copy, nonatomic) void(^didSelectBlock)(NSMutableArray *selectedIndexArray);  ///< selected index array

- (void)show;
- (void)dismiss;

- (void)setInitialSelectionStatus;  // 初始选择状态
- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray;  // 添加下一级地址数组

@end