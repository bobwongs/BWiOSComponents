//
//  BWAddressPicker.h
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWRegionModel.h"
#import "BMAddressSourceManager.h"

@interface BWAddressPicker : NSObject

@property (strong, nonatomic) BMAddressSourceManager *addressSourceManager;  ///< Address source manager
@property (copy, nonatomic) void(^didSelectBlock)(NSArray<BWRegionModel *> *selectedModelArray);  ///< Finish select callback block.
@property (nonatomic, copy) dispatch_block_t cancelBlock;  ///< Cancel action.

- (void)show;
- (void)dismiss;

/** 设置选中地址 */
- (void)setAddressWithSelectedAddressArray:(NSArray<BWRegionModel *> *)addressArray;

@end
