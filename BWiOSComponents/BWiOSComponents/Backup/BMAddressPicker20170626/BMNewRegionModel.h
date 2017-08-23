//
//  BMNewRegionModel.h
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BMAddressTypeProvince;
extern NSString *const BMAddressTypeCity;
extern NSString *const BMAddressTypeCounty;

@interface BMNewRegionModel : NSObject

@property (assign, nonatomic) NSString *dcode;  ///< 区域编码
@property (strong, nonatomic) NSString *dname;  ///< 区域名称，使用String类型，为了兼容SAP的地址
@property (assign, nonatomic) NSInteger pcode;  ///< 上级区域编码
@property (strong, nonatomic) NSString *type;  ///< 区域类型

@end
