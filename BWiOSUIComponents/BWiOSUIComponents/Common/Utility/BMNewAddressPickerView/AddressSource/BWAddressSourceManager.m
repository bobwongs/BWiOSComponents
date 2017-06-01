//
//  BWAddressSourceManager.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressSourceManager.h"
#import <FMDB.h>
#import "BMAddressModel.h"

NSString *const BMAddressTypeProvince = @"BMAddressTypeProvince";
NSString *const BMAddressTypeCity = @"BMAddressTypeCity";
NSString *const BMAddressTypeCounty = @"BMAddressTypeCounty";

@interface BWAddressSourceManager ()

@property (strong, nonatomic) FMDatabase *database;

@end

@implementation BWAddressSourceManager

- (NSArray<BMAddressModel *> *)addressSourceArrayWithParentCode:(NSInteger)parentCode addressType:(NSString *)addressType {
    NSMutableArray *arrayM = [NSMutableArray new];
    if (![self.database open]) {
        NSLog(@"数据库打开失败");
        return arrayM;
    }
    
    NSString *sqlString;
    if ([addressType isEqualToString:BMAddressTypeProvince]) {
        sqlString = [NSString stringWithFormat:@"select * from province"];
    }
    else if ([addressType isEqualToString:BMAddressTypeCity]) {
        sqlString = [NSString stringWithFormat:@"select * from city where pcode = %ld", (long)parentCode];
    }
    else if ([addressType isEqualToString:BMAddressTypeCounty]) {
        sqlString = [NSString stringWithFormat:@"select * from county where pcode = %ld", (long)parentCode];
    }
    else {
        return arrayM;
    }
    
    FMResultSet *set = [self.database executeQuery:sqlString];
    while ([set next]) {
        BMAddressModel *model = [BMAddressModel new];
        model.code = [set intForColumn:@"dcode"];
        model.name = [set stringForColumn:@"dname"];
        model.type = [set stringForColumn:@"type"];
        model.parentCode = [set intForColumn:@"pcode"];
        [arrayM addObject:model];
    }
    [self.database close];
    
    return [NSArray new];
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
