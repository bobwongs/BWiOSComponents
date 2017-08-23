//
//  BMNewAddressPicker.h
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMNewRegionModel.h"

@interface BMNewAddressPicker : NSObject

@property (copy, nonatomic) void(^didSelectBlock)(NSArray<BMNewRegionModel *> *selectedModelArray);  ///< Finish select callback block.

- (void)show;
- (void)dismiss;

/** 设置选中地址 */
- (void)setAddressWithSelectedAddressArray:(NSArray<BMNewRegionModel *> *)addressArray;

@end
