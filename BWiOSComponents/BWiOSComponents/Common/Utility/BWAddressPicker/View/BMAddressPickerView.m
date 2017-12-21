//
//  BMAddressPickerView.m
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMAddressPickerView.h"
#import "BMAddressPickerCell.h"
#import "BWAddressPicker.h"
#import "BMAddressPickerAppearance.h"

#define BM_ADDRESS_PICKER_LINE_WIDTH (1 / [UIScreen mainScreen].scale)
#define BM_ADDRESS_PICKER_TIME_ANIMATION 0.25

#define BM_ADDRESS_PICKER_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define BM_ADDRESS_PICKER_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

CGFloat const BMAddressPickerTopViewHeight = 36.0;  // Top view height
CGFloat const BMAddressPickerBottomViewHeight = 244.0;   // Bottom table view height
CGFloat const BMAddressPickerHeight = BMAddressPickerTopViewHeight + BMAddressPickerBottomViewHeight;
CGFloat const BMAddressPickerCellHeight = 40.0;   // Cell height
CGFloat const BMAddressPickerHorizontalInset = 12.0;  // Button inset

NSInteger const BMAddressPickerSelectableCount = 3;  // 最多选三级

NSString *const BMAddressPickerCellId = @"BMAddressPickerCellId";

NSString *const BMAddressPickerTextToSelect = @"请选择";

NSInteger const BMAddressPickerFirstTableViewTag = 100;  // 第一个TableView的Tag值为100，之后的+1
NSInteger const BMAddressPickerFirstButtonTag = 200;  // 第一个Label的Tag值为200，为了找寻选中Label

@interface BMAddressPickerView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

/* UI */
@property (strong, nonatomic) UIView *shadowView;  ///< Shadow

@property (strong, nonatomic) UIView *selectionView;  ///< Selection view
@property (strong, nonatomic) UIScrollView *leftScrollView;  ///< ScrollView
//@property (strong, nonatomic) UIButton *cancelButton;  ///< Cancel button
@property (strong, nonatomic) UIView *lineView;  ///< Line
@property (strong, nonatomic) UIView *hightlightedBlockView;  ///< 选中的高亮块

@property (strong, nonatomic) UIScrollView *bottomScrollView;  ///< Bottom scroll view

/* Data */
@property (strong, nonatomic) NSMutableArray<NSArray<NSString *> *> *addressArrayM;  ///< Address array，成员对象为字符串数组类型
@property (strong, nonatomic) NSMutableArray<NSNumber *> *selectedIndexArray;  ///< 各级选中序列号的Array

@property (strong, nonatomic) NSMutableArray<NSString *> *selectedTitleMutableArray;  ///< Selected array
@property (strong, nonatomic) NSMutableArray *tableViewMutableArray;  ///< Table view array

@property (assign, nonatomic) NSInteger currentAddressIndex;  ///< 当前所在的选择序列，如省/市/区

@end

@implementation BMAddressPickerView

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
    [self showSelectionView:NO completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setAddressWithAddressArray:(NSArray<NSArray<NSString *> *> *)addressArray selectedIndexArray:(NSArray<NSNumber *> *)selectedIndexArray {
    if (!addressArray || addressArray.count == 0 || !selectedIndexArray || selectedIndexArray.count == 0 || addressArray.count < selectedIndexArray.count) return;  // 传入数组不能为空，选中的数组成员对象数量不能大于addressArray的成员数量
    
    [self.bottomScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.addressArrayM removeAllObjects];
    [self.selectedIndexArray removeAllObjects];
    [self.selectedTitleMutableArray removeAllObjects];
    // 使用此方式遍历增加，以addressArray的数量为标准，防止addressArray和selectedIndexArray成员对象不统一致使数据不和逻辑
    [addressArray enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull titleArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.addressArrayM addObject:titleArray];
        
        NSNumber *selectedIndexNumber = selectedIndexArray[idx];
        [self.selectedIndexArray addObject:selectedIndexNumber];
        [self.selectedTitleMutableArray addObject:titleArray[[selectedIndexNumber integerValue]]];
        [self addNextTableView];
    }];
    
    [self.selectedTitleMutableArray addObject:BMAddressPickerTextToSelect];  // 最后一个为“请选择”
    
    self.currentAddressIndex = self.addressArrayM.count - 1;
    [self refreshUIWithCurrentSelectedIndexAndShowSelectionTitle:NO];
}

// 添加选中的地址和下一级地址数组
- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray {
    if (newAddressArray.count == 0) {  // 下一级的数据为空，则直接完成选择
        [self refreshUIWithCurrentSelectedIndexAndShowSelectionTitle:NO];
        if (self.didSelectBlock) self.didSelectBlock(_selectedIndexArray);
        return;
    }
    
    if (_selectedTitleMutableArray.count == 0) {
        [_selectedTitleMutableArray addObject:BMAddressPickerTextToSelect];
    }
    
    [_addressArrayM addObject:newAddressArray];
    
    self.currentAddressIndex += 1;  // 页数+1
    [self addNextTableView];
    [self refreshUIWithCurrentSelectedIndex];
}

#pragma mark - Action

- (void)cancelAction:(id)sender
{
    if (self.cancelBlock) self.cancelBlock();
    [self dismiss];
}

- (void)selectTitleAction:(UIButton *)sender
{
    NSInteger selectedIndex = sender.tag - BMAddressPickerFirstButtonTag;
    
    [self makeBarScrollToIndex:selectedIndex];
    [self makeTableViewScrollToIndex:selectedIndex];
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tableViewIndex = tableView.tag - BMAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    return array ? array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMAddressPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:BMAddressPickerCellId];
    
    NSInteger row = indexPath.row;
    NSInteger tableViewIndex = tableView.tag - BMAddressPickerFirstTableViewTag;
    NSArray *array = _addressArrayM[tableViewIndex];
    NSNumber *number = (_selectedIndexArray.count > tableViewIndex) ? _selectedIndexArray[tableViewIndex] : nil;
    
    cell.titleLabel.text = array[row];
    
    BMAddressPickerAppearance *pickerAppearance = [BMAddressPickerAppearance appearance];
    BOOL isSelected = (number && number.integerValue == row);
    cell.titleLabel.textColor = isSelected ? pickerAppearance.textSelectedColor : pickerAppearance.textNormalColor;
    cell.iconImageView.hidden = !isSelected;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger tableViewIndex = tableView.tag - BMAddressPickerFirstTableViewTag;
    
    [self reselectAddressWithTableViewIndex:tableViewIndex selectedRow:row];  // 若为重选，则先进行移除
    
    [_selectedIndexArray addObject:@(row)];
    [self reloadTableViewWithIndex:tableViewIndex];
    
    // 显示用的Title，加在倒数第二个位置
    NSArray *array = _addressArrayM[tableViewIndex];
    [_selectedTitleMutableArray insertObject:array[row] atIndex:_selectedTitleMutableArray.count - 1];
    
    if (tableViewIndex == BMAddressPickerSelectableCount - 1) {
        // 设置最后一个Button
        [self setSelectedTitleButtonWithTag:tableViewIndex + BMAddressPickerFirstButtonTag title:array[row]];
        [self makeBarScrollToIndex:tableViewIndex];
        
        if (self.didSelectBlock) self.didSelectBlock(_selectedIndexArray);
        return;
    }
    
    if (self.getDataBlock) self.getDataBlock(tableViewIndex, row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 要做判断，不然TableView也会回调到这里
    if (scrollView == self.bottomScrollView) [self endBottomScrollViewAnimating];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 要做判断，不然TableView也会回调到这里
    if (scrollView == self.bottomScrollView) [self endBottomScrollViewAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) self.bottomScrollView.userInteractionEnabled = NO;
}

- (void)endBottomScrollViewAnimating {
    [self resetCurrentAddressIndexWithContentOffSetInBottomScrollView];
    self.bottomScrollView.userInteractionEnabled = YES;
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
    self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), BMAddressPickerHeight)];
    self.selectionView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width_cancel_button = 0;  // 取消按钮宽度为0，不显示取消按钮
    self.leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.selectionView.frame) - width_cancel_button, BMAddressPickerTopViewHeight)];
    
//    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.leftScrollView.frame), 0, width_cancel_button, BMAddressPickerTopViewHeight);
//    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.cancelButton setTitleColor:BM_ADDRESS_PICKER_333333 forState:UIControlStateNormal];
//    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame) - 1, CGRectGetWidth(self.selectionView.frame), 1)];
    self.lineView.backgroundColor = [BMAddressPickerAppearance appearance].lineColor;
    
    CGFloat height_block_view = 2;
    self.hightlightedBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, BMAddressPickerTopViewHeight - height_block_view, 0, height_block_view)];
    self.hightlightedBlockView.backgroundColor = [BMAddressPickerAppearance appearance].textSelectedColor;
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftScrollView.frame), CGRectGetWidth(self.selectionView.frame), BMAddressPickerBottomViewHeight)];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    // ---------- Selection view ----------
    
    
    [self addSubview:self.shadowView];
    [self addSubview:self.selectionView];
    
    [self.selectionView addSubview:self.leftScrollView];
//    [self.selectionView addSubview:self.cancelButton];
    [self.selectionView addSubview:self.lineView];
    [self.selectionView addSubview:self.hightlightedBlockView];
    [self.selectionView addSubview:self.bottomScrollView];
}

- (void)showSelectionView:(BOOL)show completion:(void (^ __nullable)(BOOL finished))completion {
    CGFloat y_picker_view = show ? (BM_ADDRESS_PICKER_SCREEN_HEIGHT - BMAddressPickerHeight) : BM_ADDRESS_PICKER_SCREEN_HEIGHT;
    
    CGRect frame = self.selectionView.frame;
    frame.origin.y = y_picker_view;
    [UIView animateWithDuration:BM_ADDRESS_PICKER_TIME_ANIMATION animations:^{
        self.selectionView.frame = frame;
    } completion:completion];
}

- (void)refreshUIWithCurrentSelectedIndex {
    [self refreshUIWithCurrentSelectedIndexAndShowSelectionTitle:YES];
}

- (void)refreshUIWithCurrentSelectedIndexAndShowSelectionTitle:(BOOL)showSelectionTitle {
    [_leftScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block CGFloat x_last = 8;
    [self.selectedTitleMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > BMAddressPickerSelectableCount - 1 || (!showSelectionTitle && [string isEqualToString:BMAddressPickerTextToSelect])) {
            // 限制可选择的层级数 || 不显示最后一个“请选择”时，结束循环
            *stop = YES;
            return;
        }
        
        // “请选择”、选中的地址、显示已选择地址颜色不同
        BMAddressPickerAppearance *pickerAppearance = [BMAddressPickerAppearance appearance];
        UIColor *titleColor;
        if ([string isEqualToString:BMAddressPickerTextToSelect]) {
            titleColor = pickerAppearance.textPromptColor;
        } else if (idx == _currentAddressIndex) {
            titleColor = pickerAppearance.textSelectedColor;
        } else {
            titleColor = pickerAppearance.textNormalColor;
        }
        
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CGFloat width_text = [[self class] widthForString:string font:font] + BMAddressPickerHorizontalInset * 2;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = BMAddressPickerFirstButtonTag + idx;
        button.frame = CGRectMake(x_last, 0, width_text, BMAddressPickerTopViewHeight);
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        button.titleLabel.font = font;
        [button addTarget:self action:@selector(selectTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, BMAddressPickerHorizontalInset, 0, BMAddressPickerHorizontalInset);
        [self.leftScrollView addSubview:button];
        
        x_last = CGRectGetMaxX(button.frame);
        self.leftScrollView.contentSize = CGSizeMake(x_last, 0);
    }];
    
    [self makeTableViewScrollToIndex:_currentAddressIndex];
    [self makeBarScrollToIndex:_currentAddressIndex];
}

// 让选中条滚动到指定的位置
- (void)makeBarScrollToIndex:(NSInteger)index {
    UIView *selectedView = [self.leftScrollView viewWithTag:BMAddressPickerFirstButtonTag + index];
    if (!selectedView) return;
    
    CGRect frame = _hightlightedBlockView.frame;
    frame.origin.x = selectedView.frame.origin.x + BMAddressPickerHorizontalInset;
    frame.size.width = selectedView.frame.size.width - BMAddressPickerHorizontalInset * 2;
    [UIView animateWithDuration:BM_ADDRESS_PICKER_TIME_ANIMATION animations:^{
        self.hightlightedBlockView.frame = frame;
    }];
    
    [self resetSelectedTitleColorIndex:index];
}

// 让TableView滚动到指定位置
- (void)makeTableViewScrollToIndex:(NSInteger)index {
    [self.bottomScrollView setContentOffset:CGPointMake(CGRectGetWidth(_bottomScrollView.frame) * index, 0) animated:YES];
}

- (void)addNextTableView {
    __block NSInteger nextTag = BMAddressPickerFirstTableViewTag;
    do {
        UITableView *tableView = [self.bottomScrollView viewWithTag:nextTag];
        if (!tableView) break;
        
        nextTag += 1;
    } while (nextTag < BMAddressPickerFirstTableViewTag + 100);  // 设置一个添加的上限
    
    NSInteger tableViewIndex = nextTag - BMAddressPickerFirstTableViewTag;  // TableView的序列，从0开始
    CGRect frame = CGRectMake(CGRectGetWidth(_bottomScrollView.frame) * tableViewIndex, 0, CGRectGetWidth(_bottomScrollView.frame), CGRectGetHeight(_bottomScrollView.frame));
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.tag = nextTag;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 40;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    NSBundle *bundle = [NSBundle bundleForClass:[BMAddressPickerCell class]];
//    NSURL *url = [bundle URLForResource:@"BMAddressPicker" withExtension:@"bundle"];
//    NSBundle *pickerBundle = [NSBundle bundleWithURL:url];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BMAddressPickerCell class]) bundle:nil] forCellReuseIdentifier:BMAddressPickerCellId];
    
    [_bottomScrollView addSubview:tableView];
    
    _bottomScrollView.contentSize = CGSizeMake(CGRectGetMaxX(tableView.frame), _bottomScrollView.contentSize.height);
}

- (void)reloadTableViewWithIndex:(NSInteger)index {
    UITableView *tableView = [_bottomScrollView viewWithTag:BMAddressPickerFirstTableViewTag + index];
    if (!tableView) return;
    
    [tableView reloadData];
}

// 重设Button文本和宽度，根据title的文本
- (void)setSelectedTitleButtonWithTag:(NSInteger)tag title:(NSString *)title {
    UIButton *button = [self.leftScrollView viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[BMAddressPickerAppearance appearance].textSelectedColor forState:UIControlStateNormal];
    CGRect frame = button.frame;
    frame.size.width = [[self class] widthForString:title font:button.titleLabel.font] + BMAddressPickerHorizontalInset * 2;
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

/** 重新选择已选的，先对之前的选择的数据做移除操作 */
- (void)reselectAddressWithTableViewIndex:(NSInteger)tableViewIndex selectedRow:(NSInteger)selectedRow {
    // ---------- 最后一级的选择 && 选择序列已经选满，先做移除操作 ----------
    if (tableViewIndex == BMAddressPickerSelectableCount - 1 && _selectedIndexArray.count == BMAddressPickerSelectableCount) {
        [_selectedIndexArray removeLastObject];  // 移除最后一个序列
        [_selectedTitleMutableArray removeObjectAtIndex:_selectedTitleMutableArray.count - 2];  // 移除倒数第二个Title
    }
    // ---------- 若选择为已选中，则跳转到下一页（按这种逻辑设计，下一页肯定是有数据的，如果为最后一页，则已经在上一个流程处理过了）；这里保险起见，再判断一次下一页的数据 ----------
    else if (tableViewIndex < _selectedIndexArray.count && selectedRow == _selectedIndexArray[tableViewIndex].integerValue && _addressArrayM.count > tableViewIndex + 1) {
        [self makeBarScrollToIndex:tableViewIndex + 1];
        [self makeTableViewScrollToIndex:tableViewIndex + 1];
        return;  // 下一页已有数据，直接做界面跳转操作即可
    }
    // ---------- 若为重新选择，而且选择不为已选中，则移除当前选择序列之后的所有原来已选择的，增加新的 ----------
    else if (tableViewIndex < _selectedIndexArray.count) {
        NSRange removedRange = NSMakeRange(tableViewIndex, _selectedIndexArray.count - tableViewIndex);
        NSRange addressArrayRemovedRange = NSMakeRange(tableViewIndex + 1, _addressArrayM.count - tableViewIndex - 1);  // 地址数据源的移除序列为从下一个开始，addressArrayM的成员对象个数来计数
        
        // 移除和重设bottomScrollView
        [_bottomScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NSLocationInRange(subview.tag - BMAddressPickerFirstTableViewTag, addressArrayRemovedRange)) {
                [subview removeFromSuperview];
            }
        }];
        [_bottomScrollView setContentOffset:CGPointMake(tableViewIndex * CGRectGetWidth(_bottomScrollView.frame), 0) animated:YES];
        _bottomScrollView.contentSize = CGSizeMake((tableViewIndex + 1) * CGRectGetWidth(_bottomScrollView.frame), _bottomScrollView.contentSize.height);
        
        // 移除Data
        [_selectedIndexArray removeObjectsInRange:removedRange];
        [_selectedTitleMutableArray removeObjectsInRange:removedRange];
        [_addressArrayM removeObjectsInRange:addressArrayRemovedRange];
        if (_removeAddressSourceArrayObjectBlock) _removeAddressSourceArrayObjectBlock(addressArrayRemovedRange);
        
        // 重设Title
        [self refreshUIWithCurrentSelectedIndex];
    }
}

/** 重置已选中Title的颜色，当前光标、其他已选中、请选择的颜色不同 */
- (void)resetSelectedTitleColorIndex:(NSInteger)index {
    for (UIButton *btn in self.leftScrollView.subviews) {
        if (![btn isKindOfClass:[UIButton class]]) continue;  // 修改目标类为UIButton
        if ([btn.titleLabel.text isEqualToString:BMAddressPickerTextToSelect]) continue;  // “请选择”颜色不变
        [btn setTitleColor:[BMAddressPickerAppearance appearance].textNormalColor forState:UIControlStateNormal];
    }
    
    UIButton *button = [self.leftScrollView viewWithTag:BMAddressPickerFirstButtonTag + index];
    if (![button isKindOfClass:[UIButton class]]) return;  // 修改目标类为UIButton
    if ([button.titleLabel.text isEqualToString:BMAddressPickerTextToSelect]) return;  // “请选择”颜色不变
    
    [button setTitleColor:[BMAddressPickerAppearance appearance].textSelectedColor forState:UIControlStateNormal];
}

#pragma mark - Getter and Setter

#pragma mark - Tool

+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font {
    CGSize sizeToFit = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    return ceilf(sizeToFit.width);
}

@end
