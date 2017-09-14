//
//  BMAddToCartView.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/5.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMProductItemModel.h"
#import "BMCartProductInputView.h"

typedef void(^BMAddToCartViewDoneBlock)(NSInteger itemId, NSInteger addedCount);

@interface BMAddToCartView : UIView

+ (instancetype)instanceView;

@property (copy, nonatomic) BMAddToCartViewDoneBlock doneBlock;
@property (copy, nonatomic) dispatch_block_t cancelBlock;

- (void)showWithModel:(BMProductItemModel *)addressModel;
- (void)dismiss;

@end
