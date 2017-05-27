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

@interface BMNewAddressPickerManager () <BMAPIManagerCallBackDelegate>

@property (strong, nonatomic) BMNewAddressPickerView *pickerView;

@property (strong, nonatomic) BMAddressGetRegionAPIManager *getRegionAPIManager;  ///< Get region api

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
    [_pickerView show];
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
}

- (void)managerCallApiDidFailed:(BMBaseAPIManager *)manager
{
    [BMManagerMsgShow showPromptMessageWithManager:manager toView:self.pickerView];
}

#pragma mark - Private Method

- (void)setData {
    _pickerView = [BMNewAddressPickerView new];
    __weak typeof(self) weakSelf = self;
    _pickerView.getDataBlock = ^(NSUInteger selectedIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
//        [strongSelf getRegionDataWithParentAddressId:addressId];
    };
    _pickerView.didSelectBlock = ^(NSMutableArray *selectedIndexArray) {
        
    };
}

- (void)getRegionDataWithParentAddressId:(NSString *)addressId {
    [self.getRegionAPIManager loadDataWithParams:@{
                                                   
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
