//
//  BMHomeActivityViewManager.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/25.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMHomeActivityViewManager.h"
#import "BMActivityCircleScrollViewManager.h"

@interface BMHomeActivityViewManager ()

@property (strong, nonatomic) BMActivityCircleScrollViewManager *circleScrollViewManager;

@end

@implementation BMHomeActivityViewManager

- (void)getActivityDataSource {
    // Get List
    
    // Finished, show circle scroll view, and than, set the selection page migrating block
    [self.circleScrollViewManager showWithURLs:@[] selectionBlock:^(NSInteger selectedIndex) {
        
    }];
}

- (BMActivityCircleScrollViewManager *)circleScrollViewManager {
    if (!_circleScrollViewManager) {
        _circleScrollViewManager = [BMActivityCircleScrollViewManager new];
    }
    return _circleScrollViewManager;
}

@end
