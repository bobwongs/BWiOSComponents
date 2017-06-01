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
CGFloat const BMNewAddressPickerVerticalInset = 20.0;  // Button inset

NSInteger const BMNewAddressPickerSelectableCount = 3;  // 最多选三级

NSString *const BMNewAddressPickerCellId = @"BMNewAddressPickerCellId";

NSString *const BMNewAddressPickerTextToSelect = @"请选择";

NSInteger const BMNewAddressPickerFirstTableViewTag = 100;  // 第一个TableView的Tag值为100，之后的+1
NSInteger const BMNewAddressPickerFirstButtonTag = 200;  // 第一个Label的Tag值为200，为了找寻选中Label

@interface BMNewAddressPickerView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

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
//- (void)setInitialSelectionStatus {
//    self.currentAddressIndex = 0;
//    [_selectedTitleMutableArray addObject:BMNewAddressPickerTextToSelect];
//    [self refreshUIWithCurrentSelectedIndex];
//    
//    UITableView *tableView = [self.bottomScrollView viewWithTag:100];
//    if (tableView) [tableView reloadData];
//}

// 添加选中的地址和下一级地址数组
- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray {
    if (_selectedTitleMutableArray.count == 0) {
        [_selectedTitleMutableArray addObject:BMNewAddressPickerTextToSelect];
    }
    
    [_addressArrayM addObject:newAddressArray];
    
    self.currentAddressIndex += 1;  // 页数+1
    [self addNextTableView];
    [self refreshUIWithCurrentSelectedIndex];
}

#pragma mark - Action

- (void)cancelAction:(id)sender
{
    [self dismiss];
}

- (void)selectTitleAction:(UIButton *)sender
{
    NSInteger selectedIndex = sender.tag - BMNewAddressPickerFirstButtonTag;
    
    [self makeBarScrollToIndex:selectedIndex];
    [self makeTableViewScrollToIndex:selectedIndex];
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tableViewIndex = tableView.tag - BMNewAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    return array ? array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMNewAddressPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:BMNewAddressPickerCellId];
    
    NSInteger row = indexPath.row;
    NSInteger tableViewIndex = tableView.tag - BMNewAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    NSNumber *number = (_selectedIndexArray.count > tableViewIndex) ? _selectedIndexArray[tableViewIndex] : nil;
    
    cell.titleLabel.text = array[row];
    cell.iconImageView.hidden = !(number && number.integerValue == row);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger tableViewIndex = tableView.tag - BMNewAddressPickerFirstTableViewTag;
    
    // ---------- 最后一级的选择 && 选择序列已经选满，先做移除操作 ----------
    if (tableViewIndex == BMNewAddressPickerSelectableCount - 1 && _selectedIndexArray.count == BMNewAddressPickerSelectableCount) {
        [_selectedIndexArray removeLastObject];  // 移除最后一个序列
        [_selectedTitleMutableArray removeObjectAtIndex:_selectedTitleMutableArray.count - 1];  // 移除倒数第二个Title
    }
    // ---------- 若选择为已选中，则跳转到下一页（按这种逻辑设计，下一页肯定是有数据的，如果为最后一页，则已经在上一个流程处理过了）；这里保险起见，再判断一次下一页的数据 ----------
    else if (tableViewIndex < _selectedIndexArray.count && row == _selectedIndexArray[tableViewIndex].integerValue && _addressArrayM.count > tableViewIndex + 1) {
        [self makeBarScrollToIndex:tableViewIndex + 1];
        [self makeTableViewScrollToIndex:tableViewIndex + 1];
        return;  // 下一页已有数据，直接做界面跳转操作即可
    }
    // ---------- 若为重新选择，而且选择不为已选中，则移除当前选择序列之后的所有原来已选择的，增加新的 ----------
    else if (tableViewIndex < _selectedIndexArray.count) {
        NSRange removedRange = NSMakeRange(tableViewIndex, _selectedIndexArray.count - tableViewIndex);
        NSRange addressArrayRemovedRange = NSMakeRange(tableViewIndex + 1, _selectedIndexArray.count - tableViewIndex - 1);  // 地址数据源的移除序列为从下一个开始
        
        // 移除和重设UI（先移除Data有可能UI还在用着Data，导致奔溃）
        
//        [self.leftScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (NSLocationInRange(subview.tag - BMNewAddressPickerFirstButtonTag, removedRange)) {
//                [subview removeFromSuperview];
//            }
//        }];
        
        [_bottomScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NSLocationInRange(subview.tag - BMNewAddressPickerFirstTableViewTag, addressArrayRemovedRange)) {
                [subview removeFromSuperview];
            }
        }];
        [_bottomScrollView setContentOffset:CGPointMake(tableViewIndex * CGRectGetWidth(_bottomScrollView.frame), 0) animated:YES];
        _bottomScrollView.contentSize = CGSizeMake((tableViewIndex + 1) * CGRectGetWidth(_bottomScrollView.frame), _bottomScrollView.contentSize.height);
        
        // 移除Data
        [_selectedIndexArray removeObjectsInRange:removedRange];
        [_selectedTitleMutableArray removeObjectsInRange:removedRange];
        [_addressArrayM removeObjectsInRange:addressArrayRemovedRange];
        if (_removeAddressArrayObjectBlock) _removeAddressArrayObjectBlock(addressArrayRemovedRange);
        
        [self refreshUIWithCurrentSelectedIndex];
    }
    
    [_selectedIndexArray addObject:@(row)];
    [self reloadTableViewWithIndex:tableViewIndex];
    
    // 显示用的Title，加在倒数第二个位置
    NSArray *array = _addressArrayM[tableViewIndex];
    [_selectedTitleMutableArray insertObject:array[row] atIndex:_selectedTitleMutableArray.count - 1];
    
    if (tableViewIndex == BMNewAddressPickerSelectableCount - 1) {
        // 设置最后一个Button
        [self setTitleButtonWithTag:tableViewIndex + BMNewAddressPickerFirstButtonTag title:array[row]];
        [self makeBarScrollToIndex:tableViewIndex];
        
        if (self.didSelectBlock) self.didSelectBlock(_selectedIndexArray);
        return;
    }
    
    if (self.getDataBlock) self.getDataBlock(tableViewIndex, row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) [self resetCurrentAddressIndexWithContentOffSetInBottomScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) [self resetCurrentAddressIndexWithContentOffSetInBottomScrollView];
}

#pragma mark - Private Method

- (void)initData
{
    self.currentAddressIndex = -1;
    
    self.selectedTitleMutableArray = [NSMutableArray new];
    self.tableViewMutableArray = [NSMutableArray new];
    self.addressArrayM = [NSMutableArray new];
    self.selectedIndexArray = [NSMutableArray new];
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
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame) - BM_NEW_ADDRESS_PICKER_LINE_WIDTH, CGRectGetWidth(self.selectionView.frame), BM_NEW_ADDRESS_PICKER_LINE_WIDTH)];
    self.lineView.backgroundColor = BM_NEW_ADDRESS_PICKER_UIColorFromRGB(0xcccccc);
    
    CGFloat height_block_view = 2;
    self.hightlightedBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, BMNewAddressPickerTopViewHeight - height_block_view, 0, height_block_view)];
    self.hightlightedBlockView.backgroundColor = [UIColor blueColor];
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame), CGRectGetWidth(self.selectionView.frame), BMNewAddressPickerBottomViewHeight)];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    // ---------- Selection view ----------
    
    
    [self addSubview:self.shadowView];
    [self addSubview:self.selectionView];
    
    [self.selectionView addSubview:self.leftScrollView];
    [self.selectionView addSubview:self.cancelButton];
    [self.selectionView addSubview:self.lineView];
    [self.selectionView addSubview:self.hightlightedBlockView];
    [self.selectionView addSubview:self.bottomScrollView];
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
    
    __block CGFloat x_last = 0;
    [self.selectedTitleMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CGFloat width_text = [[self class] widthForString:string font:font] + BMNewAddressPickerVerticalInset * 2;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = BMNewAddressPickerFirstButtonTag + idx;
        button.frame = CGRectMake(x_last, 0, width_text, BMNewAddressPickerTopViewHeight);
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:BM_NEW_ADDRESS_PICKER_333333 forState:UIControlStateNormal];
        button.titleLabel.font = font;
        [button addTarget:self action:@selector(selectTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, BMNewAddressPickerVerticalInset, 0, BMNewAddressPickerVerticalInset);
        [self.leftScrollView addSubview:button];
        
        x_last = CGRectGetMaxX(button.frame) + 5;
        self.leftScrollView.contentSize = CGSizeMake(x_last, 0);
    }];
    
    [self makeTableViewScrollToIndex:_currentAddressIndex];
    
    [self makeBarScrollToIndex:_currentAddressIndex];
}

// 让选中条滚动到指定的位置
- (void)makeBarScrollToIndex:(NSInteger)index {
    UIView *selectedView = [self.leftScrollView viewWithTag:BMNewAddressPickerFirstButtonTag + index];
    if (!selectedView) return;
    
    CGRect frame = _hightlightedBlockView.frame;
    frame.origin.x = selectedView.frame.origin.x + BMNewAddressPickerVerticalInset;
    frame.size.width = selectedView.frame.size.width - BMNewAddressPickerVerticalInset * 2;
    [UIView animateWithDuration:BM_NEW_ADDRESS_PICKER_TIME_ANIMATION animations:^{
        self.hightlightedBlockView.frame = frame;
    }];
}

// 让TableView滚动到指定位置
- (void)makeTableViewScrollToIndex:(NSInteger)index {
    [self.bottomScrollView setContentOffset:CGPointMake(CGRectGetWidth(_bottomScrollView.frame) * index, 0) animated:YES];
}

- (void)addNextTableView {
    __block NSInteger nextTag = BMNewAddressPickerFirstTableViewTag;
    do {
        UITableView *tableView = [self.bottomScrollView viewWithTag:nextTag];
        if (!tableView) break;
        
        nextTag += 1;
    } while (nextTag < BMNewAddressPickerFirstTableViewTag + 100);  // 设置一个添加的上限
    
    NSInteger tableViewIndex = nextTag - BMNewAddressPickerFirstTableViewTag;  // TableView的序列，从0开始
    CGRect frame = CGRectMake(CGRectGetWidth(_bottomScrollView.frame) * tableViewIndex, 0, CGRectGetWidth(_bottomScrollView.frame), CGRectGetHeight(_bottomScrollView.frame));
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.tag = nextTag;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 40;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[BMNewAddressPickerCell class] forCellReuseIdentifier:BMNewAddressPickerCellId];
    [_bottomScrollView addSubview:tableView];
    
    _bottomScrollView.contentSize = CGSizeMake(CGRectGetMaxX(tableView.frame), _bottomScrollView.contentSize.height);
}

- (void)reloadTableViewWithIndex:(NSInteger)index {
    UITableView *tableView = [_bottomScrollView viewWithTag:BMNewAddressPickerFirstTableViewTag + index];
    if (!tableView) return;
    
    [tableView reloadData];
}

// 重设Button文本和宽度，根据title的文本
- (void)setTitleButtonWithTag:(NSInteger)tag title:(NSString *)title {
    UIButton *button = [self.leftScrollView viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
    CGRect frame = button.frame;
    frame.size.width = [[self class] widthForString:title font:button.titleLabel.font] + BMNewAddressPickerVerticalInset * 2;
    button.frame = frame;
}

// 从BottomScrollView的contentOffSet上更新当前页数
- (void)resetCurrentAddressIndexWithContentOffSetInBottomScrollView {
    CGFloat x_end = self.self.bottomScrollView.contentOffset.x;
    NSInteger newCurrentIndex = (x_end + 20) / CGRectGetWidth(_bottomScrollView.frame);  // 20的偏移
    
    if (newCurrentIndex == _currentAddressIndex) return;
    self.currentAddressIndex = newCurrentIndex;
    [self makeBarScrollToIndex:newCurrentIndex];
}

#pragma mark - Getter and Setter

#pragma mark - Tool

+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font {
    CGSize sizeToFit = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    return ceilf(sizeToFit.width);
}

@end