//
//  BWResearchViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWResearchViewController.h"
#import "BMSidesMenuView.h"
#import <Masonry.h>

@interface BWResearchViewController ()

@property (assign, nonatomic) BOOL show;  ///< Show

@property (strong, nonatomic) BMSidesMenuView *sidesMenuView;  ///< Sides menu view

@end

@implementation BWResearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor greenColor];
    self.show = YES;
    
    self.sidesMenuView = [BMSidesMenuView rightSideMenuViewWithDataSource:@[@"1", @"2", @"3"] hasSelectionStatus:YES selectedIndex:-1 didSelectBlock:^(NSInteger selectedIndex) {
        NSLog(@"selected index is %@", @(selectedIndex).stringValue);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(20, 200, 100, 50);
//    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"icon_arrow_right_gray_light"] forState:UIControlStateNormal];
    [button setTitle:@"添加衣物" forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 62 + 5 + 8, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8 + 10 + 8);
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    button.imageView.backgroundColor = [UIColor grayColor];
//    button.titleLabel.backgroundColor = [UIColor orangeColor];
    button.backgroundColor = [UIColor blueColor];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(200);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.text = @"hi";
    textField.frame = CGRectMake(20, 400, 200, 50);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textField];
}

- (void)buttonAction:(id)sender
{
    NSLog(@"1");
//    [self.sidesMenuView showRightSideMenuView];
    
    [BMSidesMenuView showNewRightSideMenuViewWithDataSource:@[@"1", @"2", @"3"] hasSelectionStatus:YES selectedIndex:-1 didSelectBlock:^(NSInteger selectedIndex) {
        NSLog(@"selected index is %@", @(selectedIndex).stringValue);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.subviews);
    
//    [BMSidesMenuView showNewRightSideMenuViewWithDataSource:@[@"1", @"2", @"3"] hasSelectionStatus:YES selectedIndex:-1 didSelectBlock:^(NSInteger selectedIndex) {
//        NSLog(@"selected index is %@", @(selectedIndex).stringValue);
//    }];
    
//    [self.sidesMenuView showRightSideMenuView];
}

@end
