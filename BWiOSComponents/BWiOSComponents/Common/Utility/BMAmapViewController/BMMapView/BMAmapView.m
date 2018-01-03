//
//  BMAmapView.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/11/30.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "BMAmapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "BMCustomAnnotationView.h"
#import "BMMapNavigationTool.h"

@interface BMAmapView () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *locateButton;
//@property (nonatomic, strong) UIButton *zoomInButton;  ///< 放大
//@property (strong, nonatomic) UIButton *zoomOutButton;  ///< 缩小

@end

@implementation BMAmapView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - Action

- (void)locatingAction {
    self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
}

//- (void)zoomInAction {
//    double zoomLevel = self.mapView.zoomLevel;
//    zoomLevel += 1;
//    [self.mapView setZoomLevel:zoomLevel animated:YES];
//    [self refreshScalingButtons];
//}
//
//- (void)zoomOutAction {
//    double zoomLevel = self.mapView.zoomLevel;
//    zoomLevel -= 1;
//    [self.mapView setZoomLevel:zoomLevel animated:YES];
//    [self refreshScalingButtons];
//}

#pragma mark - Private Method

- (void)setUI {
    [self addSubview:self.mapView];
    
    CGFloat locBtnWidth = 40.0;
    UIButton *locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locateButton = locateButton;
    locateButton.frame = CGRectMake(10, CGRectGetMaxY(self.mapView.frame) - 30 - locBtnWidth, locBtnWidth, locBtnWidth);
    [locateButton setImage:[UIImage imageNamed:@"icon_amap_location"] forState:UIControlStateNormal];
    [locateButton addTarget:self action:@selector(locatingAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locateButton];
    
//    UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.zoomOutButton = zoomOutButton;
//    zoomOutButton.frame = CGRectMake(CGRectGetWidth(self.mapView.frame) - 10 - 30, CGRectGetHeight(self.mapView.frame) - 10 - 30, 30, 30);
//#warning 待填坑
//    [zoomOutButton setImage:[UIImage imageNamed:@"icon_discovery_selected"] forState:UIControlStateNormal];
//    [zoomOutButton setImage:[UIImage imageNamed:@"icon_discovery_selected"] forState:UIControlStateDisabled];
//    [zoomOutButton addTarget:self action:@selector(zoomOutAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:zoomOutButton];
//
//    UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.zoomInButton = zoomInButton;
//    zoomInButton.frame = CGRectMake(CGRectGetWidth(self.mapView.frame) - 10 - 30, CGRectGetMinX(zoomOutButton.frame) - 30, 30, 30);
//#warning 待填坑
//    [zoomInButton setImage:[UIImage imageNamed:@"icon_discovery_selected"] forState:UIControlStateNormal];
//    [zoomInButton setImage:[UIImage imageNamed:@"icon_discovery_selected"] forState:UIControlStateDisabled];
//    [zoomInButton addTarget:self action:@selector(zoomInAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:zoomInButton];
}

//- (void)refreshScalingButtons {
//    double zoomLevel = self.mapView.zoomLevel;
//    self.zoomInButton.enabled = zoomLevel < 20;
//    self.zoomOutButton.enabled = zoomLevel > 3;
//}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMCustomAnnotationView *annotationView = (BMCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        annotationView.navigationBlock = ^{
            [BMMapNavigationTool navigateFrom:mapView.userLocation to:annotation];
        };
        
        return annotationView;
    }
    return nil;
}

#pragma mark - Setter and Getter

- (MAMapView *)mapView {
    if (!_mapView) {
        ///初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        _mapView.delegate = self;
        _mapView.zoomLevel = 16;  // 初始缩放级别，参考微信
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
//        _mapView.showsCompass = NO;
    }
    return _mapView;
}

- (void)setAnnotationArray:(NSArray<MAPointAnnotation *> *)annotationArray {
    _annotationArray = annotationArray;
    [self.mapView addAnnotations:annotationArray];
    [self.mapView showAnnotations:annotationArray animated:YES];
    [self.mapView selectAnnotation:annotationArray.firstObject animated:YES];
}

@end
