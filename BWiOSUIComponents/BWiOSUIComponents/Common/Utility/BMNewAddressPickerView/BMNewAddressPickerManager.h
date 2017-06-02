//
//  BMNewAddressPickerManager.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMAddressModel;

typedef void(^BMAddressPickerManagerDidSelectBlock)(NSArray<BMAddressModel *> *);

@interface BMNewAddressPickerManager : NSObject

@property (copy, nonatomic) BMAddressPickerManagerDidSelectBlock didSelectBlock;

- (void)show;
- (void)dismiss;

@end
