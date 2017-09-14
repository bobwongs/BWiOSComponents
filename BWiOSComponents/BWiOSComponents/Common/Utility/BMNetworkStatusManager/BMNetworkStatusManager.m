//
//  BMNetworkStatusManager.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/8.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMNetworkStatusManager.h"

@implementation BMNetworkStatusManager

+ (instancetype)sharedInstance
{
    static BMNetworkStatusManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMNetworkStatusManager alloc] init];
        [sharedInstance startMonitoring];
    });
    return sharedInstance;
}

- (void)startMonitoring {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _status = status;
    }];
}

@end
