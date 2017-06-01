//
//  BMNewAddressPickerManager.m
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMNewAddressPickerManager.h"
#import "BMNewAddressPickerView.h"
#import "BMAddressGetRegionAPIManager.h"
#import <MJExtension.h>

@interface BMNewAddressPickerManager () <BMAPIManagerCallBackDelegate>

/* UI */
@property (strong, nonatomic) BMNewAddressPickerView *pickerView;

/* Data */
@property (strong, nonatomic) BMAddressGetRegionAPIManager *getRegionAPIManager;  ///< Get region api

@property (strong, nonatomic) NSMutableArray *addressArray;  ///< 地址数据源

@end

@implementation BMNewAddressPickerManager

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
    [self.getRegionAPIManager loadDataWithParams:@{}];
}

- (void)dismiss {
    [_pickerView dismiss];
}

#pragma mark - Custom Delegate

- (void)managerCallApiDidSuccess:(BMBaseAPIManager *)manager
{
    [BMShowHUD dismiss:self.pickerView];
    NSDictionary *responseData = [manager fetchDataWithReformer:nil];
    
    // 用数据去刷新pickerView
    NSArray<BMNewAddressModel *> *array = [BMNewAddressModel mj_objectArrayWithKeyValuesArray:responseData[@"lists"]];
    [self.addressArray addObject:array];
    
    NSMutableArray *nameArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(BMNewAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:model.dname];
    }];
    
    [_pickerView addNextAddressDataWithNewAddressArray:nameArray];
    
    // 第一次显示
    if (_addressArray.count == 1) {
        [_pickerView show];
    }
}

- (void)managerCallApiDidFailed:(BMBaseAPIManager *)manager
{
    [BMManagerMsgShow showPromptMessageWithManager:manager toView:self.pickerView];
}

#pragma mark - Private Method

- (void)setData {
    self.addressArray = [NSMutableArray new];
    
    _pickerView = [BMNewAddressPickerView new];
    __weak typeof(self) weakSelf = self;
    _pickerView.getDataBlock = ^(NSUInteger selectedSection, NSUInteger selectedRow) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BMNewAddressModel *model = strongSelf.addressArray[selectedSection][selectedRow];
        [strongSelf getRegionDataWithParentModel:model];
    };
    _pickerView.didSelectBlock = ^(NSMutableArray *selectedIndexArray) {
        NSLog(@"selected index array is %@", selectedIndexArray);
    };
    _pickerView.removeAddressArrayObjectBlock = ^(NSRange range) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.addressArray removeObjectsInRange:range];
    };
}

- (void)getRegionDataWithParentModel:(BMNewAddressModel *)model {
    NSArray *typeArray = @[@"province", @"city", @"county"];  // 奇葩，靠前端写查询的类型字段，以后要求后端返回下一级的类型字段
    NSInteger typeIndex = _addressArray.count;
    if (typeIndex > typeArray.count - 1) return;
    
    [self.getRegionAPIManager loadDataWithParams:@{
                                                   @"pid": model.dcode,
                                                   @"type": typeArray[typeIndex]
                                                   }];
}

#pragma mark - Setter and Getter

- (BMAddressGetRegionAPIManager *)getRegionAPIManager {
    if (!_getRegionAPIManager) {
        _getRegionAPIManager = [[BMAddressGetRegionAPIManager alloc] init];
        _getRegionAPIManager.apiCallBackDelegate = self;
    }
    return _getRegionAPIManager;
}

@end


@implementation BMNewAddressModel

@end
