//
//  BWAddressPickerManager.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressPickerManager.h"
#import "BWAddressPickerView.h"
#import "BWAddressSourceManager.h"
#import "BWAddressModel.h"

@interface BWAddressPickerManager ()

/* UI */
@property (strong, nonatomic) BWAddressPickerView *pickerView;

/* Data */
@property (strong, nonatomic) BWAddressSourceManager *addressSourceManager;  ///< Address source manager

@property (strong, nonatomic) NSMutableArray<NSArray *> *addressArray;  ///< 地址数据源

@end

@implementation BWAddressPickerManager

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
        [_pickerView show];
        return;
    }
    
    [self getRegionDataWithParentModel:nil];
}

- (void)dismiss {
    [_pickerView dismiss];
}

#pragma mark - Private Method

- (void)setData {
    self.addressArray = [NSMutableArray new];
    self.addressSourceManager = [BWAddressSourceManager new];
    
    _pickerView = [BWAddressPickerView new];
    
    __weak typeof(self) weakSelf = self;
    _pickerView.getDataBlock = ^(NSUInteger selectedSection, NSUInteger selectedRow) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BWAddressModel *model = strongSelf.addressArray[selectedSection][selectedRow];
        [strongSelf getRegionDataWithParentModel:model];
    };
    
    _pickerView.removeAddressSourceArrayObjectBlock = ^(NSRange range) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.addressArray removeObjectsInRange:range];
    };
    
    _pickerView.didSelectBlock = ^(NSMutableArray *selectedIndexArray) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"selected index array is %@", selectedIndexArray);
        
        // 选中的BWAddressModel添加进数组
        NSMutableArray *arrayM = [NSMutableArray new];
        [strongSelf.addressArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull selectedAddressSourceArray, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger selectedIndex = [selectedIndexArray[idx] integerValue];
            [arrayM addObject:selectedAddressSourceArray[selectedIndex]];
        }];
        
        if (strongSelf.didSelectBlock) strongSelf.didSelectBlock(arrayM);
        [strongSelf dismiss];
    };
}

- (void)getRegionDataWithParentModel:(BWAddressModel *)parentModel {
    NSArray *typeArray = @[BWAddressTypeProvince, BWAddressTypeCity, BWAddressTypeCounty];
    NSInteger typeIndex = _addressArray.count;
    if (typeIndex > typeArray.count - 1) return;
    
    // 用数据去刷新pickerView
    NSInteger parentCode = parentModel ? parentModel.code : 0;
    NSArray<BWAddressModel *> *array = [self.addressSourceManager addressSourceArrayWithParentCode:parentCode addressType:typeArray[typeIndex]];
    [self.addressArray addObject:array];
    
    NSMutableArray *nameArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(BWAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.name];
    }];
    
    [_pickerView addNextAddressDataWithNewAddressArray:nameArray];
    
    // 第一次显示
    if (_addressArray.count == 1) {
        [_pickerView show];
    }
}

@end
