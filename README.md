# BWiOSUIComponents
iOS UI组件

## 内容

- 概述
- 仿京东地址选择器
- UI组件的开发经验

## 概述

实用的UI控件/组件

## 仿京东地址选择器

### 效果

![demo_address_selection](README/demo_address_selection.gif)

### 设计

#### 类设计

BWAddressPickerView 负责视图的展示、交互、根据数据源刷新显示内容

BWAddressPickerManager 负责获取数据源刷新视图，供外部进行使用

BWAddressSourceManager 负责从数据库获取数据源，本项目用本地获取数据源，也可以修改为从网络获取

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

#### 流程



### 优化方向

对初始选择的支持

## UI组件的开发经验

复杂的/高度自定制的/高可移植性的UI控件的封装