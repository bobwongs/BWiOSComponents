//
//  BWCirculationRollingVC.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/23.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWCirculationRollingVC.h"
#import "BMActivityCircleScrollViewManager.h"

@interface BWCirculationRollingVC ()

@property (strong, nonatomic) BMActivityCircleScrollViewManager *manager;

@end

@implementation BWCirculationRollingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)showView:(id)sender {
    [self.manager showViewWithArray:@[]];
}

- (BMActivityCircleScrollViewManager *)manager {
    if (!_manager) {
        _manager = [BMActivityCircleScrollViewManager new];
    }
    return _manager;
}

@end
