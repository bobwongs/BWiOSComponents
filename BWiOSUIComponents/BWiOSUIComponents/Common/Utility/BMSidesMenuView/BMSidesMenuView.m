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
@property (strong, nonatomic) NSArray *dataSource;  ///< Data source

@property (copy, nonatomic) void(^didSelectBlock)(NSInteger);  ///< Did select menu item block

@end

@implementation BMSidesMenuView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Method

+ (void)showRightSideMenuViewWithDataSource:(NSArray *)array didSelectBlock:(void (^)(NSInteger))selectedBlock {
    [[BMSidesMenuView new] showWithDataSource:array didSelectBlock:selectedBlock];
}

- (void)showWithDataSource:(NSArray *)array didSelectBlock:(void (^)(NSInteger))selectedBlock {
    if (!array) return;
    self.dataSource = array;
    if (selectedBlock) self.didSelectBlock = selectedBlock;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.frame = [UIScreen mainScreen].bounds;
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
    }];
    [self removeFromSuperview];
}

#pragma mark - System Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMSidesMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdSidesMenu];
    if (!cell) {
        cell = [[BMSidesMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdSidesMenu];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.titleLabel.text = @"Title";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BM_SIDES_MENU_SCREEN_WIDTH - BM_SIDES_MENU_WIDTH, BM_SIDES_MENU_SCREEN_HEIGHT)];
        _maskView.backgroundColor = BM_SIDES_MENU_UIColorFromRGB(0x333333);
        _maskView.alpha = 0.0;
        
        // Tap to dismiss the view
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightSideMenuView)]];
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
    }
    return _tableView;
}

@end
