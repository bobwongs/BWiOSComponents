# BWiOSUIComponents
iOS UI组件的开发

## 内容

- 概述
- UI组件的开发经验
- 仿京东地址选择器

## 概述

熟练实用的UI组件的开发，是iOS开发者必备的基础技能之一，要掌握扎实这方面的技能，才能更高效、轻松地胜任实践项目中的开发工作。

## UI组件的开发经验

#### 复杂的/高度自定制的/高可移植性的UI组件的封装经验

理解UI组件的设计，一定要多花时间在理解和设计上，不然只会需要更多的不确定的时间去解决问题，而且还不一定能解决

设计：架构/类结构、流程、接口

做接口设计，面向接口的编程，而不面向实现

减少依赖

对多次使用的常量、功能代码进行封装，方便进行统一的维护、减少不必要的代码冗余、提升代码质量

对大段的功能代码，进行抽出封装成方法，不影响对功能代码主流程的阅读，提升代码的可读性

开发实现的可视化，把设计、实现，记录下来

注释的书写，包括：核心框架，复杂流程、逻辑、核心参数，提高代码的可读性

#### 开发步骤

1. 熟悉和理解目标设计组件，UI和交互逻辑
2. UML设计，UI层、数据源层、操作层的设计，从整体到局部，先从整体进行设计，捋清、解决和重设计不合理的地方
3. 开发，搭框架 -> 具体实现
4. 自测
5. 完成

## 仿京东地址选择器

### 效果

![demo_address_selection](README/demo_address_selection.gif)

### 设计

#### 类结构

BWAddressPickerView 负责视图的展示、用户交互、根据数据源刷新显示内容

BWAddressPickerManager 负责获取数据源刷新视图，供外部进行使用

BWAddressSourceManager 负责从数据库获取数据源，本项目用本地获取数据源，也可以修改为从网络获取

#### 流程

**主流程：**

从数据库读取地址数据源 -> 用读取回来的数据源转换成供地址组件显示用的数据源 -> 

显示地址选择组件 -> 用户选择地址，记录选中序列 -> 

获取下一级的数据源，用数据源刷新显示内容 -> 

回到用户选择 -> 

完成所有选择，传出选中的地址模型数组，供调用者使用

**重新选择流程：**

先移除原来已选的数据，包括BWAddressPickerView和BWAddressPickerManager对应需要移除的数据 -> 

再添加用户新选择数据 -> 

回到主流程

#### 技术要点

数据结构的选用：数组。

包括，地址数据源为数组的数组、用户选中的地址也是用数组、UI展示，选中地址的Title和TableView也是用数组。

选中地址名称的实现，布局方式：Frame，为了更加方便做动画，每次选中对原来添加的显示名称组件进行移除，然后再重新添加，让底部的滚动条移动到对应的位置。

地址列表的TableView，每次新选中，不为最后一个层级，则添加下一个TableView，并且滚动到下一位置。

#### 接口设计

主要在BWAddressPickerView上

```objective-c
@interface BWAddressPickerView : UIView

@property (copy, nonatomic) void(^getDataBlock)(NSUInteger selectedSection, NSUInteger selectedRow);  ///< Get data.
@property (copy, nonatomic) void(^didSelectBlock)(NSMutableArray *selectedIndexArray);  ///< finish select index array.
@property (copy, nonatomic) void(^removeAddressSourceArrayObjectBlock)(NSRange range);  ///< Remove address source array object with given range.

- (void)show;
- (void)dismiss;

/**
 *  Add next level showed address array to select.
 */
- (void)addNextAddressDataWithNewAddressArray:(NSArray *)newAddressArray;

@end
```

#### 核心代码

选择

```objective-c
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger tableViewIndex = tableView.tag - BWAddressPickerFirstTableViewTag;
    
    // ---------- 最后一级的选择 && 选择序列已经选满，先做移除操作 ----------
    if (tableViewIndex == BWAddressPickerSelectableCount - 1 && _selectedIndexArray.count == BWAddressPickerSelectableCount) {
        [_selectedIndexArray removeLastObject];  // 移除最后一个序列
        [_selectedTitleMutableArray removeObjectAtIndex:_selectedTitleMutableArray.count - 2];  // 移除倒数第二个Title
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
        NSRange addressArrayRemovedRange = NSMakeRange(tableViewIndex + 1, _addressArrayM.count - tableViewIndex - 1);  // 地址数据源的移除序列为从下一个开始，addressArrayM的成员对象个数来计数
        
        // 移除和重设bottomScrollView
        [_bottomScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NSLocationInRange(subview.tag - BWAddressPickerFirstTableViewTag, addressArrayRemovedRange)) {
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
    
    [_selectedIndexArray addObject:@(row)];
    [self reloadTableViewWithIndex:tableViewIndex];
    
    // 显示用的Title，加在倒数第二个位置，最后一个为“请选择”
    NSArray *array = _addressArrayM[tableViewIndex];
    [_selectedTitleMutableArray insertObject:array[row] atIndex:_selectedTitleMutableArray.count - 1];
    
    if (tableViewIndex == BWAddressPickerSelectableCount - 1) {
        // 设置最后一个Button
        [self setTitleButtonWithTag:tableViewIndex + BWAddressPickerFirstButtonTag title:array[row]];
        [self makeBarScrollToIndex:tableViewIndex];
        
        if (self.didSelectBlock) self.didSelectBlock(_selectedIndexArray);
        return;
    }
    
    if (self.getDataBlock) self.getDataBlock(tableViewIndex, row);
}
```

