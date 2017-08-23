//
//  BMNewAddressSourceManager.h
//  BMiOSUIComponents
//
//  Created by BoBMong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMNewRegionModel;

#define BM_ADDRESS_TYPE_ARRAY @[BMAddressTypeProvince, BMAddressTypeCity, BMAddressTypeCounty]  // 类型数组

/** 地址数据源类型 */
typedef NS_ENUM(NSInteger, BMAddressDataSourceType) {
    BMAddressDataSourceTypeDB,  // 默认
    BMAddressDataSourceTypeSAP
};

typedef void (^BMNewAddressSourceManagerFinishedGetRegionBlock)(NSArray<BMNewRegionModel *> *);
typedef void (^BMNewAddressSourceManagerFinishedGetSelectedDataSourceBlock)(NSArray<BMNewRegionModel *> *, NSArray<NSArray<BMNewRegionModel *> *> *);

@interface BMNewAddressSourceManager : NSObject

@property (assign, nonatomic) BMAddressDataSourceType dataSourceType;

@property (copy, nonatomic) BMNewAddressSourceManagerFinishedGetRegionBlock finishedGetRegionBlock;  ///< 获取数据源成功后的回调Block

/** 获取地址数据源
 *  @param parentCode 父地址编码
 *  @param addressType 要获取的地址类型
 */
- (void)getAddressSourceArrayWithParentCode:(NSString *)parentCode addressType:(NSString *)addressType;


@property (copy, nonatomic) BMNewAddressSourceManagerFinishedGetSelectedDataSourceBlock finishedGetSelectedDataSourceBlock;  ///< 成功获取所有选中地址的下一级数据源回到Block

- (void)getSelectedAddressSourceWithRegionArray:(NSArray<BMNewRegionModel *> *)regionArray;

@end
