//
//  BMAddressSourceManager.m
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMAddressSourceManager.h"
#import "BMRegionModel.h"
#import "BMAddressPickerAppearance.h"
#import <FMDB.h>

NSString *const BWAddressTypeProvince = @"province";
NSString *const BWAddressTypeCity = @"city";
NSString *const BWAddressTypeCounty = @"county";

@interface BMAddressSourceManager ()

@property (strong, nonatomic) FMDatabase *database;

@property (strong, nonatomic) NSArray<BMRegionModel *> *selectedRegionArray;
@property (strong, nonatomic) NSMutableArray<NSArray<BMRegionModel *> *> *selectedRegionDataSource;

@end

@implementation BMAddressSourceManager

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.selectedRegionDataSource = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Public Method

- (void)getAddressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType {
    switch (self.dataSourceType) {
//        case BMAddressDataSourceTypeNormal:
    }
}

- (void)getSelectedAddressSourceWithRegionArray:(NSArray<BMRegionModel *> *)regionArray {
    self.selectedRegionArray = regionArray;
    [self.selectedRegionDataSource removeAllObjects];  // 先移除原来的
    
    NSMutableArray<BMRegionModel *> *arrayM = [NSMutableArray arrayWithArray:regionArray];
    [arrayM removeLastObject];  // 不用去加载最后一级的数据
    
    BMRegionModel *topRegionModel = [BMRegionModel new];
    topRegionModel.dcode = @"";
    [arrayM insertObject:topRegionModel atIndex:0];  // 需要加载省份数据
    
    switch (self.dataSourceType) {

    }
}

#pragma mark - Private Method

/** 获取完已选中的数据，首先会判断数据是否完全 */
- (void)finishedGetSelectedDataSource {
    // 都加载完，虽然用来发起请求的数据不是selectedRegionArray，但这里的处理先用着这个来判断，暂不用新的成员变量来记录
    if (self.selectedRegionDataSource.count < self.selectedRegionArray.count) return;
    
    NSArray *dataSource = [NSArray arrayWithArray:self.selectedRegionDataSource];
    for (NSArray *array in dataSource) {
        if (array.count == 0) [self.selectedRegionDataSource removeObject:array];  // 移除空数组，不能又遍历自身又做移除
    }
    
    // 排序，Province-City-County
    [self.selectedRegionDataSource sortUsingComparator:^NSComparisonResult(NSArray<BMRegionModel *> * _Nonnull array1, NSArray<BMRegionModel *> * _Nonnull array2) {
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

- (NSArray<BMRegionModel *> *)addressSourceArrayWithParentCode:(NSInteger)parentCode addressType:(NSString *)addressType {
    NSMutableArray *arrayM = [NSMutableArray new];
    if (![self.database open]) {
        NSLog(@"数据库打开失败");
        return arrayM;
    }
    
    NSString *sqlString;
    if ([addressType isEqualToString:BWAddressTypeProvince]) {
        sqlString = [NSString stringWithFormat:@"select * from province"];
    }
    else if ([addressType isEqualToString:BWAddressTypeCity]) {
        sqlString = [NSString stringWithFormat:@"select * from city where pcode = %ld", (long)parentCode];
    }
    else if ([addressType isEqualToString:BWAddressTypeCounty]) {
        sqlString = [NSString stringWithFormat:@"select * from county where pcode = %ld", (long)parentCode];
    }
    else {
        return arrayM;
    }
    
    FMResultSet *set = [self.database executeQuery:sqlString];
    while ([set next]) {
        BMRegionModel *model = [BMRegionModel new];
        model.dcode = @([set intForColumn:@"dcode"]).stringValue;
        model.dname = [set stringForColumn:@"dname"];
        model.type = [set stringForColumn:@"type"];
        model.pcode = [set intForColumn:@"pcode"];
        [arrayM addObject:model];
    }
    [self.database close];
    
    return arrayM;
}

#pragma mark - Setter and Getter


- (FMDatabase *)database {
    if (!_database) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"db"];
        _database = [FMDatabase databaseWithPath:path];
    }
    return _database;
}

@end
