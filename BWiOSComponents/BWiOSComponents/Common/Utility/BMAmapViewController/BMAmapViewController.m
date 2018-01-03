//
//  BMAmapViewController.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/12/4.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "BMAmapViewController.h"
#import "BMAmapView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface BMAmapViewController ()

@end

@implementation BMAmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUI];
}

- (void)setUI {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    BMAmapView *mapView = [[BMAmapView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:mapView];
    
    // 高德地图坐标
    if (self.amapAnnotationArray) {
        mapView.annotationArray = self.amapAnnotationArray;
        return;
    }
    
    // 百度地图坐标
    if (!self.baiduAnnotationArray || self.baiduAnnotationArray.count == 0) return;
    NSMutableArray<MAPointAnnotation *> *annotationArrayM = [NSMutableArray new];
    [self.baiduAnnotationArray enumerateObjectsUsingBlock:^(MAPointAnnotation * _Nonnull annotation, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *amapAnnotation = [MAPointAnnotation new];
        amapAnnotation.coordinate = AMapCoordinateConvert(annotation.coordinate, AMapCoordinateTypeBaidu);
        amapAnnotation.title = annotation.title;
        amapAnnotation.subtitle = annotation.subtitle;
        [annotationArrayM addObject:amapAnnotation];
    }];
    mapView.annotationArray = annotationArrayM;
}

@end
