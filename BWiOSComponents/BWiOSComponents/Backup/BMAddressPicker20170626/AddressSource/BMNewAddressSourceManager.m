//
//  BMNewAddressSourceManager.m
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMNewAddressSourceManager.h"
#import <FMDB.h>
#import "BMNewRegionModel.h"
#import "BMSAPGetRegionAPIManager.h"
#import <MJExtension.h>

@interface BMNewAddressSourceManager () <BMAPIManagerCallBackDelegate>

@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) BMSAPGetRegionAPIManager *getSAPRegionAPIMng;

@property (strong, nonatomic) BMSAPGetRegionAPIManager *getSAPSelectedRegionAPIMng;
@property (strong, nonatomic) NSArray<BMNewRegionModel *> *selectedRegionArray;
@property (strong, nonatomic) NSMutableArray<NSArray<BMNewRegionModel *> *> *selectedRegionDataSource;

@end

@implementation BMNewAddressSourceManager

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.dataSourceType = BMAddressDataSourceTypeDB;
        self.selectedRegionDataSource = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Public Method

- (void)getAddressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType {
    switch (self.dataSourceType) {
        case BMAddressDataSourceTypeDB:
            [self db_addressSourceArrayWithParentCode:parentCode addressType:addressType];
            break;
        case BMAddressDataSourceTypeSAP:
            [self sap_addressSourceArrayWithParentCode:parentCode addressType:addressType];
            break;
    }
}

- (void)getSelectedAddressSourceWithRegionArray:(NSArray<BMNewRegionModel *> *)regionArray {
    self.selectedRegionArray = regionArray;
    [self.selectedRegionDataSource removeAllObjects];  // 先移除原来的
    
    NSMutableArray<BMNewRegionModel *> *arrayM = [NSMutableArray arrayWithArray:regionArray];
    [arrayM removeLastObject];  // 不用去加载最后一级的数据
    
    BMNewRegionModel *topRegionModel = [BMNewRegionModel new];
    topRegionModel.dcode = @"";
    [arrayM insertObject:topRegionModel atIndex:0];  // 需要加载省份数据
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [arrayM enumerateObjectsUsingBlock:^(BMNewRegionModel * _Nonnull regionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.getSAPSelectedRegionAPIMng loadDataWithParams:@{@"pid": regionModel.dcode ? regionModel.dcode : @"",
                                                                    @"type": BM_ADDRESS_TYPE_ARRAY[idx]}];  // 根据序列去加载，不能直接传Model里面的，Model里面会相差一级
    }];
}

#pragma mark - Network

- (void)managerCallApiDidSuccess:(BMBaseAPIManager *)manager {
    NSDictionary *responseData = [manager fetchDataWithReformer:nil];
    
    if (self.getSAPRegionAPIMng == manager) {
        [SVProgressHUD dismiss];
        NSArray<BMNewRegionModel *> *regionArray = [BMNewRegionModel mj_objectArrayWithKeyValuesArray:responseData[@"lists"]];
        if (self.finishedGetRegionBlock) self.finishedGetRegionBlock(regionArray);
    }
    else if (self.getSAPSelectedRegionAPIMng == manager) {
        NSArray<BMNewRegionModel *> *regionArray = [BMNewRegionModel mj_objectArrayWithKeyValuesArray:responseData[@"lists"]];
        [self.selectedRegionDataSource addObject:regionArray];
        
        if (self.selectedRegionDataSource.count >= self.selectedRegionArray.count) {  // 都加载完，虽然用来发起请求的数据不是selectedRegionArray，但这里的处理先用着这个来判断，暂不用新的成员变量来记录
            [SVProgressHUD dismiss];
            [self finishedGetSelectedDataSource];
        }
    }
}

- (void)managerCallApiDidFailed:(BMBaseAPIManager *)manager {
    [BMPromptMessage showPromptMessageWithManager:manager];
}

#pragma mark - Private Method

- (void)db_addressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType {
    NSMutableArray<BMNewRegionModel *> *arrayM = [NSMutableArray new];
    if (![self.database open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    NSString *sqlString;
    if ([addressType isEqualToString:BMAddressTypeProvince]) {
        sqlString = [NSString stringWithFormat:@"select * from province"];
    }
    else if ([addressType isEqualToString:BMAddressTypeCity]) {
        sqlString = [NSString stringWithFormat:@"select * from city where pcode = %ld", (long)parentCode.integerValue];
    }
    else if ([addressType isEqualToString:BMAddressTypeCounty]) {
        sqlString = [NSString stringWithFormat:@"select * from county where pcode = %ld", (long)parentCode.integerValue];
    }
    else {
        return;
    }
    
    FMResultSet *set = [self.database executeQuery:sqlString];
    while ([set next]) {
        BMNewRegionModel *model = [BMNewRegionModel new];
        model.dcode = @([set intForColumn:@"dcode"]).stringValue;
        model.dname = [set stringForColumn:@"dname"];
        model.type = [set stringForColumn:@"type"];
        model.pcode = [set intForColumn:@"pcode"];
        [arrayM addObject:model];
    }
    [self.database close];
    
    if (self.finishedGetRegionBlock) self.finishedGetRegionBlock(arrayM);
}

- (void)sap_addressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType {
    [SVProgressHUD show];
    [self.getSAPRegionAPIMng loadDataWithParams:@{@"pid": parentCode ? parentCode : @"",
                                                  @"type": addressType ? addressType : @""}];
}

- (void)finishedGetSelectedDataSource {
    NSArray *dataSource = [NSArray arrayWithArray:self.selectedRegionDataSource];
    for (NSArray *array in dataSource) {
        if (array.count == 0) [self.selectedRegionDataSource removeObject:array];  // 移除空数组，不能又遍历自身又做移除
    }
    
    // 排序，Province-City-County
    [self.selectedRegionDataSource sortUsingComparator:^NSComparisonResult(NSArray<BMNewRegionModel *> * _Nonnull array1, NSArray<BMNewRegionModel *> * _Nonnull array2) {
        NSString *type1 = array1.firstObject.type;
        NSString *type2 = array2.firstObject.type;
        
        if ([type1 isEqualToString:BMAddressTypeProvince]) {
            return NSOrderedAscending;
        } else if ([type2 isEqualToString:BMAddressTypeProvince]) {
            return NSOrderedDescending;
        } else if ([type1 isEqualToString:BMAddressTypeCity]) {
            return NSOrderedAscending;
        } else if ([type2 isEqualToString:BMAddressTypeCity]) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    if (self.finishedGetSelectedDataSourceBlock) self.finishedGetSelectedDataSourceBlock(self.selectedRegionArray, self.selectedRegionDataSource);
}

#pragma mark - Setter and Getter

- (FMDatabase *)database {
    if (!_database) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"db"];
        _database = [FMDatabase databaseWithPath:path];
    }
    return _database;
}

- (BMSAPGetRegionAPIManager *)getSAPRegionAPIMng {
    if (!_getSAPRegionAPIMng) {
        _getSAPRegionAPIMng = [BMSAPGetRegionAPIManager new];
        _getSAPRegionAPIMng.apiCallBackDelegate = self;
    }
    return _getSAPRegionAPIMng;
}

- (BMSAPGetRegionAPIManager *)getSAPSelectedRegionAPIMng {
    if (!_getSAPSelectedRegionAPIMng) {
        _getSAPSelectedRegionAPIMng = [BMSAPGetRegionAPIManager new];
        _getSAPSelectedRegionAPIMng.apiCallBackDelegate = self;
    }
    return _getSAPSelectedRegionAPIMng;
}

@end
