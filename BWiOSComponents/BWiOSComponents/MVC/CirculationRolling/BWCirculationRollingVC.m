//
//  BWCirculationRollingVC.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/23.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWCirculationRollingVC.h"
#import <iCarousel.h>

@interface BWCirculationRollingVC () <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation BWCirculationRollingVC

- (instancetype)init {
    if (self = [super init]) {
        self.items = [@[@"1", @"2", @"3"] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self test_iCarousel];
}

- (void)test_iCarousel {
    self.carousel.type = iCarouselTypeLinear;
}

#pragma mark - iCarousel DataSource and Delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return view;
}

//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    switch (option)
//    {
//        case iCarouselOptionWrap:
//        {
//            return _wrap;
//        }
//        case iCarouselOptionFadeMax:
//        {
//            if (carousel.type == iCarouselTypeCustom)
//            {
//                return 0.0f;
//            }
//            return value;
//        }
//        case iCarouselOptionArc:
//        {
//            return 2 * M_PI * _arcSlider.value;
//        }
//        case iCarouselOptionRadius:
//        {
//            return value * _radiusSlider.value;
//        }
//        case iCarouselOptionTilt:
//        {
//            return _tiltSlider.value;
//        }
//        case iCarouselOptionSpacing:
//        {
//            return value * _spacingSlider.value;
//        }
//        default:
//        {
//            return value;
//        }
//    }
//}

@end
