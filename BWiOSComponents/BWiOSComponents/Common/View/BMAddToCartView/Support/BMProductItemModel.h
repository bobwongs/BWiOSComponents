//
//  BMProductItemModel.h
//  B2BMall
//
//  Created by BobWong on 17/09/01.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMImageModel.h"

@interface BMProductItemModel : NSObject

@property (assign, nonatomic) double buyingPrice;  ///< 进货价（箱）（单位：分）
@property (assign, nonatomic) double carton;  ///< 箱规
@property (assign, nonatomic) NSInteger itemId;  ///< 商品id
@property (assign, nonatomic) double marketUnitPrice;  ///< 进货价（支）（单位：分）
@property (strong, nonatomic) NSString *name;  ///< 商品名称
@property (strong, nonatomic) BMImageModel *itemImage;  ///< 产品图片地址
@property (assign, nonatomic) double salePrice;  ///< 建议零售价（单位：分）
@property (strong, nonatomic) NSString *unit;  ///< 內箱单位

@end
