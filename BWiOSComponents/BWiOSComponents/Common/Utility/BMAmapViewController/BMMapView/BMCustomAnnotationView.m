//
//  BMCustomAnnotationView.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/11/30.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import "BMCustomAnnotationView.h"

#define naviButtonWidth 44
#define naviButtonHeight 74

@implementation BMNaviButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"icon_amap_naviBackgroundNormal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"icon_amap_naviBackgroundHighlighted"] forState:UIControlStateSelected];
        
        //imageView
        _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_amap_navi"]];
        [self addSubview:_carImageView];
        
        //label
        _naviLabel = [[UILabel alloc] init];
        _naviLabel.text = @"导航";
        _naviLabel.font = [_naviLabel.font fontWithSize:9];
        _naviLabel.textColor = [UIColor whiteColor];
        [_naviLabel sizeToFit];
        
        [self addSubview:_naviLabel];
    }
    
    return self;
}

#define kMarginRatio 0.1
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _carImageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) - CGRectGetHeight(_carImageView.frame) * (0.5 + kMarginRatio));
    
    _naviLabel.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) + CGRectGetHeight(_naviLabel.frame) * (0.5 + kMarginRatio));
}

@end

@implementation BMCustomAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        BMNaviButton *naviButton = [[BMNaviButton alloc] initWithFrame:(CGRectMake(0, 0, naviButtonWidth, naviButtonHeight))];
        [naviButton addTarget:self action:@selector(navigationAction) forControlEvents:UIControlEventTouchUpInside];
        self.leftCalloutAccessoryView = naviButton;
    }
    return self;
}

- (void)navigationAction {
    if (self.navigationBlock) self.navigationBlock();
}

@end
