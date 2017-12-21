//
//  BWAddressPicker.m
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BWAddressPicker.h"
#import "BMAddressPickerView.h"

@interface BWAddressPicker ()

/* UI */
@property (strong, nonatomic) BMAddressPickerView *pickerView;

/* Data */
@property (strong, nonatomic) NSMutableArray<NSArray<BMRegionModel *> *> *addressArray;  ///< 地址数据源

@end

@implementation BWAddressPicker

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self setData];
    }
    return self;
}

#pragma mark - Public Method

- (void)show {
    if (_addressArray.count > 0) {
        [self.pickerView show];
        return;
    }
    
    [self getRegionDataWithParentModel:nil];
}

- (void)dismiss {
    [self.pickerView dismiss];
}

- (void)setAddressWithSelectedAddressArray:(NSArray<BMRegionModel *> *)addressArray {
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:addressArray];
    for (BMRegionModel *model in addressArray) {
        if (model.dcode.length == 0 || model.dname.length == 0 || model.type.length == 0) [arrayM removeObject:model];  // 移除无效的选中序列
    }
    [self.addressSourceManager getSelectedAddressSourceWithRegionArray:arrayM];
}

- (void)setPickerViewSelectedArrayWithSelectedArray:(NSArray<BMRegionModel *> *)selectedArray DataSource:(NSArray<NSArray<BMRegionModel *> *> *)selectedDataSource {
    BOOL validValue = !selectedArray || selectedArray.count == 0 || !selectedDataSource || selectedDataSource.count == 0 ;
    if (validValue || selectedArray.count < selectedDataSource.count) {  // 数量不对等时，重新进行选择，如果需要支持数据源不相等时，也能有个初始选择状态，则需要重新设计，这种情况较少，暂时不处理
        [self show];
        return;
    }
    
    NSMutableArray<NSArray<NSString *> *> *namesArray = [NSMutableArray new];
    NSMutableArray<NSNumber *> *selectedNumberArray = [NSMutableArray new];

    [selectedDataSource enumerateObjectsUsingBlock:^(NSArray<BMRegionModel *> * _Nonnull modelArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [namesArray addObject:[[self class] getNameArrayWithModelArray:modelArray]];
    }];
    
    self.addressArray = [NSMutableArray arrayWithArray:selectedDataSource];

    [selectedDataSource enumerateObjectsUsingBlock:^(NSArray<BMRegionModel *> * _Nonnull modelArray, NSUInteger arrayIdx, BOOL * _Nonnull arrayStop) {
        [modelArray enumerateObjectsUsingBlock:^(BMRegionModel * _Nonnull model, NSUInteger modelIdx, BOOL * _Nonnull modelStop) {
            if ([model.dcode isEqualToString:selectedArray[arrayIdx].dcode]) {
                [selectedNumberArray addObject:@(modelIdx)];
            }
        }];
    }];

    [self.pickerView setAddressWithAddressArray:namesArray selectedIndexArray:selectedNumberArray];
    [self.pickerView show];
}

#pragma mark - Private Method

- (void)setData {
    self.addressArray = [NSMutableArray new];
}

- (void)getRegionDataWithParentModel:(BMRegionModel *)parentModel {
    NSArray *typeArray = BM_ADDRESS_TYPE_ARRAY;
    NSInteger typeIndex = _addressArray.count;
    if (typeIndex > typeArray.count - 1) return;
    
    [self.addressSourceManager getAddressSourceArrayWithParentCode:parentModel.dcode addressType:typeArray[typeIndex]];
}

- (void)addNextAddressData:(NSArray<BMRegionModel *> *)regionArray {
    if (regionArray && regionArray.count > 0) {  // 有数据才添加，跟PickerView中的数据保持一致
        [self.addressArray addObject:regionArray];
    }
    
    NSMutableArray *nameArray = [NSMutableArray new];
    [regionArray enumerateObjectsUsingBlock:^(BMRegionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.dname];
    }];
    
    [self.pickerView addNextAddressDataWithNewAddressArray:nameArray];  // 用数据去刷新pickerView
    
    // 第一次显示
    if (_addressArray.count == 1) {
        [self.pickerView show];
    }
}

+ (NSArray<NSString *> *)getNameArrayWithModelArray:(NSArray<BMRegionModel *> *)modelArray {
    NSMutableArray<NSString *> *nameArray = [NSMutableArray new];
    [modelArray enumerateObjectsUsingBlock:^(BMRegionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.dname];
    }];
    return nameArray;
}

#pragma mark - Setter and Getter

- (BMAddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [BMAddressPickerView new];

        __weak typeof(self) weakSelf = self;
        _pickerView.getDataBlock = ^(NSUInteger selectedSection, NSUInteger selectedRow) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            BMRegionModel *model = strongSelf.addressArray[selectedSection][selectedRow];
            [strongSelf getRegionDataWithParentModel:model];
        };
        
        _pickerView.removeAddressSourceArrayObjectBlock = ^(NSRange range) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.addressArray removeObjectsInRange:range];
        };
        
        _pickerView.didSelectBlock = ^(NSMutableArray *selectedIndexArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSLog(@"selected index array is %@", selectedIndexArray);
            
            // 选中的BMRegionModel添加进数组
            NSMutableArray *arrayM = [NSMutableArray new];
            [strongSelf.addressArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull selectedAddressSourceArray, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx >= selectedIndexArray.count) return;  // 容错判断
                NSInteger selectedIndex = [selectedIndexArray[idx] integerValue];
                
                if (selectedIndex >= selectedAddressSourceArray.count) return;
                [arrayM addObject:selectedAddressSourceArray[selectedIndex]];
            }];
            
            if (strongSelf.didSelectBlock) strongSelf.didSelectBlock(arrayM);
            [strongSelf dismiss];
        };
        
        _pickerView.cancelBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.cancelBlock) strongSelf.cancelBlock();
        };
    }
    return _pickerView;
}

- (BMAddressSourceManager *)addressSourceManager {
    if (!_addressSourceManager) {
        _addressSourceManager = [BMAddressSourceManager new];
        
        __weak typeof(self) weakSelf = self;
        _addressSourceManager.finishedGetRegionBlock = ^(NSArray<BMRegionModel *> *regionArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf addNextAddressData:regionArray];
        };
        
        _addressSourceManager.finishedGetSelectedDataSourceBlock = ^(NSArray<BMRegionModel *> *selectedArray, NSArray<NSArray<BMRegionModel *> *> *selectedDataSource) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf setPickerViewSelectedArrayWithSelectedArray:selectedArray DataSource:selectedDataSource];
        };
    }
    return _addressSourceManager;
}

@end
