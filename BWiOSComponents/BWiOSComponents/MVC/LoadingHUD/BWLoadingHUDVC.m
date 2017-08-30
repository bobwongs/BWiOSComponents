//
//  BWLoadingHUDVC.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/30.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWLoadingHUDVC.h"
#import "BMGifLoadingHUD.h"

@interface BWLoadingHUDVC ()

@end

@implementation BWLoadingHUDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showHUD:(id)sender {
    [BMGifLoadingHUD show];
}

- (IBAction)showNoInteraction:(id)sender {
    [BMGifLoadingHUD showWithoutInteraction];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BMGifLoadingHUD dismiss];
    });
}

- (IBAction)dismiss:(id)sender {
    [BMGifLoadingHUD dismiss];
}

- (IBAction)touchAction:(id)sender {
    NSLog(@"has action");
}

@end
