//
//  BMSetNumberAlert.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/5.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BMSetNumberAlertConfirmBlock)(NSInteger count);

@interface BMSetNumberAlert : NSObject

- (void)showWithCount:(NSInteger)count;

@property (copy, nonatomic) BMSetNumberAlertConfirmBlock confirmBlock;
@property (copy, nonatomic) dispatch_block_t dismissBlock;

@end
