//
//  BMSidesMenuView.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSidesMenuView.h"
#import "BMSidesMenuCell.h"

#define BM_SIDES_MENU_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define BM_SIDES_MENU_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BMSidesMenuView () <UITableViewDataSource, UITableViewDelegate>

/*
 UI
 */
@property (strong, nonatomic) UIView *maskView;  ///< Mask view
@property (strong, nonatomic) UITableView *tableView;  ///< Table view

/*
 Data
 */
@property (strong, nonatomic) NSArray *dataSource;  ///< Data source

@end

@implementation BMSidesMenuView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Method

+ (void)showRightSideMenuViewWithDataSource:(NSArray *)array {
    ;
    [[BMSidesMenuView new] showWithDataSource:array];
}

- (void)showWithDataSource:(NSArray *)array {
    if (!array) return;
    self.dataSource = array;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
    [window addSubview:self.tableView];
}

#pragma mark - System Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    <#TableViewCell#> *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[<#TableViewCell#> alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    <#Code#>
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return <#CGFloat#>;
}

#pragma mark - Setter and Getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BM_SIDES_MENU_SCREEN_WIDTH - BM_SIDES_MENU_WIDTH, BM_SIDES_MENU_SCREEN_HEIGHT)];
        _maskView.backgroundColor = BM_SIDES_MENU_UIColorFromRGB(0x333333);
        _maskView.alpha = 0.1;
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(BM_SIDES_MENU_SCREEN_WIDTH - BM_SIDES_MENU_WIDTH, 0, BM_SIDES_MENU_WIDTH, BM_SIDES_MENU_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
