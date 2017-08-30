//
//  BMActivityCircleScrollViewManager.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMActivityCircleScrollViewManager : NSObject

- (void)showWithURLs:(NSArray<NSURL *> *)urlArray selectionBlock:(void (^)(NSInteger))selectionBlock;

@end
