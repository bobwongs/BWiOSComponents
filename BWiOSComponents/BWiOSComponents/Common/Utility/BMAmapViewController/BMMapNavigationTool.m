//
//  BMMapNavigationTool.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/12/4.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "BMMapNavigationTool.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAAnnotation.h>

@implementation BMMapNavigationTool

#pragma mark - Public Method

+ (void)navigateFrom:(id<MAAnnotation>)fromAnnotation to:(id<MAAnnotation>)toAnnotation {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([self canOpenAmap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self amapNavigateFrom:fromAnnotation to:toAnnotation];
        }]];
    }
    if ([self canOpenBaiduMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self baiduMapNavigateFrom:fromAnnotation to:toAnnotation];
        }]];
    }
    if ([self canOpenQQMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self qqMapNavigateFrom:fromAnnotation to:toAnnotation];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"Apple 地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self appleNavigateFrom:fromAnnotation to:toAnnotation];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[[self class] currentViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Tool

/** Apple地图导航 */
+ (void)appleNavigateFrom:(id<MAAnnotation>)fromAnnotation to:(id<MAAnnotation>)toAnnotation {
    MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:toAnnotation.coordinate addressDictionary:nil]];
    toLocation.name = toAnnotation.title;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                MKLaunchOptionsShowsTrafficKey:@(YES)}];
}

/** 高德地图导航 */
+ (void)amapNavigateFrom:(id<MAAnnotation>)fromAnnotation to:(id<MAAnnotation>)toAnnotation {
    if (![self canOpenAmap]) return;
    
    CLLocationCoordinate2D fromCoordinate = fromAnnotation.coordinate;
    CLLocationCoordinate2D toCoordinate = toAnnotation.coordinate;
    NSString *applicationName = [self appName];
    NSString *schemeString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0", applicationName, fromCoordinate.latitude, fromCoordinate.longitude, fromAnnotation.title, toCoordinate.latitude, toCoordinate.longitude, toAnnotation.title];
    schemeString = [schemeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openWithSchemeString:schemeString];
}

+ (BOOL)canOpenAmap {
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        NSLog(@"未安装高德地图");
        return NO;
    }
    return YES;
}

/** 百度地图导航 */
+ (void)baiduMapNavigateFrom:(id<MAAnnotation>)fromAnnotation to:(id<MAAnnotation>)toAnnotation {
    if (![self canOpenBaiduMap]) return;
    
    CLLocationCoordinate2D toCoordinate = toAnnotation.coordinate;
    NSString *applicationName = [self appName];
    NSString *schemeString = [NSString stringWithFormat:@"baidumap://map/direction?destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02&src=%@", toCoordinate.latitude, toCoordinate.longitude, toAnnotation.title, applicationName];
    schemeString = [schemeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openWithSchemeString:schemeString];
}

+ (BOOL)canOpenBaiduMap {
    NSURL *scheme = [NSURL URLWithString:@"baidumap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        NSLog(@"未安装百度地图");
        return NO;
    }
    return YES;
}

/** 腾讯地图导航 */
+ (void)qqMapNavigateFrom:(id<MAAnnotation>)fromAnnotation to:(id<MAAnnotation>)toAnnotation {
    if (![self canOpenQQMap]) return;
    
    CLLocationCoordinate2D fromCoordinate = fromAnnotation.coordinate;
    CLLocationCoordinate2D toCoordinate = toAnnotation.coordinate;
    NSString *applicationName = [self appName];
    NSString *schemeString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&from=%@&tocoord=%f,%f&to=%@&coord_type=2&policy=0&referer=%@", fromCoordinate.latitude, fromCoordinate.longitude, fromAnnotation.title, toCoordinate.latitude, toCoordinate.longitude, toAnnotation.title, applicationName];
    schemeString = [schemeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openWithSchemeString:schemeString];
}

+ (BOOL)canOpenQQMap {
    NSURL *scheme = [NSURL URLWithString:@"qqmap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        NSLog(@"未安装腾讯地图");
        return NO;
    }
    return YES;
}

+ (void)openWithSchemeString:(NSString *)schemeString {
    NSURL *scheme = [NSURL URLWithString:schemeString];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {  // iOS10以后,使用新API
        [[UIApplication sharedApplication] openURL:scheme options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
    }
    else {  // iOS10以前,使用旧API
        [[UIApplication sharedApplication] openURL:scheme];
    }
}

+ (NSString *)appName {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
}

+ (UIViewController *)currentViewController {
    UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navRootVC = (UINavigationController *)rootVC;
        return navRootVC.viewControllers.lastObject;
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarRootVC = (UITabBarController *)rootVC;
        UIViewController *selectedVC = tabBarRootVC.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navSelectedVC = (UINavigationController *)selectedVC;
            return navSelectedVC.viewControllers.lastObject;
        }
        return selectedVC;
    }
    return rootVC;
}

@end
