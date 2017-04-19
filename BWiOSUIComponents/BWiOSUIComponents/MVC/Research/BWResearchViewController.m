//
//  BWResearchViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWResearchViewController.h"
#import "BMSidesMenuView.h"

@interface BWResearchViewController ()

@property (assign, nonatomic) BOOL show;  ///< Show

@property (strong, nonatomic) BMSidesMenuView *sidesMenuView;  ///< Sides menu view

@end

@implementation BWResearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.show = YES;
    
    self.sidesMenuView = [BMSidesMenuView new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.subviews);
    
    [BMSidesMenuView showNewRightSideMenuViewWithDataSource:@[@"1", @"2", @"3"] hasSelectionStatus:NO selectedIndex:1 didSelectBlock:^(NSInteger selectedIndex) {
        NSLog(@"selected index is %@", @(selectedIndex).stringValue);
    }];
}

@end
