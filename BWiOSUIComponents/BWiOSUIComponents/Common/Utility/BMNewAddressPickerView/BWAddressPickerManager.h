//
//  BWAddressPickerManager.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWAddressModel;

typedef void(^BWAddressPickerManagerDidSelectBlock)(NSArray<BWAddressModel *> *);

@interface BWAddressPickerManager : NSObject

@property (copy, nonatomic) BWAddressPickerManagerDidSelectBlock didSelectBlock;

- (void)show;
- (void)dismiss;

@end
