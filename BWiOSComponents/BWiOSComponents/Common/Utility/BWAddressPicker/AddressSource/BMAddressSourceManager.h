//
//  BMAddressSourceManager.h
//  BMiOSUIComponents
//
//  Created by BoBWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWRegionModel;

#define BM_ADDRESS_TYPE_ARRAY @[BMAddressTypeProvince, BMAddressTypeCity, BMAddressTypeCounty]  // 类型数组

/** 地址数据源类型 */
typedef NS_ENUM(NSInteger, BMAddressDataSourceType) {
    BMAddressDataSourceTypeNormal  // 默认，从数据库中获取数据
};

typedef void (^BMAddressSourceManagerFinishedGetRegionBlock)(NSArray<BWRegionModel *> *);
typedef void (^BMAddressSourceManagerFinishedGetSelectedDataSourceBlock)(NSArray<BWRegionModel *> *, NSArray<NSArray<BWRegionModel *> *> *);

@interface BMAddressSourceManager : NSObject

@property (assign, nonatomic) BMAddressDataSourceType dataSourceType;

@property (copy, nonatomic) BMAddressSourceManagerFinishedGetRegionBlock finishedGetRegionBlock;  ///< 获取数据源成功后的回调Block

/** 获取地址数据源
 *  @param parentCode 父地址编码
 *  @param addressType 要获取的地址类型
 */
- (void)getAddressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType;


@property (copy, nonatomic) BMAddressSourceManagerFinishedGetSelectedDataSourceBlock finishedGetSelectedDataSourceBlock;  ///< 成功获取所有选中地址的下一级数据源回到Block

- (void)getSelectedAddressSourceWithRegionArray:(NSArray<BWRegionModel *> *)regionArray;

@end
