//
//  BWAddressPickerManager.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWAddressModel;

@interface BWAddressPickerManager : NSObject

@property (copy, nonatomic) void(^didSelectBlock)(NSArray<BWAddressModel *> *selectedModelArray);  ///< Finish select callback block.

- (void)show;
- (void)dismiss;

/** 设置选中地址 */
- (void)setAddressWithSelectedAddressArray:(NSArray<BWAddressModel *> *)addressArray;

@end
