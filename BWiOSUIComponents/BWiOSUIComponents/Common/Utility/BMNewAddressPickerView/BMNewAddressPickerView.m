//
//  BMNewAddressPickerView.m
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMNewAddressPickerView.h"
#import "BMNewAddressPickerCell.h"

#define BM_NEW_ADDRESS_PICKER_LINE_WIDTH (1 / [UIScreen mainScreen].scale)
#define BM_NEW_ADDRESS_PICKER_TIME_ANIMATION 0.25

#define BM_NEW_ADDRESS_PICKER_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define BM_NEW_ADDRESS_PICKER_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

CGFloat const BMNewAddressPickerTopViewHeight = 35.0;  // Top view height
CGFloat const BMNewAddressPickerBottomViewHeight = 240.0;   // Bottom table view height
CGFloat const BMNewAddressPickerHeight = BMNewAddressPickerTopViewHeight + BMNewAddressPickerBottomViewHeight;
CGFloat const BMNewAddressPickerCellHeight = 40.0;   // Cell height

NSInteger const BMNewAddressPickerSelectableCount = 3;  // 最多选三级

NSString *const BMNewAddressPickerCellId = @"BMNewAddressPickerCellId";

NSString *const BMNewAddressPickerTextToSelect = @"请选择";

NSInteger const BMNewAddressPickerFirstTableViewTag = 100;  // 第一个TableView的Tag值为100，之后的+1
NSInteger const BMNewAddressPickerFirstButtonTag = 200;  // 第一个Label的Tag值为200，为了找寻选中Label

@interface BMNewAddressPickerView () <UITableViewDataSource, UITableViewDelegate>

/* UI */
@property (strong, nonatomic) UIView *shadowView;  ///< Shadow

@property (strong, nonatomic) UIView *selectionView;  ///< Selection view
@property (strong, nonatomic) UIScrollView *leftScrollView;  ///< ScrollView
@property (strong, nonatomic) UIButton *cancelButton;  ///< Cancel button
@property (strong, nonatomic) UIView *lineView;  ///< Line
@property (strong, nonatomic) UIView *hightlightedBlockView;  ///< 选中的高亮块

@property (strong, nonatomic) UIScrollView *bottomScrollView;  ///< Bottom scroll view

/* Data */
@property (strong, nonatomic) NSMutableArray<NSString *> *selectedTitleMutableArray;  ///< Selected array
@property (strong, nonatomic) NSMutableArray *tableViewMutableArray;  ///< Table view array

@property (assign, nonatomic) NSInteger currentAddressIndex;  ///< 当前所在的选择序列，如省/市/区

@end

@implementation BMNewAddressPickerView

#pragma mark - View Life

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark - Public Method

- (void)show {
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [superView addSubview:self];
    
    [self showSelectionView:YES completion:nil];
}

- (void)dismiss {
    [self showSelectionView:YES completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 初始选择状态
- (void)setInitialSelectionStatus {
    self.currentAddressIndex = 0;
    [_selectedTitleMutableArray addObject:BMNewAddressPickerTextToSelect];
    [self makeBarScrollToIndex:0];
    
    UITableView *tableView = [self.bottomScrollView viewWithTag:100];
    if (tableView) [tableView reloadData];
}

// 添加选中的地址和下一级地址数组
- (void)addNextAddressDataWithSelectedTitle:(NSString *)selectedTitle newAddressArray:(NSArray *)newAddressArray {
    [_selectedTitleMutableArray insertObject:selectedTitle atIndex:_selectedTitleMutableArray.count - 1];  // 加在倒数第二个位置
    [_addressArrayM addObject:newAddressArray];
    
    [self ]
}

#pragma mark - Action

- (void)cancelAction:(id)sender
{
    [self dismiss];
}

- (void)selectTitleAction:(UIButton *)sender
{
    
}

#pragma mark - System Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tableViewIndex = tableView.tag - BMNewAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    return array ? array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMNewAddressPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:BMNewAddressPickerCellId];
    
    NSInteger tableViewIndex = tableView.tag - BMNewAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    NSNumber *number = _selectedIndexArray[tableViewIndex];
    NSInteger row = indexPath.row;
    
    cell.titleLabel.text = array[row];
    cell.selected = (number.integerValue == row);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Private Method

- (void)initData
{
    self.selectedTitleMutableArray = [NSMutableArray new];
    self.tableViewMutableArray = [NSMutableArray new];
    self.addressArrayM = [NSMutableArray new];
}

- (void)initUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.3;
    [self.shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)]];
    
    // ---------- Selection view ----------
    self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), BMNewAddressPickerHeight)];
    self.selectionView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width_cancel_button = 65;  // 取消按钮宽度
    self.leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.selectionView.frame) - width_cancel_button, BMNewAddressPickerTopViewHeight)];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.leftScrollView.frame), 0, width_cancel_button, BMNewAddressPickerTopViewHeight);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:BM_NEW_ADDRESS_PICKER_333333 forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame) - BM_NEW_ADDRESS_PICKER_LINE_WIDTH, CGRectGetWidth(self.selectionView.frame), BM_NEW_ADDRESS_PICKER_LINE_WIDTH)];
    self.lineView.backgroundColor = BM_NEW_ADDRESS_PICKER_UIColorFromRGB(0xcccccc);
    
    self.hightlightedBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
    self.hightlightedBlockView.backgroundColor = [UIColor blueColor];
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame), CGRectGetWidth(self.selectionView.frame), BMNewAddressPickerBottomViewHeight)];
    
    UITableView *firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bottomScrollView.frame), CGRectGetHeight(self.bottomScrollView.frame)) style:UITableViewStylePlain];
    firstTableView.tag = BMNewAddressPickerFirstTableViewTag;
    firstTableView.dataSource = self;
    firstTableView.delegate = self;
    firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [firstTableView registerClass:[BMNewAddressPickerCell class] forCellReuseIdentifier:BMNewAddressPickerCellId];
    // ---------- Selection view ----------
    
    
    [self addSubview:self.shadowView];
    [self addSubview:self.selectionView];
    
    [self.selectionView addSubview:self.leftScrollView];
    [self.selectionView addSubview:self.cancelButton];
    [self.selectionView addSubview:self.lineView];
    [self.selectionView addSubview:self.hightlightedBlockView];
    [self.selectionView addSubview:self.bottomScrollView];
    
    [self.bottomScrollView addSubview:firstTableView];
}

- (void)showSelectionView:(BOOL)show completion:(void (^ __nullable)(BOOL finished))completion {
    CGFloat y_picker_view = show ? (BM_NEW_ADDRESS_PICKER_SCREEN_HEIGHT - BMNewAddressPickerHeight) : BM_NEW_ADDRESS_PICKER_SCREEN_HEIGHT;
    
    CGRect frame = self.selectionView.frame;
    frame.origin.y = y_picker_view;
    [UIView animateWithDuration:BM_NEW_ADDRESS_PICKER_TIME_ANIMATION animations:^{
        self.selectionView.frame = frame;
    } completion:completion];
}

- (void)refreshUIWithCurrentSelectedIndex {
    [_leftScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block CGFloat x_last = 20;
    [self.selectedTitleMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CGFloat width_text = [[self class] widthForString:string font:font];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = BMNewAddressPickerFirstButtonTag + idx;
        button.frame = CGRectMake(x_last, 0, width_text, BMNewAddressPickerTopViewHeight);
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:BM_NEW_ADDRESS_PICKER_333333 forState:UIControlStateNormal];
        button.titleLabel.font = font;
        [button addTarget:self action:@selector(selectTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftScrollView addSubview:button];
        
        x_last = CGRectGetMaxX(button.frame) + 45;
        self.leftScrollView.contentSize = CGSizeMake(x_last, 0);
    }];
}

// 让选中条滚动到指定的位置
- (void)makeBarScrollToIndex:(NSInteger)index {
    UIView *selectedView = [self.leftScrollView viewWithTag:BMNewAddressPickerFirstButtonTag + index];
    if (!selectedView) return;
    
    CGRect frame = _hightlightedBlockView.frame;
    frame.origin.x = selectedView.frame.origin.x;
    frame.size.width = selectedView.frame.size.width;
    [UIView animateWithDuration:BM_NEW_ADDRESS_PICKER_TIME_ANIMATION animations:^{
        self.hightlightedBlockView.frame = frame;
    }];
}

#pragma mark - Getter and Setter

#pragma mark - Tool

+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font {
    CGSize sizeToFit = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    return ceilf(sizeToFit.width);
}

@end
