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

const CGFloat BMSidesMenuMaskShowedAlpha = 0.1;
const NSTimeInterval BMSidesMenuAnimationDefaultTime = 0.25;
NSString *const kCellIdSidesMenu = @"kCellIdSidesMenu";

@interface BMSidesMenuView () <UITableViewDataSource, UITableViewDelegate>

/*
 UI
 */
@property (strong, nonatomic) UIView *maskView;  ///< Mask view
@property (strong, nonatomic) UITableView *tableView;  ///< Table view

/*
 Data
 */
@property (strong, nonatomic) NSArray<NSString *> *dataSource;  ///< Data source
@property (assign, nonatomic) BOOL hasSelectionStatus;  ///< Has selection status

@property (copy, nonatomic) void(^didSelectBlock)(NSInteger);  ///< Did select menu item block

@end

@implementation BMSidesMenuView

#pragma mark - Public Method

+ (void)showNewRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger))selectedBlock {
    id menuView = [[self alloc] initRightSideMenuViewWithDataSource:array hasSelectionStatus:hasSelectionStatus selectedIndex:selectedIndex didSelectBlock:selectedBlock];
    [menuView showRightSideMenuView];
}

+ (instancetype)rightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger))selectedBlock {
    id menuView = [[self alloc] initRightSideMenuViewWithDataSource:array hasSelectionStatus:hasSelectionStatus selectedIndex:selectedIndex didSelectBlock:selectedBlock];
    return menuView;
}

- (instancetype)initRightSideMenuViewWithDataSource:(NSArray<NSString *> *)array hasSelectionStatus:(BOOL)hasSelectionStatus selectedIndex:(NSInteger)selectedIndex didSelectBlock:(void (^)(NSInteger))selectedBlock {
    if (self = [super init]) {
        if (!array) return self;
        _dataSource = array;
        _hasSelectionStatus = hasSelectionStatus;
        _selectedIndex = selectedIndex;
        if (selectedBlock) _didSelectBlock = selectedBlock;
        
        self.frame = [UIScreen mainScreen].bounds;  // Set the frame.
    }
    return self;
}

- (void)showRightSideMenuView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in window.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            return;  // 已有，则不再显示
        }
    }
    
    [window addSubview:self];
    
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
    
    [UIView animateWithDuration:BMSidesMenuAnimationDefaultTime animations:^{
        self.maskView.alpha = BMSidesMenuMaskShowedAlpha;
        
        [[self class] reframeView:self.tableView withX:BM_SIDES_MENU_SCREEN_WIDTH - BM_SIDES_MENU_WIDTH];
    }];
}

- (void)dismissRightSideMenuView {
    [UIView animateWithDuration:BMSidesMenuAnimationDefaultTime animations:^{
        self.maskView.alpha = 0.0;
    
        [[self class] reframeView:self.tableView withX:BM_SIDES_MENU_SCREEN_WIDTH];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - System Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMSidesMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdSidesMenu];
    
    if (!self.hasSelectionStatus) {
        cell.showType = BMSidesMenuShowTypeNone;
    } else {
        cell.showType = (indexPath.row == self.selectedIndex) ? BMSidesMenuShowTypeSelected : BMSidesMenuShowTypeNotSelected;
    }
    
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.lineImageView.hidden = (indexPath.row == self.dataSource.count - 1) ? YES : NO;  // Hide the last one bottom line
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    if (self.didSelectBlock) self.didSelectBlock(indexPath.row);
    
    [self dismissRightSideMenuView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BM_SIDES_MENU_CELL_HEIGHT;
}

#pragma mark - Tool

+ (void)reframeView:(UIView *)view withX:(CGFloat)x {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

#pragma mark - Setter and Getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = BM_SIDES_MENU_UIColorFromRGB(0x333333);
        _maskView.alpha = 0.0;
        
        // Tap to dismiss the view
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightSideMenuView)]];
        [_maskView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightSideMenuView)]];  // Default direction is UISwipeGestureRecognizerDirectionRight
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(BM_SIDES_MENU_SCREEN_WIDTH, 0, BM_SIDES_MENU_WIDTH, BM_SIDES_MENU_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BMSidesMenuCell class] forCellReuseIdentifier:kCellIdSidesMenu];
        
        // Shadow
        _tableView.layer.shadowColor = BM_SIDES_MENU_UIColorFromRGB(0x333333).CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        _tableView.layer.shadowRadius = 6.0;
        _tableView.layer.shadowOpacity = 0.3;
        
        // Set header view to top distance
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BM_SIDES_MENU_WIDTH, 24.0)];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.tableView reloadData];
}

@end
