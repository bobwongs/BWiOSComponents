//
//  BWAddressPickerView.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BWAddressPickerGetDataBlock)(NSUInteger selectedSection, NSUInteger selectedRow);

@interface BWAddressPickerView : UIView

@property (strong, nonatomic) NSMutableArray<NSArray<NSString *> *> *addressArrayM;  ///< Address array，成员对象为字符串数组类型
@property (strong, nonatomic) NSMutableArray<NSNumber *> *selectedIndexArray;  ///< 各级选中序列号的Array
@property (copy, nonatomic) BWAddressPickerGetDataBlock getDataBlock;  ///< Get data
@property (copy, nonatomic) void(^didSelectBlock)(NSMutableArray *selectedIndexArray);  ///< selected index array
@property (copy, nonatomic) void(^removeAddressArrayObjectBlock)(NSRange range);  ///< 移除addressArrayM成员对象

- (void)show;
- (void)dismiss;

- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray;  // 添加下一级地址数组

@end
