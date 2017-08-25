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
    UIImage *image0 = [UIImage imageNamed:@"img_circle0"];
    UIImage *image1 = [UIImage imageNamed:@"img_circle1"];
    UIImage *image2 = [UIImage imageNamed:@"img_circle2"];
    
    NSURL *url0 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738748&di=439f993530bc4988b069e30e26f7548b&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F86%2F31%2F01300000339824126797317174085.jpg"];
    NSURL *url1 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738748&di=2b71b66affe1ac60843846ca15bf3fcc&imgtype=0&src=http%3A%2F%2Fimg17.3lian.com%2F201612%2F23%2Ffd203bb955cc47517bc4fc5eb979e815.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503573738747&di=dd7102e45e4348951c355ff7a95081ab&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fw22%2F38%2Fd%2F95.jpg"];
    
    [self.manager showWithURLs:@[url0, url1, url2] selectionBlock:^(NSInteger selectedIndex) {
        NSLog(@"in vc: %ld", (long)selectedIndex);
        
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.title = @"test";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAlert];
    });
}

- (IBAction)systemAlertAction:(id)sender {
    // 测试系统弹框对活动图的影响
    [self showAlert];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showView:nil];
    });
}

- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BMActivityCircleScrollViewManager *)manager {
    if (!_manager) {
        _manager = [BMActivityCircleScrollViewManager new];
    }
    return _manager;
}

@end
