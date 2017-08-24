//
//  BMActivityCircleScrollViewManager.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/24.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMActivityCircleScrollViewManager.h"
#import "BMActivityCircleScrollView.h"

@interface BMActivityCircleScrollViewManager ()

@property (strong, nonatomic) BMActivityCircleScrollView *circleScrollView;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation BMActivityCircleScrollViewManager

- (void)showViewWithArray:(NSArray *)dataSource {
    self.dataSource = dataSource;
    
    // To do
    // Download image
    
    // Finish downloading, set images to circleScrollView, implement block to target page.
    
    // Show
}

- (BMActivityCircleScrollView *)circleScrollView {
    if (!_circleScrollView) {
        _circleScrollView = [BMActivityCircleScrollView new];
    }
    return _circleScrollView;
}

@end
